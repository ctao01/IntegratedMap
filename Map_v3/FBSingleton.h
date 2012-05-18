//
//  FBSingleton.h
//  Map_v3.7
//
//  Created by Joy Tao on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"

#define kAppID @""
#define APPLICATION_USERDEFAULTS  [NSUserDefaults standardDefaults]

@interface FBSingleton : NSObject <FBSessionDelegate , FBDialogDelegate , FBRequestDelegate >
{
    Facebook * _facebook;
    NSArray * _permissions;
}

@property (readonly) Facebook * facebook;

@end
