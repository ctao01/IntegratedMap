//
//  DetailedViewController.h
//  Map_v3
//
//  Created by Joy Tao on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MyPlace.h"

@class EditableCell;
@class Reachability;
//  Constants representing the book's fields.
//
enum {
    locationName,
    locationAddress_1,
    locationAddress_2,
    locationCity,
    locationState,
    locationZipCode,
    locationCountry,
    locationNote,
};

//  Constants representing the various sections of our grouped table view.
//
enum {
    NameSection,
    LocationSection,
    CommentSection,
};

typedef NSUInteger AnnotationAttribute;

@interface DetailedViewController : UITableViewController < UITextFieldDelegate , MKReverseGeocoderDelegate , UIAlertViewDelegate>
{
    MyPlace * thePlace;
    
    EditableCell * nameCell;
    EditableCell * address1Cell;
    EditableCell * address2Cell;
    EditableCell * cityCell;
    EditableCell * stateCell;
    EditableCell * zipCodeCell;
    EditableCell * countryCell;
    EditableCell * noteCell;
    
    // Check for network connection
    Reachability * internetReachable;
    Reachability * hostReachable;
    BOOL isConnected;
    
}

@property (nonatomic , retain) MyPlace * thePlace;

@property (nonatomic , retain) EditableCell * nameCell;
@property (nonatomic , retain) EditableCell * address1Cell;
@property (nonatomic , retain) EditableCell * address2Cell;
@property (nonatomic , retain) EditableCell * cityCell;
@property (nonatomic , retain) EditableCell * stateCell;
@property (nonatomic , retain) EditableCell * zipCodeCell;
@property (nonatomic , retain) EditableCell * countryCell;
@property (nonatomic , retain) EditableCell * noteCell;

@property (nonatomic , retain) UIViewController * parentViewController;

- (EditableCell *) newDetailCellWithTag:(NSInteger)tag;

- (BOOL)isModal;


- (void) save;
- (void) cancel;
 

@end
