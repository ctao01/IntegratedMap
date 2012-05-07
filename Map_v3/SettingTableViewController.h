//
//  SettingTableViewController.h
//  Map_v3.7
//
//  Created by Joy Tao on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum  {
    AccountSetting = 0, 
    ControlSetting =1, 
    OtherSetting = 2,
} SettingSection;

@interface SettingTableViewController : UITableViewController

@property (nonatomic, assign) UIViewController * vcParent;
@property (nonatomic, retain) Facebook * facebook;
@end
