//
//  MapViewController.m
//  Map_v3
//
//  Created by Joy Tao on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "MyPlace.h"
#import "Annotation.h"
#import "AppDelegate.h"
#import "DetailedViewController.h"
#import "SavedMapsTableViewController.h"

@implementation MapViewController

@synthesize placeMarks = _placeMarks;
@synthesize lat, lng;
@synthesize toolBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) dealloc
{
    [toolBar release];
    [mapView release];
    [locationManager release];

//    [self.placeMarks release];
    [super dealloc];
}
#pragma mark -

- (BOOL) isNotEditable
{
    NSArray *viewControllers = [[self navigationController] viewControllers];
    UIViewController * rootViewController = [viewControllers objectAtIndex:[viewControllers count]-2];
    
    return [rootViewController class] == [SavedMapsTableViewController class];
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    
    // Initialize CoreLocationManager
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    locationManager.distanceFilter = 50.0f;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    
    // Initialize MapView
    mapView = [[MKMapView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    mapView.showsUserLocation = YES;
    mapView.mapType = MKMapTypeStandard;
    mapView.scrollEnabled = YES;
    mapView.zoomEnabled = YES;
    mapView.delegate = self;
    
    [self.view addSubview:mapView];
    
    if ([self isNotEditable])
    {
        mapView.showsUserLocation = NO;
        [locationManager stopUpdatingLocation];
        
        if ([self.placeMarks count] > 0)
        {
            NSMutableArray * latArray = [[NSMutableArray alloc]init];
            NSMutableArray * lngArray = [[NSMutableArray alloc]init];
//
            latArray = [self.placeMarks valueForKeyPath:@"latitude"];
            lngArray = [self.placeMarks valueForKeyPath:@"longitude"];
            
            double max = [[latArray valueForKeyPath:@"@count"] doubleValue];
            
            NSLog(@"%@",latArray);
            NSLog(@"@count:%f",max);



//            for (MyPlace * thePlace in self.placeMarks) 
//            {
//                NSNumber * latNum = thePlace.latitude;
//                NSNumber * lngNum = thePlace.longitude;
//                
//                [latArray addObject:latNum];
//                [lngArray addObject:lngNum];
//                
//            }
//            double maxLat = [[latArray valueForKeyPath:@"maxLat.doubleValue"] doubleValue];
//            double minLat = [[latArray valueForKeyPath:@"minLat.doubleValue"] doubleValue];
//            
//            NSLog(@"%f",maxLat);
//            NSLog(@"%f",minLat);
        }

    }

    // Initialize ToolBar
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 420 - 44, 320, 44)];
    UIBarButtonItem * addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewPlace)];
    UIBarButtonItem * fixed = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:fixed, addButton , nil] animated:NO];
    [self.view addSubview:toolBar];
    [fixed release];
    [addButton release];
    
    // Initialize NavigationBar
    UIBarButtonItem * cancelBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelBtn;
    [cancelBtn release];
    
    NSLog(@"self.annotations:%@",self.placeMarks);

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateMap:mapView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Update

- (void) updateMap: (MKMapView *) theMap
{
    NSMutableArray * dict = [NSMutableArray arrayWithCapacity:[self.placeMarks count]];
    for (id Obj in [self placeMarks])
    {
        [dict addObject:[Obj dictionaryWithValuesForKeys:[MyPlace keys]]];
    }
    NSLog(@"updateMapsPlacemarks:%i",[self.placeMarks count]);
    // Set up pins
    NSMutableArray * annotations = [[NSMutableArray alloc]init];
    for (int i = 0; i < [self.placeMarks count]; i++) 
    {
        CLLocationCoordinate2D pinCenter;
        NSNumber * latitudeNum = [[dict objectAtIndex:i] objectForKey:@"latitude"];
        pinCenter.latitude =[latitudeNum doubleValue];
        NSNumber * longitudeNum = [[dict objectAtIndex:i] objectForKey:@"longitude"];
        pinCenter.longitude =[longitudeNum doubleValue];
        
        NSString * title = [[dict objectAtIndex:i] objectForKey:@"name"];
        NSDate * timestamp = [[dict objectAtIndex:i] objectForKey:@"timestamp"];
        
        NSDateFormatter* dateFromatter = [[NSDateFormatter alloc]init];
        [dateFromatter setDateStyle:NSDateFormatterLongStyle];
        [dateFromatter setTimeStyle:NSDateFormatterShortStyle];
        NSString * subtitle = [dateFromatter stringFromDate:timestamp];		
        
        Annotation * annotation = [[Annotation alloc]initWithCoordinate:pinCenter];
        annotation.title = annotation.title ? title : @"(no title)";
        annotation.subtitle = annotation.subtitle ? subtitle : @"(no subtitle)";
        
        [annotations addObject:annotation];
       
//        for (annotation in mapView.annotations)
//        {
//            [annotation removeObserver:self]; // NOTE: remove ALL observer!
//        }        
        [annotation release];
    }
    [theMap addAnnotations:annotations];
    [annotations release];
}

#pragma mark - Button Actions

- (void) addNewPlace
{
    [locationManager stopUpdatingLocation];
    
    NSString * message = [NSString stringWithFormat:@"You are now at\n(%f , %f)", lat, lng];
    UIAlertView * alertview = [[UIAlertView alloc]initWithTitle:@"Check In !? " message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"Quick Check In", @"Detailed Check In", nil];
    alertview.delegate = self;
    [alertview show];
    [alertview release];
}

- (void) cancel
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void) done
{
    AppDelegate * delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    MyMap * aMap = [[MyMap alloc]init];
    
    aMap.mapTitle = self.navigationItem.title;
    aMap.myPlaces = self.placeMarks;
    
    [delegate.savedMaps addObject:aMap];
    [aMap release];
    

    NSLog(@"delegate.savedMaps:%i",[delegate.savedMaps count]);
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (void) edit
{
    self.toolBar.hidden = NO;
    
    UIBarButtonItem * doneBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = doneBtn;
    [doneBtn release];
    
}

#pragma mark - Core Location Delegate


- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    lat = newLocation.coordinate.latitude;
    lng = newLocation.coordinate.longitude;
    
    double X = lng;
    double Y = lat;
    
    [self setMapRegionLongitude:X andLatitude:Y withLongitudeSpan:0.08 andLatitudeSpan:0.08];
    
}
#pragma mark - MKMapViewDelegate

- (void)setMapRegionLongitude:(double)Y andLatitude:(double)X withLongitudeSpan:(double)SY andLatitudeSpan:(double)SX 
{
    CLLocationCoordinate2D currentPos;
    currentPos.latitude = X;
    currentPos.longitude = Y;
    
    MKCoordinateSpan mapSpan;
    mapSpan.latitudeDelta = SX;
    mapSpan.longitudeDelta = SY;
    
    MKCoordinateRegion mapRegion;
    mapRegion.center = currentPos;
    mapRegion.span = mapSpan;
    
    [mapView setRegion:mapRegion];
    [mapView regionThatFits:mapRegion];
}

#pragma mark - Alert View

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex) return;
    switch (buttonIndex) 
    {
        case 1:
        {
             MyPlace * aPlace = [[MyPlace alloc]init];
            
            [aPlace setLatitude:[NSNumber numberWithDouble:lat]];
            [aPlace setLongitude:[NSNumber numberWithDouble:lng]];
            NSDate * timestamp = [NSDate date];
            [aPlace setTimestamp:timestamp];
            
            [_placeMarks addObject:aPlace];
            NSLog(@"self.placeMarks:%@",self.placeMarks);
            
            [aPlace release];
            [self updateMap: mapView];

        }
            break;
        case 2: 
        {
            DetailedViewController * vcDetail = [[DetailedViewController alloc]initWithStyle:UITableViewStyleGrouped];
            MyPlace * thePlace = [[MyPlace alloc]init];
            [vcDetail setThePlace:thePlace];
            [thePlace release];
            
            vcDetail.navigationItem.title = @"Add A New Place";
            UINavigationController * ncDetail = [[UINavigationController alloc]initWithRootViewController:vcDetail];
            [vcDetail release];
            [self.navigationController presentModalViewController:ncDetail animated:YES];
            [ncDetail release];
        }
            
            break;
        default:
            break;
    }
    [locationManager startUpdatingLocation];
}


@end
