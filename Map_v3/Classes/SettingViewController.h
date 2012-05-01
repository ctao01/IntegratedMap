//
//  SettingViewController.h
//  Map_v3
//
//  Created by Joy Tao on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


//@class SettingViewController;
//
//@protocol SettingViewDelegate <NSObject>
//
//- (void) retrieveMapsWithAuth:(NSString*)clientAuth;
//- (NSMutableArray *)retrievePlacemakrsFromContentURL:(NSString*)mapContent andAuthToken:(NSString*)clientAuth;
//
//- (NSString *) creatingCSVFileWithMap:(MyMap *)theMap;
//
//- (void) updateMapsWithAuth:(NSString*)clientAuth andAMap:(MyMap*)theMap;
//- (void) updateMapFeaturesWithAuth:(NSString*)clientAuth andAMap:(MyMap*)theMap andContentURL:(NSString*)theContentURL;
//
//@end


@interface SettingViewController : UIViewController
{
    UITextField * usernameField;
    UITextField * passwordField;
}

- (void) retrieveMapsWithAuth:(NSString*)clientAuth;
- (NSMutableArray *)retrievePlacemakrsFromContentURL:(NSString*)mapContent andAuthToken:(NSString*)clientAuth;

//#pragma mark - Uploading XML 
//- (void) updateMapsWithAuth:(NSString*)clientAuth andAMap:(MyMap*)theMap;
//- (void) updateMapFeaturesWithAuth:(NSString*)clientAuth andAMap:(MyMap*)theMap andContentURL:(NSString*)theContentURL;
//- (NSString *) creatingCSVFileWithMap:(MyMap *)theMap;

@end
