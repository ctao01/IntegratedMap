//
//  SettingViewController.m
//  Map_v3
//
//  Created by Joy Tao on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "GDataXMLNode.h"
#import "AppDelegate.h"
#import "SavedMapsTableViewController.h"
#import <KML/KML.h>

@implementation SettingViewController

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

#pragma mark - Retrieving a List of Maps

- (void) retrieveMapsWithAuth:(NSString*)clientAuth
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
        
        NSArray * mapCreatedTimes = [mapsEntry elementsForName:@"published"];
        if ([mapCreatedTimes count] >0)
        {
            GDataXMLElement * mapCreatedTime = (GDataXMLElement *) [mapCreatedTimes objectAtIndex:0];
            NSLog(@"mapCreatedTime:%@",[mapCreatedTime stringValue]);
            
            NSDateFormatter * inputFormatter = [[NSDateFormatter alloc]init];
            [inputFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
            aMap.mapCreatedTime = [inputFormatter dateFromString:[mapCreatedTime stringValue]];
            NSLog(@"aMap.mapCreatedTime:%@",aMap.mapCreatedTime);
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
    
    AppDelegate * delegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    SavedMapsTableViewController * vcSavedMaps = (SavedMapsTableViewController*) delegate.navigationController.topViewController;
    [vcSavedMaps.googleMaps addObjectsFromArray:array];
    [array release];
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (NSMutableArray *)retrievePlacemakrsFromContentURL:(NSString*)mapContent andAuthToken:(NSString*)clientAuth
{
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

#pragma mark - Uploading XML 

- (void) updateMapsWithAuth:(NSString*)clientAuth andAMap:(MyMap*)theMap
{
    
    NSURL * url =[NSURL URLWithString:@"http://maps.google.com/maps/feeds/maps/default/full"];
    ASIFormDataRequest * updateRequest = [ASIFormDataRequest requestWithURL:url];
    NSString * authString = [NSString stringWithFormat:@"GoogleLogin auth=%@", clientAuth];
    [updateRequest addRequestHeader:@"Authorization" value:authString];
    [updateRequest addRequestHeader:@"GData-Version" value:@"2.0"];
    [updateRequest addRequestHeader:@"Content-type" value:@"text/csv"];
    [updateRequest addRequestHeader:@"Slug" value:[theMap mapTitle]];
    
    NSString * string = [self creatingCSVFileWithMap:theMap];
    NSLog(@"string:%@",string);

    NSMutableData * bodyData = [[NSMutableData alloc]initWithData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    [updateRequest setPostBody:bodyData];
    [updateRequest startSynchronous];
    
    NSString * updateResponse = [updateRequest responseString];
    NSLog(@"updateResponse:%@",updateResponse);
    
    /*
    NSMutableString * bodyString = [[NSMutableString alloc]initWithCapacity:50];
    
    [bodyString appendString:@"<entry xmlns=\"http://www.w3.org/2005/Atom\">\n"];
    NSDateFormatter * inputFormatter = [[NSDateFormatter alloc]init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    [bodyString appendFormat:@"\t<published>%@</published>\n", [inputFormatter stringFromDate:theMap.mapCreatedTime]];
    
    [bodyString appendFormat:@"\t<title>%@</title>\n", [theMap mapTitle]];
    [bodyString appendFormat:@"\t<summary>%@</summary>\n", nil];
    [bodyString appendString:@"</entry>\n"];
    
    NSMutableData * bodyData = [[NSMutableData alloc]initWithData:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
    [updateRequest setPostBody:bodyData];
    [updateRequest startSynchronous];
    [bodyData release];
    
    NSString * updateResponse = [updateRequest responseString];

    
    GDataXMLDocument * xmlDocument = [[GDataXMLDocument alloc]initWithXMLString:updateResponse options:0 error:nil];
    GDataXMLElement * rootElement = [xmlDocument rootElement];
    NSArray * mapContents = [rootElement elementsForName:@"content"];
   
    NSString * src ; 
    for (GDataXMLElement * mapContent in mapContents) 
    {
        src = [[mapContent attributeForName:@"src"] stringValue];
    }    
    [self updateMapFeaturesWithAuth:clientAuth andAMap:theMap andContentURL:src];
    NSLog(@"URL:%@",src);*/
}

- (void) updateMapFeaturesWithAuth:(NSString *)clientAuth andAMap:(MyMap *)theMap andContentURL:(NSString *)theContentURL
{
//    NSURL * url =[NSURL URLWithString:theContentURL];
//    ASIFormDataRequest * updateRequest = [ASIFormDataRequest requestWithURL:url];
//    NSString * authString = [NSString stringWithFormat:@"GoogleLogin auth=%@", clientAuth];
//    [updateRequest addRequestHeader:@"Authorization" value:authString];
//    [updateRequest addRequestHeader:@"Content-type" value:@"application/vnd.google-earth.kml+xml"];
//    
//    NSString * kmlString = [self creatingKMLFileWithMap:theMap];
//    NSLog(@"kmlString:%@",kmlString);
    
//    NSMutableString * bodyString = [[NSMutableString alloc]initWithCapacity:50];
//    [bodyString appendString:@"<atom:entry xmlns=\"http://www.opengis.net/kml/2.2\" xmlns:atom=\"http://www.w3.org/2005/Atom\">\n"];
//    [bodyString appendFormat:@"\t<atom:content type=\"application/vnd.google-earth.kml+xml\">%@</atom:content>\n",kmlString];
//    [bodyString appendString:@"</atom:entry>"];
//    NSLog(@"bodyString:%@",bodyString);

    
//    NSMutableData * bodyData = [[NSMutableData alloc]initWithData:[kmlString dataUsingEncoding:NSUTF8StringEncoding]];
//    [updateRequest setPostBody:bodyData];
//    [updateRequest startSynchronous];
//    [bodyData release];
//    
//    NSString * updateResponse = [updateRequest responseString];
//    NSLog(@"updateResponse:%@",updateResponse);
    
}

//- (void) updateMapFeaturesWithAuth:(NSString *)clientAuth andAMap:(MyMap *)theMap andContentURL:(NSString *)theContentURL
//{
//    for (int index = 0; index < [theMap.myPlaces count]; index++) 
//    {
//        NSDictionary * dict = [theMap.myPlaces objectAtIndex:index];
//        NSString * string = [self generatingKMLFileWithPlace:dict];
//        NSLog(@"string:%@",string);
//    }
//}

- (NSString *) creatingCSVFileWithMap:(MyMap *)theMap
{
    NSMutableString * CSVStr = [[NSMutableString alloc]init];
    [CSVStr appendString:@"name,latitude,longitude,description\n"];
    for (int index = 0; index < [theMap.myPlaces count]; index++) 
    {
        NSDictionary * placesDict = [theMap.myPlaces objectAtIndex:index];
        NSString * description = [placesDict objectForKey:@"comment"];
       
        [CSVStr appendFormat:@"%@,%@,%@,%@\n",
         [placesDict objectForKey:@"locationName"],
         [placesDict objectForKey:@"latitude"],
         [placesDict objectForKey:@"longitude"],
         [description isKindOfClass:[NSNull class]]? @"no comment": description];
    }

    return CSVStr;
}


- (NSString *) generatingKMLFileWithPlace:(NSDictionary*)thePlace
{
    KMLRoot *root = [KMLRoot new];
    
    KMLDocument *doc = [KMLDocument new];
//    doc.name = @"test";
    root.feature = doc;
    
    KMLPlacemark *placemark = [KMLPlacemark new];
    placemark.name = [thePlace objectForKey:@"locationName"];
    NSString * description = [thePlace objectForKey:@"comment"];
    placemark.descriptionValue = [description isKindOfClass:[NSNull class]]? @"no comment": description;    
    [doc addFeature:placemark];
    
    KMLPoint *point = [KMLPoint new];
    placemark.geometry = point;
    
    KMLCoordinate *coordinate = [KMLCoordinate new];
    coordinate.latitude = [[thePlace objectForKey:@"latitude"] doubleValue];
    coordinate.longitude = [[thePlace objectForKey:@"longitude"] doubleValue];
    coordinate.altitude = 0.0f;
    point.coordinate = coordinate;
    
    return root.kml;
}

- (NSString *) creatingKMLFileWithMap:(MyMap *)theMap
{
    KMLRoot *root = [KMLRoot new];
    
    KMLDocument *doc = [KMLDocument new];
//    doc.name = [theMap mapTitle];
    root.feature = doc;
    
    NSMutableString * KMLStr = [[NSMutableString alloc]init];
    
    for (int index = 0; index < [theMap.myPlaces count]; index++) 
    {
        NSDictionary * placesDict = [theMap.myPlaces objectAtIndex:index];
        KMLPlacemark *placemark = [KMLPlacemark new];
        placemark.name = [placesDict objectForKey:@"locationName"];
        NSString * description = [placesDict objectForKey:@"comment"];
        placemark.descriptionValue = [description isKindOfClass:[NSNull class]]? @"no comment": description;    
        [doc addFeature:placemark];
        
        KMLPoint *point = [KMLPoint new];
        placemark.geometry = point;
        
        KMLCoordinate *coordinate = [KMLCoordinate new];
        coordinate.latitude = [[placesDict objectForKey:@"latitude"] doubleValue];
        coordinate.longitude = [[placesDict objectForKey:@"longitude"] doubleValue];
        coordinate.altitude = 0.0f;
        point.coordinate = coordinate;
        
        [KMLStr appendString:placemark.kml];
    }
    return KMLStr;
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
    usernameField = [[UITextField alloc]initWithFrame:CGRectMake(60, 40, 200, 25)];
    usernameField.borderStyle = UITextBorderStyleLine;
    [self.view addSubview:usernameField];
    
    passwordField = [[UITextField alloc]initWithFrame:CGRectMake(60, 70, 200, 25)];
    passwordField.borderStyle = UITextBorderStyleLine;
    passwordField.secureTextEntry = YES;
    [self.view addSubview:passwordField];
    
    UIButton * doneBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    doneBtn.frame = CGRectMake(160, 100, 100, 40);
    [doneBtn addTarget:self action:@selector(connectAccount) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneBtn];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIButton Actions

-(void) connectAccount
{
    // Step - Log In
    
    NSURL * url = [NSURL URLWithString:@"https://www.google.com/accounts/ClientLogin"];
    ASIFormDataRequest * loginRequest = [ASIFormDataRequest requestWithURL:url];
    [loginRequest setPostValue:@"GOOGLE" forKey:@"accountType"];
    [loginRequest setPostValue:@"local" forKey:@"service"];
    [loginRequest setPostValue:@"scroll" forKey:@"source"];

    [loginRequest setPostValue:usernameField.text forKey:@"Email"];
    [loginRequest setPostValue:passwordField.text forKey:@"Passwd"];
    [loginRequest startSynchronous];
    
    NSString * loginResponse = [loginRequest responseString];
    NSLog(@"%@", loginResponse);

    NSArray* loginResponseVariables = [loginResponse componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSString * clientSID = nil;
    NSString * errorMessage = nil;
    NSString * clientAuth = nil; //
    for(NSString* entry in loginResponseVariables) {
        NSArray* entryComponents = [entry componentsSeparatedByString:@"="];
        if (entryComponents.count == 2) {
            NSString* key = [entryComponents objectAtIndex:0];
            if ([@"SID" caseInsensitiveCompare:key] == NSOrderedSame) {
                clientSID = [entryComponents objectAtIndex:1];
            } else if ([@"Auth" caseInsensitiveCompare:key] == NSOrderedSame) {
                clientAuth = [entryComponents objectAtIndex:1];
            } else if ([@"Error" caseInsensitiveCompare:key] == NSOrderedSame) {
                errorMessage = [entryComponents objectAtIndex:1];
            }
        }
    }
    
    // store the token
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:clientAuth forKey:@"AuthorizationToken"];
    [defaults synchronize];
    
    if (!clientSID || !clientAuth) {
        // return error
		UIAlertView *alertUserError= [[UIAlertView alloc]initWithTitle:@"Error" message:@ "Please re-check your Google ID and password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertUserError show];
		[alertUserError release];
    }
    
    [self retrieveMapsWithAuth:clientAuth];

}

@end
