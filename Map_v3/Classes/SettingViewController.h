//
//  SettingViewController.h
//  Map_v3
//
//  Created by Joy Tao on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController
{
    UITextField * usernameField;
    UITextField * passwordField;
}

- (void) retrieveMapsWithAuth:(NSString*)clientAuth;
//- (void) retrievePlacemakrsWithContentURL:(NSString*)mapContent andAuthToken:(NSString*)clientAuth;
- (NSMutableArray *)retrievePlacemakrsFromContentURL:(NSString*)mapContent andAuthToken:(NSString*)clientAuth;

@end
