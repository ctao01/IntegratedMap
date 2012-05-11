//
//  SwitchViewsController.h
//  Map_v3.7
//
//  Created by Joy Tao on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarouselSavedMapsViewController.h"
#import "SavedMapsTableViewController.h"

@interface SwitchViewsController : UIViewController
{
    iCarouselSavedMapsViewController * vcSavedMaps;
    SavedMapsTableViewController * tvSavedMaps;
    
    BOOL tableviewOnTop;
}

@end
