//
//  Facebook+Singleton.h
//  Map_v3.7
//
//  Created by Joy Tao on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FBConnect.h"

#define kFBAccessTokenKey		@"FBAccessTokenKey"
#define kFBExpirationDateKey	@"FBExpirationDateKey"
#define kAppId					@"282603195164997"

@interface Facebook(Singleton) <FBSessionDelegate>

- (void) authorize;
//- (void) fbLogout;

+(Facebook *) shared;

@end
