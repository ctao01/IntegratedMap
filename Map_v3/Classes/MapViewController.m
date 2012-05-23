//
//  MapViewController.m
//  Map_v3
//
//  Created by Joy Tao on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "MyPlace.h"
#import "Annotation.h"
#import "AppDelegate.h"
#import "DetailedViewController.h"
#import "SwitchViewsController.h"

#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>

@implementation MapViewController

@synthesize placeMarks = _placeMarks;
@synthesize lat, lng;
@synthesize toolBar ;
@synthesize customTabBar;
@synthesize currentMap = _currentMap;

#pragma mark - UIGesture

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer

{
    return  YES;
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer

{
    return  YES;
}

#pragma mark -

//- (void)applicationWillResign
//{
//    NSLog(@"applicationWillResign");
//    if (locationManager) 
//        [locationManager stopUpdatingLocation];
//}


#pragma mark-

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
    [customTabBar release]; 
    [mapView release]; mapView = nil;
    [locationManager release]; locationManager = nil;

    NSLog(@"dealloc");
    [super dealloc];
}

- (void) setCurrentMap:(MyMap *)currentMap
{
    if (_currentMap == currentMap) return;
    [_currentMap release];
    _currentMap = [currentMap retain];
    
//    NSMutableArray * array = [[NSMutableArray alloc]initWithCapacity:[[_currentMap myPlaces]count]];
//    // NSDictionary
//    for (id Obj in [_currentMap myPlaces]) {
//        // [Obj class] is NSDictionary
//        NSLog(@"obj%@",Obj);
//        
//        
//        MyPlace * thePlace = [[MyPlace alloc]init];
//        thePlace.comment = [Obj objectForKey:@"comment"] ;
//        thePlace.locationName = [Obj objectForKey:@"locationName"];
//        thePlace.latitude = [Obj objectForKey:@"latitude"];
//        thePlace.longitude = [Obj objectForKey:@"longitude"];
//        thePlace.timestamp = [Obj objectForKey:@"timestamp"];
//        thePlace.streetAddress = [Obj objectForKey:@"streetAddress"];
//        thePlace.subStreetAddress = [Obj objectForKey:@"subStreetAddress"];
//        thePlace.city = [Obj objectForKey:@"city"];
//        thePlace.zipCode = [Obj objectForKey:@"zipCode"];
//        thePlace.state = [Obj objectForKey:@"state"];
//        thePlace.country = [Obj objectForKey:@"country"];
//
//        [array addObject:thePlace];
//        NSLog(@"%@",array);
//    }

    self.placeMarks = _currentMap.myPlaces;
    self.title = _currentMap.mapTitle;
    
    
}
#pragma mark -

- (BOOL) isNotEditable
{
    NSArray *viewControllers = [[self navigationController] viewControllers];
    UIViewController * rootViewController = [viewControllers objectAtIndex:[viewControllers count]-2];
    NSLog(@"%@",NSStringFromClass([rootViewController class]));
    
    return [rootViewController class] == [SwitchViewsController class];
}

- (MyMap *) completeTheMap
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"savedTheCurrentStatus");
    
    MyMap * aMap = [[MyMap alloc]init];
    
    aMap.mapTitle = self.navigationItem.title;
    aMap.myPlaces = self.placeMarks;
    aMap.mapCreatedTime = [NSDate date];
    aMap.mapAuthor = [defaults objectForKey:@"IMUsername"];
   
    if (! self.isNotEditable) 
    {
        aMap.uploaded = NO;  // view push from rootviewcontroller
        
        if (isUploaded == YES)  aMap.uploaded = YES;     // new map has already been uploaded
        else aMap.uploaded = NO;                     // new map has not been uploaded
    }
    
    return aMap;
}

//- (void) tap:(id)sender
//{
//    UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer*)sender;
//    CGPoint tapPoint = [tapGesture locationInView:mapView];
//    NSLog(@"Point:%@",NSStringFromCGPoint(tapPoint));
//    toolBar.center = tapPoint;
//    toolBar.hidden = NO;
//    
//}


#pragma mark - Custom Tab bar Button

-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(addNewPlace) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat heightDifference = buttonImage.size.height - customTabBar.frame.size.height;
    if (heightDifference < 0)
        button.center = customTabBar.center;
    else
    {
        CGPoint center = customTabBar.center;
        center.y = center.y - heightDifference/2.0;
        button.center = center;
    }
    
    [self.view addSubview:button];
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
        if (locationManager)
        {
            [locationManager release]; locationManager = nil;
        } 
//        
//        if ([self.placeMarks count] > 0)
//        {
//            double maxLat = [[self.placeMarks valueForKeyPath:@"@max.latitude"] doubleValue];
//            double minLat = [[self.placeMarks valueForKeyPath:@"@min.latitude"] doubleValue];
//            double avgLat = [[self.placeMarks valueForKeyPath:@"@avg.latitude"] doubleValue];
//
//
//            double maxLng = [[self.placeMarks valueForKeyPath:@"@max.longitude"] doubleValue];
//            double minLng = [[self.placeMarks valueForKeyPath:@"@min.longitude"] doubleValue];
//            double avgLng = [[self.placeMarks valueForKeyPath:@"@avg.longitude"] doubleValue];
//        } 
    }
    [self updateCurrentMap:mapView];


    // Initialize ToolBar
    /*toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    UIBarButtonItem * locationItem = [[UIBarButtonItem alloc]initWithTitle:@"GPS" style:UIBarButtonItemStyleBordered target:self action:nil];
    UIBarButtonItem * routeItem = [[UIBarButtonItem alloc]initWithTitle:@"Route" style:UIBarButtonItemStyleBordered target:self action:nil];
    UIBarButtonItem * checkinItem = [[UIBarButtonItem alloc]initWithTitle:@"CheckIn" style:UIBarButtonItemStyleBordered target:self action:nil];
    UIBarButtonItem * uploadItem = [[UIBarButtonItem alloc]initWithTitle:@"Upload" style:UIBarButtonItemStyleBordered target:self action:nil];
    UIBarButtonItem * shareItem = [[UIBarButtonItem alloc]initWithTitle:@"Share" style:UIBarButtonItemStyleBordered target:self action:nil];
//    UIButton * customizedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    if (!isUploaded) {
//        [customizedBtn setTitle:@"upload" forState:UIControlStateNormal];
//        [customizedBtn addTarget:self action:@selector(upload) forControlEvents:UIControlEventTouchUpInside];
//    }
//    else
//    {
//        [customizedBtn setTitle:@"update" forState:UIControlStateNormal];
//        [customizedBtn addTarget:self action:@selector(update) forControlEvents:UIControlEventTouchUpInside];
//
//    }
   
    [toolBar setItems:[NSArray arrayWithObjects:locationItem, routeItem, checkinItem, uploadItem, shareItem, nil] animated:NO];
    [self.view addSubview:toolBar];
    toolBar.hidden = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [tap setDelegate:self];
    [mapView addGestureRecognizer:tap];
    [tap release];*/
    
    
    customTabBar = [[UITabBar alloc]initWithFrame:CGRectMake(0, 420-49, 320, 49)];
    customTabBar.delegate = self;   

    
    UITabBarItem * locationItem = [[UITabBarItem alloc]initWithTitle:@"GPS" image:nil tag:0];
   
    UITabBarItem * routeItem = [[UITabBarItem alloc]initWithTitle:@"Route" image:nil tag:1];
    routeItem.badgeValue = [APPLICATION_DEFAULTS boolForKey:@"Map_Show_Route"]? @"ON":@"OFF";
    
    
    UITabBarItem * checkinItem = [[UITabBarItem alloc]initWithTitle:@"" image:nil tag:2];
    UITabBarItem * uploadItem = [[UITabBarItem alloc]initWithTitle:@"Upload" image:nil tag:3];
    uploadItem.badgeValue = isUploaded ? @"Update" : @"Upload";
    
    UITabBarItem * shareItem = [[UITabBarItem alloc]initWithTitle:@"Share" image:nil tag:4];

    [APPLICATION_DEFAULTS synchronize];
    
    [customTabBar setItems:[NSArray arrayWithObjects:locationItem, routeItem, checkinItem , uploadItem , shareItem, nil] animated:NO];
    [self.view addSubview:customTabBar];
    
    
    // Initialize NavigationBar
    UIBarButtonItem * cancelBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelBtn;
    [cancelBtn release];
    
    NSLog(@"self.annotations:%@",self.placeMarks);

    
    // Initialize application observer
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationWillResign) name:UIApplicationWillResignActiveNotification object:NULL ];
}

//- (void) setCustomizedToolBar:(IMCustomizedTabBar *)customizedToolBar
//{
//    if (_customizedToolBar == customizedToolBar )return;
//    [_customizedToolBar release];
//    _customizedToolBar = customizedToolBar;
//    
//}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    if (locationManager ) 
        locationManager = nil;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateCurrentMap:mapView];
    if (![self isNotEditable]) 
        [self addCenterButtonWithImage:[UIImage imageNamed:@"location-icon-yellow.png"] highlightImage:nil];

}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    
    if (locationManager)
        [locationManager stopUpdatingLocation]; 
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Update MKMapView (places/ annotations)

- (void) updateCurrentMap: (MKMapView *) theMap
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
        
        NSString * title = [[dict objectAtIndex:i] objectForKey:@"locationName"];
        NSLog(@"title:%@",title);
        
        NSDate * timestamp = [[dict objectAtIndex:i] objectForKey:@"timestamp"];
        NSLog(@"timestamp:%@",timestamp);

        
        NSDateFormatter* dateFromatter = [[[NSDateFormatter alloc]init] autorelease];
        [dateFromatter setDateStyle:NSDateFormatterLongStyle];
        [dateFromatter setTimeStyle:NSDateFormatterShortStyle];
        NSString * subtitle = [dateFromatter stringFromDate:[NSDate date]];		
        NSLog(@"%@",subtitle);

        Annotation * annotation = [[Annotation alloc]initWithCoordinate:pinCenter];
        annotation.title = [title isKindOfClass:[NSNull class]]? @"(no title)" : title;    
        annotation.subtitle = [subtitle isKindOfClass:[NSNull class]] ? @"(no subtitle)" : subtitle;
        
        [annotations addObject:annotation];     
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



- (UIImage*) generateMapImage
{
    UIGraphicsBeginImageContext(mapView.frame.size);
	[mapView.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage * mapImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();  
    return mapImage;

    //
//    UIImage * bgImg = [UIImage imageNamed:@"websbook_960x720.png"];
//    NSLog(@"SIZE:%@",NSStringFromCGSize([bgImg size]));
//    UIImageView * bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, bgImg.size.width * 0.7f , bgImg.size.height *0.7f)];
//    bgImageView.image = bgImg;
    
//    CGSize imageSize = mapImage.size;
//    UIImageView * imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f,imageSize.width * 0.6f, imageSize.height * 0.6f)];
//    imageview.image = mapImage;
//    imageview.layer.borderWidth = 10.0f;
//    imageview.contentMode = UIViewContentModeCenter;
//    imageview.layer.borderColor = [[UIColor whiteColor]CGColor];
//    imageview.layer.shadowOffset = CGSizeMake(-3.0f, 3.0f);
//    imageview.layer.shadowRadius = 3.0f;
//    imageview.layer.shadowOpacity = 1.0f;
//    imageview.layer.shadowColor = [[UIColor blackColor]CGColor];
//    
//    imageview.center = bgImageView.center;
//    [bgImageView addSubview:imageview];
//    
//    UIGraphicsBeginImageContext(bgImageView.frame.size);
//	[bgImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
//	UIImage * mapImageview = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
//    return mapImageview;
    
    /* CGRect viewFrame = self.view.frame;
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake( OFFSET , OFFSET, viewFrame.size.width - OFFSET * 2, viewFrame.size.height - OFFSET * 2 )];
    bgView.clipsToBounds = YES;
    bgView.layer.cornerRadius = 5.0f;
    bgView.layer.borderWidth = 5.0f;
    bgView.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    
    CGRect bgViewFrame = bgView.frame;
    UIImageView * mapImgView = [[UIImageView alloc]initWithFrame:CGRectMake( LEFT_OFFSET , TOP_OFFSET, bgViewFrame.size.width - LEFT_OFFSET - RIGHT_OFFSET, bgViewFrame.size.height - TOP_OFFSET - BOTTOM_OFFSET )];
    mapImgView.image = mapImage;
    NSLog(@"frame:%@",NSStringFromCGRect([mapImgView frame]));
    
    CGRect mapImageFrame = mapImgView.frame;
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(mapImageFrame.origin.x, mapImageFrame.origin.y + mapImageFrame.size.height, mapImageFrame.size.width, 24)];

    titleLabel.text = self.navigationItem.title;
    
    [bgView addSubview:mapImgView];
    [bgView addSubview:titleLabel];
    
    [mapImgView release];
    [titleLabel release];
        
    UIGraphicsBeginImageContext(bgView.bounds.size);
    [bgView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil);
    return newImage;*/
}

- (void) cancel
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void) done
{
    AppDelegate * delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
//    MyMap * aMap = [[MyMap alloc]init];
//    aMap.mapTitle = self.navigationItem.title;
//    aMap.myPlaces = self.placeMarks;
//    aMap.mapCreatedTime = [NSDate date];
//    
//    if (! self.isNotEditable) 
//        aMap.upload = YES;
//    else
//    {
//        if (aMap.upload == YES)
//            aMap.upload = YES;
//        else
//            aMap.upload = NO;
//    }
    
//    if ([self.placeMarks count] > 0)
//    {
//        double avgLat = [[self.placeMarks valueForKeyPath:@"@avg.latitude"] doubleValue];
//        double avgLng = [[self.placeMarks valueForKeyPath:@"@avg.longitude"] doubleValue];
//        [self setMapRegionLongitude:avgLng andLatitude:avgLat withLongitudeSpan:0.5 andLatitudeSpan:0.5];
//    }    

    MyMap * aMap = [self completeTheMap];
    UIImage * image = [self generateMapImage];
    aMap.mapImagePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@.png", aMap.mapTitle];
    [UIImagePNGRepresentation(image) writeToFile:aMap.mapImagePath atomically:YES];
   
    [delegate.savedMaps addObject:aMap];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) edit
{
    if (self.isNotEditable) {
        AppDelegate * delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        [delegate.savedMaps removeObject: self.currentMap]; // TODO:
        NSLog(@"%i",[[delegate savedMaps] count]);
    }
    
    self.customTabBar.hidden = NO;
    [self addCenterButtonWithImage:[UIImage imageNamed:@"location-icon-yellow.png"] highlightImage:nil];

    
    UIBarButtonItem * doneBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = doneBtn;
    [doneBtn release];
    
    if (!locationManager) 
    {
        locationManager = [[CLLocationManager alloc]init];
        locationManager.delegate = self;
        locationManager.distanceFilter = 50.0f;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager startUpdatingLocation];
    }
    
}

- (void) upload
{
    
//    [(UIButton *)[[toolBar.items objectAtIndex:0] customView] setTitle:@"update" forState:UIControlStateNormal];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * authStr = [defaults objectForKey:@"AuthorizationToken"];
    
    if (!authStr)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"You haven't connected to any account" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        isUploaded = NO;
    }
    else
        isUploaded = YES;
    
    MyMap * aMap = [self completeTheMap];
    NSMutableArray * myPlaces =[[NSMutableArray alloc]init];
    for (MyPlace * myPlace in [aMap myPlaces] )
    {
        [myPlaces addObject:[myPlace dictionaryWithValuesForKeys:[MyPlace keys]]];
    }
    aMap.myPlaces = myPlaces;
    
    [self uploadMapsWithAuth:authStr andAMap:aMap];
}

- (void) update
{
    NSLog(@"update!");
    
    //TODO:
    // 
}

#pragma mark - Core Location Delegate


- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    lat = newLocation.coordinate.latitude;
    lng = newLocation.coordinate.longitude;
    
    double X = lng;
    double Y = lat;
    
    [self setMapRegionLongitude:X andLatitude:Y withLongitudeSpan:0.1 andLatitudeSpan:0.1];
    
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


- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) 
    {
        return nil;
    }    
    MKPinAnnotationView * annotationView = [[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil]autorelease];
    annotationView.canShowCallout = YES;
    UIButton * detailBtn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.rightCalloutAccessoryView = detailBtn;
    annotationView.animatesDrop = NO ;
    return annotationView;
    
    
}

- (void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
    // TODO: self.currentMap exist or not
    
    DetailedViewController * vcDetail = [[DetailedViewController alloc]initWithStyle:UITableViewStyleGrouped];
    

    for (id obj in [self placeMarks]) {
        NSLog(@"%@", NSStringFromClass([obj class]));
        MyPlace * thePlace = (MyPlace*)obj;
        vcDetail.thePlace = thePlace;
        vcDetail.title = [thePlace locationName]? [thePlace locationName]:@"no title";
    }
    
    
//    if (self.isNotEditable)
//    {
//        for (int index = 0; index <[[self.currentMap myPlaces]count]; index ++) 
//        {
//            MyPlace * currentPlace = [[self.currentMap myPlaces]objectAtIndex:index];
////            vcDetail.thePlace = currentPlace;
////            vcDetail.title = [currentPlace locationName];
//            NSLog(@"%@",[self.currentMap class]);
//
//            NSLog(@"%@",[currentPlace class]);
//            NSLog(@"%@",[currentPlace isKindOfClass:[NSDictionary class]]? @"YES" : @"NO");
//            NSLog(@"%@",[self.currentMap isKindOfClass:[NSMutableArray class]]? @"YES" : @"NO");
//
//
//        }
//        
//    }
//    else
//    {
//        for (id Obj in [[self completeTheMap] myPlaces])
//        {
//            MyPlace * currentPlace = (MyPlace*)Obj;
//            vcDetail.thePlace = currentPlace;
//            vcDetail.title = [currentPlace locationName];
//            NSLog(@"%@",[currentPlace class]);
//            NSLog(@"%@",[[self completeTheMap] class]);
//
//            NSLog(@"editingMap");
//        }
//    }
    
    [self.navigationController pushViewController:vcDetail animated:YES];
    
    [vcDetail release];
    
    
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
            [aPlace setLocationName:@"(no title)"];

            
            [aPlace setLatitude:[NSNumber numberWithDouble:lat]];
            [aPlace setLongitude:[NSNumber numberWithDouble:lng]];
            NSDate * timestamp = [NSDate date];
            [aPlace setTimestamp:timestamp];
            
            [_placeMarks addObject:aPlace];
            NSLog(@"self.placeMarks:%@",self.placeMarks);
            
            [aPlace release];
            [self updateCurrentMap: mapView];

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
    [self performSelector:@selector(completeTheMap) withObject:nil afterDelay:2.0f];
}


#pragma mark - upload / update

- (NSString *) creatingCSVFileWithMap:(MyMap *)theMap
{
    NSMutableString * CSVStr = [[NSMutableString alloc]init];
    [CSVStr appendString:@"name,latitude,longitude,description,timestamp\n"];
    for (int index = 0; index < [theMap.myPlaces count]; index++) 
    {
        NSDictionary * placesDict = [theMap.myPlaces objectAtIndex:index];
        NSString * description = [placesDict objectForKey:@"comment"];
        
        [CSVStr appendFormat:@"%@,%@,%@,%@,%@\n",
         [placesDict objectForKey:@"locationName"],
         [placesDict objectForKey:@"latitude"],
         [placesDict objectForKey:@"longitude"],
         [description isKindOfClass:[NSNull class]]? @"no comment" :description,
         [placesDict objectForKey:@"timestamp"]];

    }
    
    return CSVStr;
}

- (void) uploadMapsWithAuth:(NSString *)clientAuth andAMap:(MyMap *)theMap
{
    
    NSURL * url =[NSURL URLWithString:@"http://maps.google.com/maps/feeds/maps/default/full"];
    ASIFormDataRequest * updateRequest = [ASIFormDataRequest requestWithURL:url];
    NSString * authString = [NSString stringWithFormat:@"GoogleLogin auth=%@", clientAuth];
    [updateRequest addRequestHeader:@"Authorization" value:authString];
    [updateRequest addRequestHeader:@"GData-Version" value:@"2.0"];
    [updateRequest addRequestHeader:@"Content-type" value:@"text/csv"];
    [updateRequest addRequestHeader:@"Slug" value:[theMap mapTitle]];
    
    NSString * string = [self creatingCSVFileWithMap:theMap];
    
    NSMutableData * bodyData = [[NSMutableData alloc]initWithData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    [updateRequest setPostBody:bodyData];
    [updateRequest startSynchronous];
    
    NSString * updateResponse = [updateRequest responseString];
    NSLog(@"updateResponse:%@",updateResponse);
}

#pragma mark - TabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    
    NSUInteger index = [tabBar.items indexOfObject:item];
    NSLog(@"index:%i",index);
    
    switch (index) {
        case 0:
        {
            
        }
            
            break;
        case 1:
        {
            if ([APPLICATION_DEFAULTS boolForKey:@"Map_Show_Route"] == NO) 
            {
                NSLog(@"map show route");
                [APPLICATION_DEFAULTS setBool:YES forKey:@"Map_Show_Route"];
                [APPLICATION_DEFAULTS synchronize];

                item.badgeValue = @"ON";
            }
            else
            {
                NSLog(@"map does not show route");
                item.badgeValue = @"OFF";
                [APPLICATION_DEFAULTS setBool:NO forKey:@"Map_Show_Route"];
                [APPLICATION_DEFAULTS synchronize];
            }
            
        }
            break;
        case 3:
        {
            if (isUploaded == NO) 
            {
                NSLog(@"upload map!");
                item.badgeValue = @"Update";
                isUploaded = YES;
            }
            else
            {
                NSLog(@"update map!");
                item.badgeValue = @"Update";
            }
        }
            
        default:
            break;
    }

//    if ([customTabBar.items objectAtIndex:3])
//        [self upload];
//    else
//        return;
}
@end
