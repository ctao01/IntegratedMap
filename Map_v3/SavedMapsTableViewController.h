//
//  SavedMapsTableViewController.h
//  Map_v3.6
//
//  Created by Joy Tao on 3/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SavedMapsTableViewController : UITableViewController <UIAlertViewDelegate>

@property (nonatomic ,retain) NSMutableArray * googleMaps;
@property (nonatomic ,retain) NSMutableArray * gSavedMaps;

- (NSMutableArray * ) retrieveMapsWithAuth:(NSString*)clientAuth;
- (NSMutableArray *)retrievePlacemakrsFromContentURL:(NSString*)mapContent andAuthToken:(NSString*)clientAuth;

@end
