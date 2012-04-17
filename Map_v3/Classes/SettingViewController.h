//
//  SettingViewController.h
//  Map_v3
//
//  Created by Joy Tao on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyMap.h"

@interface SettingViewController : UIViewController
{
    UITextField * usernameField;
    UITextField * passwordField;
}

#pragma mark - Retrieving a List of Maps
- (void) retrieveMapsWithAuth:(NSString*)clientAuth;

#pragma mark - Retrieving a List of Placemarks
- (NSMutableArray *)retrievePlacemakrsFromContentURL:(NSString*)mapContent andAuthToken:(NSString*)clientAuth;

#pragma mark - Uploading XML 
- (void) updateMapsWithAuth:(NSString*)clientAuth andContentString:(NSString*)theContentString;
- (void) updateMapsWithAuth:(NSString*)clientAuth andFilePath:(NSString*)theFilePath;
- (void) updateMapsWithAuth:(NSString*)clientAuth andAMap:(MyMap*)theMap;



@end
