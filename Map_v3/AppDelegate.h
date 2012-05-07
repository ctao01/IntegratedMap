//
//  AppDelegate.h
//  Map_v3
//
//  Created by Joy Tao on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

#define kAPPID @"282603195164997"

@interface AppDelegate : NSObject  <UIApplicationDelegate> 

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic , retain) UINavigationController * navigationController;
@property (nonatomic , retain) RootViewController * rootViewController;

// store data
@property (nonatomic , copy) NSString * path;
@property (nonatomic , retain) NSMutableArray * savedMaps;
@property (nonatomic , retain) Facebook * facebook;
@end
