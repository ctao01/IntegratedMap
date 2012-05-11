//
//  MapViewController.h
//  Map_v3
//
//  Created by Joy Tao on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MyMap.h"
#import "CalloutMapAnnotationView.h"

#define OFFSET 40.0f
#define TOP_OFFSET 20.0f
#define BOTTOM_OFFSET 80.0f
#define LEFT_OFFSET 20.0f
#define RIGHT_OFFSET 20.0f


@interface MapViewController : UIViewController <CLLocationManagerDelegate , MKMapViewDelegate , UIAlertViewDelegate>
{
    CLLocationManager * locationManager;
    CLLocationDegrees  lat;
    CLLocationDegrees  lng;
    
    MKMapView * mapView;
    
    BOOL isUploaded;
}

@property (nonatomic , assign) CLLocationDegrees lat;
@property (nonatomic , assign) CLLocationDegrees lng;
@property (nonatomic , retain) NSMutableArray * placeMarks;
@property (nonatomic , retain) UIToolbar * toolBar;

@property (nonatomic , assign) MyMap * currentMap;


- (void) setMapRegionLongitude:(double)Y andLatitude:(double)X withLongitudeSpan:(double)SY andLatitudeSpan:(double)SX ; 
- (void) updateCurrentMap: (MKMapView *) theMap;

//upload to server
- (void) uploadMapsWithAuth:(NSString*)clientAuth andAMap:(MyMap*)theMap;
- (NSString *) creatingCSVFileWithMap:(MyMap *)theMap;



@end
