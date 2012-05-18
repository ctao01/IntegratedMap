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
        _facebook.accessToken = [APPLICATION_USERDEFAULTS objectForKey:@"FBAccessTokenKey"];
        _facebook.expirationDate = [APPLICATION_USERDEFAULTS objectForKey:@"FBExpirationDateKey"];
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

@end
