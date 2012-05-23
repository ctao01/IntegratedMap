//
//  FBSingleton.m
//  Map_v3.7
//
//  Created by Joy Tao on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FBSingleton.h"

@implementation FBSingleton
@synthesize facebook = _facebook;

#pragma mark - Singleton Variables

static FBSingleton * singletonDelegate = nil;

#pragma mark - Singleton Methods

- (id) init
{
    if (!kAppID) return nil;
    if (self = [super init])
    {
        _facebook = [[Facebook alloc]initWithAppId:kAppID andDelegate:self];
        _facebook.accessToken = [APPLICATION_DEFAULTS objectForKey:@"FBAccessTokenKey"];
        _facebook.expirationDate = [APPLICATION_DEFAULTS objectForKey:@"FBExpirationDateKey"];
        _permissions = [[[NSArray alloc] initWithObjects:
                                @"user_activities", 
                                @"read_friendlists",
                                @"offline_access",
                                nil] retain];
        
    }
    return self;
}

+ (FBSingleton *) sharedManager
{
    @synchronized(self) {
		if (singletonDelegate == nil) {
			[[self alloc] init]; // assignment not done here
		}
	}
    return singletonDelegate;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if (singletonDelegate == nil) {
			singletonDelegate = [super allocWithZone:zone];
			// assignment and return on first allocation
			return singletonDelegate;
		}
	}
	// on subsequent allocation attempts return nil
	return nil;
}

- (id)copyWithZone:(NSZone *)zone {
	return self;
}

- (id)retain {
	return self;
}

- (unsigned)retainCount {
	return UINT_MAX;  // denotes an object that cannot be released
}

- (oneway void)release {
	//do nothing
}

- (id)autorelease {
	return self;
}

#pragma mark - Facebook Graph API

- (void)apiGraphMe {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"name,picture",  @"fields",
                                   nil];
    [_facebook requestWithGraphPath:@"me" andParams:params andDelegate:self];

}

#pragma mark - FBSessionDelegate Methods

- (void)fbDidLogin {
    NSLog(@"FB login OK");
    
    // Store session info.
    [[NSUserDefaults standardUserDefaults] setObject:_facebook.accessToken forKey:@"AccessToken"];
    [[NSUserDefaults standardUserDefaults] setObject:_facebook.expirationDate forKey:@"ExpirationDate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FBDidLogin" object:self];

}

/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled {
    NSLog(@"FB did not login");
    
    if (cancelled) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FBLoginCancelled" object:self];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FBLoginFailed" object:self];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FBDidNotLogin" object:self];
}

/**
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout {
    NSLog(@"FB logout OK");
    
    // Release stored session.
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"AccessToken"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"ExpirationDate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 * Called after the access token was extended. If your application has any
 * references to the previous access token (for example, if your application
 * stores the previous access token in persistent storage), your application
 * should overwrite the old access token with the new one in this method.
 * See extendAccessToken for more details.
 */
- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt 
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FBDidExtendToken" object:self];

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


#pragma mark - FBRequestDelegate Methods

/**
 * Called just before the request is sent to the server.
 */
- (void)requestLoading:(FBRequest *)request
{
}

/**
 * Called when the server responds and begins to send back data.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"received response");

}

/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"FB error: %@", [error localizedDescription]);
}

/**
 * Called when a request returns and its response has been parsed into
 * an object.
 *
 * The resulting object may be a dictionary, an array, a string, or a number,
 * depending on thee format of the API response.
 */
- (void)request:(FBRequest *)request didLoad:(id)result
{
    NSLog(@"FB request OK");
    
    if ([result isKindOfClass:[NSArray class]]) {
        result = [result objectAtIndex:0];
    }
    if ([result isKindOfClass:[NSDictionary class]])
    {
        NSString * fbUsername = [result objectForKey:@"name"];
        [APPLICATION_DEFAULTS setObject:fbUsername forKey:@"FB_USERNAME"];
        [APPLICATION_DEFAULTS synchronize];
    }
}

/**
 * Called when a request returns a response.
 *
 * The result object is the raw response from the server of type NSData
 */
- (void)request:(FBRequest *)request didLoadRawResponse:(NSData *)data
{
    
}
@end
