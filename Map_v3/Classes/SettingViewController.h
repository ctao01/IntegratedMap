//
//  SettingViewController.h
//  Map_v3
//
//  Created by Joy Tao on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyMap.h"
#import "MyPlace.h"
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
- (void) updateMapsWithAuth:(NSString*)clientAuth andAMap:(MyMap*)theMap;
- (void) updateMapFeaturesWithAuth:(NSString*)clientAuth andAMap:(MyMap*)theMap andContentURL:(NSString*)theContentURL;

//- (void) generatingKMLFileWithPlace:(NSDictionary*)thePlace;
//- (NSString *)KMLString:generatingKMLFileWithPlace:(NSDictionary*)thePlace;
- (NSString *) generatingKMLFileWithPlace:(NSDictionary*)thePlace;
- (NSString *) creatingKMLFileWithMap:(MyMap *)theMap;
- (NSString *) creatingCSVFileWithMap:(MyMap *)theMap;
@end
