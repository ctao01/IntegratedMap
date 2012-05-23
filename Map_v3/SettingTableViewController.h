//
//  SettingTableViewController.h
//  Map_v3.7
//
//  Created by Joy Tao on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook+Singleton.h"

#define kAppId @"282603195164997"

typedef enum  {
    UserNameSetting = 0,
    AccountSetting = 1, 
    ControlSetting = 2, 
    OtherSetting = 3,
} SettingSection;

@interface SettingTableViewController : UITableViewController <UIAlertViewDelegate , FBRequestDelegate>

@property (nonatomic, assign) UIViewController * vcParent;
@end
