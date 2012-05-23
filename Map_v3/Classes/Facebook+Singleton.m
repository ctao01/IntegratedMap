//
//  Facebook+Singleton.m
//  Map_v3.7
//
//  Created by Joy Tao on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Facebook+Singleton.h"

@interface Facebook (SingletonPrivate)

- (void)authorize:(NSArray *)permissions localAppId:(NSString *)localAppId;
- (void)authorizeInApp:(NSArray *)permissions localAppId:(NSString *)localAppId;
- (void)authorizeWithFacebookApp:(NSArray *)permissions localAppId:(NSString *)localAppId;
- (void)authorizeWithFBAppAuth:(BOOL)tryFBAppAuth safariAuth:(BOOL)trySafariAuth;

@end

@implementation Facebook (Singleton)
+ (Facebook*)shared
{
    static dispatch_once_t pred;
	static Facebook *fbSharedInstance = nil;
	dispatch_once(&pred, ^{ fbSharedInstance = [[self alloc] init]; });
	return fbSharedInstance;
}

- (id)init {
    
    if ((self = [self initWithAppId:kAppId andDelegate:self])) {
        [self authorize];
    }    
    return self;
}

- (void)authorize {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:kFBAccessTokenKey] && [defaults objectForKey:kFBExpirationDateKey]) {
        self.accessToken = [defaults objectForKey:kFBAccessTokenKey];
        self.expirationDate = [defaults objectForKey:kFBExpirationDateKey];
    }
    
    if (![self isSessionValid]) {
        //
        // Only ONE of the following authorize methods should be uncommented.
        //
        
        // This is the method Facebook wants users to use. 
        // It will leave your app and authoize through the Facebook app or Safari.
        NSArray *permissions = [[NSArray alloc] initWithObjects:
                                @"user_activities", 
                                @"read_friendlists",
                                @"offline_access",
                                nil];
        
        
        [self authorize:permissions localAppId:kAppId];
        
        // This will authorize from within your app.
        // It will not leave your app nor take advantage of the user logged in elsewhere.
        //[self authorizeInApp:nil localAppId:nil];
        
        // This will only leave your app if the user has the Facebook app.
        // Otherwise it will stay within your app.
        //[self authorizeWithFacebookApp:nil localAppId:nil];
    }
}

- (void)authorize:(NSArray *)permissions localAppId:(NSString *)localAppId {
    _appId = localAppId;
    _permissions = permissions;
    _sessionDelegate = self;
    
    [self authorizeWithFBAppAuth:YES safariAuth:YES];
}

- (void)authorizeInApp:(NSArray *)permissions localAppId:(NSString *)localAppId {
    _appId = localAppId;
    _permissions = permissions;
    _sessionDelegate = self;
    
    [self authorizeWithFBAppAuth:NO safariAuth:NO];
}

- (void)authorizeWithFacebookApp:(NSArray *)permissions localAppId:(NSString *)localAppId {
    _appId = localAppId;
    _permissions = permissions;
    _sessionDelegate = self;
    
    [self authorizeWithFBAppAuth:YES safariAuth:NO];
}

//- (void)fbLogout {
//	[self fbLogout];
//}

#pragma - FBSessionDelegate Methods

/**
 * Called when the user successfully logged in.
 */
- (void)fbDidLogin
{
    NSLog(@"FB login successfully");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self accessToken] forKey:kFBAccessTokenKey];
    [defaults setObject:[self expirationDate] forKey:kFBExpirationDateKey];
    [defaults synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FBDidLogin" object:self];
}

/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)fbDidNotLogin:(BOOL)cancelled
{
    NSLog(@"fbDidNotLogin");
    
    if (cancelled) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FBLoginCancelled" object:self];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FBLoginFailed" object:self];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FBDidNotLogin" object:self];
}

/**
 * Called when the user logged out.
 */
- (void)fbDidLogout
{
    NSLog(@"fbDidLogout");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kFBAccessTokenKey];
    [defaults removeObjectForKey:kFBExpirationDateKey];
    [defaults synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FBDidLogout" object:self];
}

/**
 * Called when the current session has expired. This might happen when:
 *  - the access token expired
 *  - the app has been disabled
 *  - the user revoked the app's permissions
 *  - the user changed his or her password
 */
- (void)fbSessionInvalidated
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"FBSessionInvalidated" object:self];
}

/**
 * Called after the access token was extended. If your application has any
 * references to the previous access token (for example, if your application
 * stores the previous access token in persistent storage), your application
 * should overwrite the old access token with the new one in this method.
 * See extendAccessToken for more details.
 */
- (void)fbDidExtendToken:(NSString*)accessToken expiresAt:(NSDate*)expiresAt
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"FBDidExtendToken" object:self];
}

@end
