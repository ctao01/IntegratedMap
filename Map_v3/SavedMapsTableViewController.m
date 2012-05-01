//
//  SavedMapsTableViewController.m
//  Map_v3.6
//
//  Created by Joy Tao on 3/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SavedMapsTableViewController.h"
#import "AppDelegate.h"
#import "MapViewController.h"
#import "MyMap.h"
#import "MyPlace.h"
#import "SettingViewController.h"
#import "RootViewController.h"

@interface SavedMapsTableViewController() {
    UIToolbar * toolBar;
}
@end

@implementation SavedMapsTableViewController
@synthesize googleMaps;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    [googleMaps release];
    [toolBar release];
    [super dealloc];
}

#pragma mark -

/*
- (void) refresh
{
    AppDelegate * delegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    RootViewController * rvc = (RootViewController *)delegate.rootViewController;
    [rvc updateSavedData];
    
    [self.tableView reloadData];

}
*/


- (void) sync
{
    AppDelegate * delegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];

    if (googleMaps) {
        [delegate.savedMaps removeObjectsInArray:googleMaps];
        [googleMaps release]; googleMaps = nil;
    }
    googleMaps = [[NSMutableArray alloc]init];
    SettingViewController * vcSetting = [[SettingViewController alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * authStr = [defaults objectForKey:@"AuthorizationToken"];
    [vcSetting retrieveMapsWithAuth:authStr];

    [delegate.savedMaps addObjectsFromArray:googleMaps];
    NSLog(@"%i",[delegate.savedMaps count]);
    
    RootViewController * rvc = (RootViewController *)delegate.rootViewController;
    [rvc updateSavedData];
    
    [self.tableView reloadData];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"Saved Maps";
    
    UIBarButtonItem * syncBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(SyncOrNot)];
    self.navigationItem.rightBarButtonItem = syncBtn;
    [syncBtn release];
    
    CGRect frame = self.view.frame;
    UIBarButtonItem * fixed = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    // TODO: if and if else
    
    UIButton * googleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [googleBtn setTitle:@"G" forState:UIControlStateNormal];
    [googleBtn addTarget:self action:@selector(connectToGoogle) forControlEvents:UIControlEventTouchUpInside];
    [googleBtn setFrame:CGRectMake(0, 0, 32, 32)];
    UIBarButtonItem * gooogleBarBtn = [[UIBarButtonItem alloc]initWithCustomView:googleBtn];

    UIButton * yahooBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [yahooBtn setTitle:@"Y" forState:UIControlStateNormal];
    [yahooBtn addTarget:self action:@selector(connectToYahoo) forControlEvents:UIControlEventTouchUpInside];
    [yahooBtn setFrame:CGRectMake(0, 0, 32, 32)];
    UIBarButtonItem * yahooBarBtn = [[UIBarButtonItem alloc]initWithCustomView:yahooBtn];
    
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 30)];
    [toolBar setItems:[NSArray arrayWithObjects:fixed, gooogleBarBtn,yahooBarBtn, nil] animated:NO];
    self.tableView.tableHeaderView = toolBar;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];    
    NSLog(@"viewDidAppear");
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"viewWillDisappear");

    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIButton Actions

- (void) SyncOrNot
{
    // Check and retrieve authorization information
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (! [defaults objectForKey:@"AuthorizationToken"]) 
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Notice" message:@"You haven't connected to Google account" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Connect Now", nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        alert.delegate = self;
        [alert show];
        [alert release];    
    }
    else
        [self sync];
}

- (void) connectToGoogle 
{
    [(UIButton *)[[toolBar.items objectAtIndex:1] customView] setTitle:@"G" forState:UIControlStateSelected];
}

- (void) connectToYahoo
{
    [(UIButton *)[[toolBar.items objectAtIndex:2] customView] setTitle:@"Y" forState:UIControlStateSelected];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    AppDelegate * delegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    if (delegate.savedMaps) 
    {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppDelegate * delegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    if (delegate.savedMaps) 
    {
        return [delegate.savedMaps count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    AppDelegate * delegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"mapCreatedTime" ascending:NO];
    [delegate.savedMaps sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    MyMap * aMap = [delegate.savedMaps objectAtIndex:indexPath.row];
    
    cell.textLabel.text = aMap.mapTitle;
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    cell.detailTextLabel.text = [dateFormatter stringFromDate:aMap.mapCreatedTime];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    AppDelegate * delegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
//    MyMap * aMap = [delegate.savedMaps objectAtIndex:indexPath.row];
//    
//    NSMutableArray * myMaps = [[NSMutableArray alloc]initWithCapacity:1];
//    NSMutableArray * myPlaces =[[NSMutableArray alloc]init];
//    for (MyPlace * myPlace in [aMap myPlaces] )
//    {
//        [myPlaces addObject:[myPlace dictionaryWithValuesForKeys:[MyPlace keys]]];
//    }
//    aMap.myPlaces = myPlaces;
//    [myMaps addObject:[aMap dictionaryWithValuesForKeys:[MyMap keys]]];
//    
//    NSString * mapStr = [myMaps description];
//    NSLog(@"mapStr:%@",mapStr);
////    NSData * mapData= [mapStr dataUsingEncoding:NSUTF8StringEncoding];    
//    NSString * uploadedMapFile = [[NSBundle mainBundle]pathForResource:@"UploadedMap" ofType:@"xml"];
//    [mapStr writeToFile:uploadedMapFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
//    NSString * uploadedMapStr = [NSString stringWithContentsOfFile:uploadedMapFile encoding:NSUTF8StringEncoding error:nil];
//    NSLog(@"uploadMapStr:%@",uploadedMapStr);
//
//    SettingViewController * vcSetting = [[SettingViewController alloc]init];
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString * authStr = [defaults objectForKey:@"AuthorizationToken"];
////    [vcSetting updateMapsWithAuth:authStr andContentString:uploadedMapStr];
////    [vcSetting updateMapsWithAuth:authStr andFilePath:uploadedMapFile];
//    [vcSetting updateMapsWithAuth:authStr andAMap:aMap];
    
    AppDelegate * delegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    MyMap * aMap = [delegate.savedMaps objectAtIndex:indexPath.row];
    
    MapViewController * vcContinuedMap = [[MapViewController alloc]init];
    [vcContinuedMap setTitle:aMap.mapTitle];
    [vcContinuedMap setPlaceMarks:aMap.myPlaces];
    
    [self.navigationController pushViewController:vcContinuedMap animated:YES];
    vcContinuedMap.toolBar.hidden = YES;
    vcContinuedMap.currentMap = aMap;
    UIBarButtonItem * editBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:vcContinuedMap action:@selector(edit)];
    vcContinuedMap.navigationItem.rightBarButtonItem = editBtn;
    [editBtn release];
    [vcContinuedMap release];

    
 }
/*
- (void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate * delegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    MyMap * aMap = [delegate.savedMaps objectAtIndex:indexPath.row];
    
    MapViewController * vcContinuedMap = [[MapViewController alloc]init];
    [vcContinuedMap setTitle:aMap.mapTitle];
    [vcContinuedMap setPlaceMarks:aMap.myPlaces];
    
    [self.navigationController pushViewController:vcContinuedMap animated:YES];
    vcContinuedMap.toolBar.hidden = YES;
    vcContinuedMap.currentMap = aMap;
    UIBarButtonItem * editBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:vcContinuedMap action:@selector(edit)];
    vcContinuedMap.navigationItem.rightBarButtonItem = editBtn;
    [editBtn release];
    [vcContinuedMap release];

    
    
//    [delegate.savedMaps removeObjectAtIndex:indexPath.row];
    NSLog(@"tableview:%i",[delegate.savedMaps count]);
}*/

#pragma mark - UIAlertViewDelegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) return;
    if (buttonIndex == 1) 
    {
        SettingViewController * vcSetting = [[SettingViewController alloc]init];
        UINavigationController * ncSetting = [[UINavigationController alloc]initWithRootViewController:vcSetting];
        [vcSetting release];
        [self.navigationController presentModalViewController:ncSetting animated:YES];
        [ncSetting release];
    }
}


@end
