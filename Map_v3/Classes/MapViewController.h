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

@interface MapViewController : UIViewController <CLLocationManagerDelegate , MKMapViewDelegate , UIAlertViewDelegate>
{
    CLLocationManager * locationManager;
    CLLocationDegrees  lat;
    CLLocationDegrees  lng;
    
    MKMapView * mapView;
}
@property (nonatomic , assign) CLLocationDegrees lat;
@property (nonatomic , assign) CLLocationDegrees lng;

@property (nonatomic , retain) NSMutableArray * placeMarks;
@property (nonatomic , retain) UIToolbar * toolBar;

- (void)setMapRegionLongitude:(double)Y andLatitude:(double)X withLongitudeSpan:(double)SY andLatitudeSpan:(double)SX ; 
- (void) updateMap: (MKMapView *) theMap;

@end
