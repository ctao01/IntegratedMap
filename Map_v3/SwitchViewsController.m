//
//  SwitchViewsController.m
//  Map_v3.7
//
//  Created by Joy Tao on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SwitchViewsController.h"
#import "GDataXMLNode.h"

@implementation SwitchViewsController
@synthesize gSavedMaps = _gSavedMaps;

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
    [tvSavedMaps release];
    [vcSavedMaps release];
    [super dealloc];
}

#pragma mark -

#pragma mark -

- (void) setGSavedMaps:(NSMutableArray *)gSavedMaps
{
    AppDelegate * delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    if (_gSavedMaps == gSavedMaps) return;
    [_gSavedMaps release];
    //    _gSavedMaps = [gSavedMaps retain];
    
    NSLog(@"count:%i",[gSavedMaps count]);
    
    if ([[delegate savedMaps]count] > 0) 
    {
        NSLog(@"[[delegate savedMaps] count] >0");
        
        for (int i = 0; i < [[delegate savedMaps]count]; i ++) 
        {        
            for (int j = 0; j < [gSavedMaps count]; j ++)
            {
                
                if ([[(MyMap*)[gSavedMaps objectAtIndex:j] mapTitle] isEqualToString:[(MyMap*)[[delegate savedMaps] objectAtIndex:i] mapTitle] ]) 
                {
                    [gSavedMaps removeObjectAtIndex:j];
                    [(MyMap *)[[delegate savedMaps]objectAtIndex:i] setUploaded:YES];      // has already been upload
                    
                }
                
                else
                    [(MyMap*)[gSavedMaps objectAtIndex:j] setGoogleDownload:YES]; 
            }
            
        }
        
    }
    
    else
    {
        NSLog(@"[[delegate savedMaps] count]=0");
        
        for (int q = 0; q < [gSavedMaps count]; q++) 
            [(MyMap*)[gSavedMaps objectAtIndex:q] setGoogleDownload:YES]; 
    }
    
    
    _gSavedMaps = [gSavedMaps retain];
    
    NSLog(@"delegate.savedMaps count:%i",[[delegate savedMaps]count]);
    [delegate.savedMaps addObjectsFromArray:_gSavedMaps];
    NSLog(@"delegate.savedMaps count:%i",[[delegate savedMaps]count]);
    
    //    RootViewController * rvc = (RootViewController *)delegate.rootViewController;
    //    [rvc updateSavedData];
    
//    [self.tableView reloadData];
}

- (NSMutableArray * )retrieveMapsWithAuth:(NSString*)clientAuth
{
    NSURL * listURL = [NSURL URLWithString:@"http://maps.google.com/maps/feeds/maps/default/full"];
    NSString * authString = [NSString stringWithFormat:@"GoogleLogin auth=%@", clientAuth];
    
    ASIHTTPRequest * listRequest = [ASIHTTPRequest requestWithURL:listURL];
    [listRequest addRequestHeader:@"Authorization" value:authString];
    [listRequest startSynchronous];
    NSString * listResponse = [listRequest responseString];
    //        NSLog(@"listResponse:%@", listResponse);
    
    GDataXMLDocument * xmlDocument = [[GDataXMLDocument alloc]initWithXMLString:listResponse options:0 error:nil];
    GDataXMLElement * rootElement = [xmlDocument rootElement];
    NSArray * mapsEntries = [rootElement elementsForName:@"entry"];
    NSMutableArray * array = [[NSMutableArray alloc]init];
    
    for (GDataXMLElement * mapsEntry in mapsEntries) 
    {
        MyMap * aMap = [[MyMap alloc]init];
        
        NSArray * mapTitles = [mapsEntry elementsForName:@"title"];
        if ([mapTitles count] >0)
        {
            GDataXMLElement * mapTitle = (GDataXMLElement *) [mapTitles objectAtIndex:0];
            aMap.mapTitle = [mapTitle stringValue];
            
        }
        
        NSArray * mapAuthors = [mapsEntry elementsForName:@"author"];
        for (GDataXMLElement * mapAuthor in mapAuthors)
        {
            NSArray * mapAuthorNames= [mapAuthor elementsForName:@"name"];
            if ([mapAuthorNames count] >0)
            {
                GDataXMLElement * mapAuthorName= (GDataXMLElement *) [mapAuthorNames objectAtIndex:0];
                aMap.mapAuthor = [mapAuthorName stringValue];
                
            }
        }
        
        NSArray * mapCreatedTimes = [mapsEntry elementsForName:@"published"];
        if ([mapCreatedTimes count] >0)
        {
            GDataXMLElement * mapCreatedTime = (GDataXMLElement *) [mapCreatedTimes objectAtIndex:0];
            NSLog(@"mapCreatedTime:%@",[mapCreatedTime stringValue]);
            
            NSDateFormatter * inputFormatter = [[NSDateFormatter alloc]init];
            [inputFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.S'Z'"];
            [inputFormatter setTimeZone:[NSTimeZone localTimeZone]];
            
            aMap.mapCreatedTime = [inputFormatter dateFromString:[mapCreatedTime stringValue]];
            NSLog(@"aMap.mapCreatedTime:%@",aMap.mapCreatedTime);
            [inputFormatter release];
        }
        
        NSArray * mapContents = [mapsEntry elementsForName:@"content"];
        
        for (GDataXMLElement * mapContent in mapContents) 
        {
            NSString * src = [[mapContent attributeForName:@"src"] stringValue];
            aMap.myPlaces = [self retrievePlacemakrsFromContentURL:src andAuthToken:clientAuth];
        }
        
        [array addObject:aMap];
        NSLog(@"array:%i",[array count]);
        [aMap release];
        
    }
    
    return array;
}

- (NSMutableArray *)retrievePlacemakrsFromContentURL:(NSString*)mapContent andAuthToken:(NSString*)clientAuth
{
    NSLog(@"Content:%@",mapContent);
    NSURL * listURL = [NSURL URLWithString:mapContent];
    NSString * authString = [NSString stringWithFormat:@"GoogleLogin auth=%@", clientAuth];
    
    ASIHTTPRequest * listRequest = [ASIHTTPRequest requestWithURL:listURL];
    [listRequest addRequestHeader:@"Authorization" value:authString];
    [listRequest startSynchronous];
    NSString * listResponse = [listRequest responseString];
    
    GDataXMLDocument * xmlDocument = [[GDataXMLDocument alloc]initWithXMLString:listResponse options:0 error:nil];
    GDataXMLElement * rootElement = [xmlDocument rootElement];
    
    NSMutableArray * myPlaces = [[NSMutableArray alloc]init];
    
    NSArray * placeEntries = [rootElement elementsForName:@"atom:entry"];
    NSLog(@"%i" ,[placeEntries count]);
    for (GDataXMLElement * placeEntry in placeEntries) 
    {
        
        NSArray * placeContents = [placeEntry elementsForName:@"atom:content"];
        NSLog(@"placeContents:%@" ,placeContents);
        
        for (GDataXMLElement * placeMark in placeContents) 
        {
            NSArray * placeMarks = [placeMark elementsForName:@"Placemark"];
            for (GDataXMLElement * placeMark in placeMarks)
            {
                MyPlace * aPlace = [[MyPlace alloc]init];
                
                NSArray * placeNames = [placeMark elementsForName:@"name"];
                if ([placeNames count] > 0) 
                {
                    GDataXMLElement * placeName = (GDataXMLElement *) [placeNames objectAtIndex:0];
                    aPlace.locationName = [placeName stringValue];
                    
                }
                
                /* NSArray * placeDescs = [placeMark elementsForName:@"description"];
                 if ([placeDescs count] > 0) 
                 {
                 GDataXMLElement * placeDesc = (GDataXMLElement *) [placeDescs objectAtIndex:0];
                 aPlace.comment = [placeDesc stringValue];
                 }*/
                
                NSArray * placeExtendedDatas = [placeMark elementsForName:@"ExtendedData"];
                {
                    for (GDataXMLElement * placeExtenedData in placeExtendedDatas ) {
                        
                        NSArray * mapDatas= [placeExtenedData elementsForName:@"Data"];
                        
                        for (GDataXMLElement * mapData in mapDatas) 
                        {
                            NSString * dataName = [[mapData attributeForName:@"name"] stringValue];
                           
                            // time stamp 
                            if ([dataName isEqualToString:@"timestamp"]) 
                            {
                                NSArray * timeStamps = [mapData elementsForName:@"value"];
                                if ([timeStamps count]>0) {
                                    GDataXMLElement * timeStamp = (GDataXMLElement*)[timeStamps objectAtIndex:0];
                                    NSDateFormatter * inputFormatter = [[NSDateFormatter alloc]init];
                                    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ssZ"];
                                    [inputFormatter setTimeZone:[NSTimeZone localTimeZone]];                                    
                                    
                                    aPlace.timestamp = [inputFormatter dateFromString:[timeStamp stringValue]];
                                    NSLog(@"timestampStr:%@",aPlace.timestamp);

                                }
                            }
                        }
                        
                    }
                }
                
                NSArray * placePoints = [placeMark elementsForName:@"Point"];
                for ( GDataXMLElement * placePoint in placePoints) 
                {
                    NSArray * placeCoords = [placePoint elementsForName:@"coordinates"];
                    if ([placeCoords count] > 0) 
                    {
                        GDataXMLElement * placeCoord = (GDataXMLElement *) [placeCoords objectAtIndex:0];
                        
                        NSArray * array = [[placeCoord stringValue] componentsSeparatedByString:@","];
                        
                        NSNumberFormatter * numFormatter = [[NSNumberFormatter alloc] init];
                        [numFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
                        aPlace.longitude =[numFormatter numberFromString:[array objectAtIndex:0]];
                        aPlace.latitude = [numFormatter numberFromString:[array objectAtIndex:1] ];
                    }
                    
                }
                [myPlaces addObject:aPlace];
                [aPlace release];
            }
        }
    }
    return myPlaces;
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
    tableviewOnTop = YES;
    
    tvSavedMaps = [[SavedMapsTableViewController alloc]initWithStyle:UITableViewStylePlain];
    tvSavedMaps.navController = self;
    vcSavedMaps = [[iCarouselSavedMapsViewController alloc]init];
    [self.view addSubview:tvSavedMaps.view];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"Saved Maps";
    
    UIBarButtonItem * changeBtn = [[UIBarButtonItem alloc]initWithTitle:@"|||" style:UIBarButtonItemStyleBordered target:self action:@selector(switchView)];
    self.navigationItem.rightBarButtonItem = changeBtn;
    [changeBtn release];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [self setGSavedMaps:[self retrieveMapsWithAuth:[defaults objectForKey:@"AuthorizationToken"]]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -

-(void) switchView
{
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.5];	
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
	if (tableviewOnTop) {
		[tvSavedMaps.view removeFromSuperview];
		[self.view addSubview:vcSavedMaps.view];
	}
	else {
		[vcSavedMaps.view removeFromSuperview];
		[self.view addSubview:tvSavedMaps.view];
	}
	[UIView commitAnimations];
	
	tableviewOnTop = !tableviewOnTop;
}

@end
