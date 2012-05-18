//
//  RootViewController.m
//  Map_v3
//
//  Created by Joy Tao on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "MyMap.h"
#import "MapViewController.h"
#import "AppDelegate.h"
#import "MyPlace.h"
//#import "SavedMapsTableViewController.h"
#import "SwitchViewsController.h"

@implementation RootViewController
//@synthesize currentMap;
@synthesize tvSetting;
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
    [tvSetting release];
    [super dealloc];
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
        
    // set up  the button
    UIButton * newMapBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [newMapBtn setFrame:CGRectMake(80, 120, 160, 30)];
    [newMapBtn setTitle:@"Create A New Map" forState:UIControlStateNormal];
    [newMapBtn addTarget:self action:@selector(createNewMap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newMapBtn];
    
    UIButton * continuedBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [continuedBtn setFrame:CGRectMake(80, 180, 160, 30)];
    [continuedBtn setTitle:@"Continue" forState:UIControlStateNormal];
    [continuedBtn addTarget:self action:@selector(continuedMap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:continuedBtn];
    
    UIButton * savedMapsBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [savedMapsBtn setFrame:CGRectMake(80, 240, 160, 30)];
    [savedMapsBtn setTitle:@"Saved Maps" forState:UIControlStateNormal];
    [savedMapsBtn addTarget:self action:@selector(savedMaps) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:savedMapsBtn];
    
    UIButton * settingBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [settingBtn setFrame:CGRectMake(80, 300, 160, 30)];
    [settingBtn setTitle:@"Setting" forState:UIControlStateNormal];
    [settingBtn addTarget:self action:@selector(goToSetting) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingBtn];
    
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
    self.navigationController.navigationBarHidden = YES;
    [self updateSavedData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Update Saved Data

- (void) updateSavedData
{
    AppDelegate * delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableArray * myMaps = [NSMutableArray arrayWithCapacity:[delegate.savedMaps count]];
   
    for (MyMap * myMap in [delegate savedMaps])
    {   
//        NSMutableArray * myPlaces =[[NSMutableArray alloc]init];
//        for (MyPlace * myPlace in [myMap myPlaces] )
//        {
//            [myPlaces addObject:[myPlace dictionaryWithValuesForKeys:[MyPlace keys]]];
//        }
//        myMap.myPlaces = myPlaces;
        [myMaps addObject:[myMap dictionaryWithValuesForKeys:[MyMap keys]]];
    }
    
    NSString * plist = [myMaps description];
    NSLog(@"Plist:%@",plist);
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * path = [defaults stringForKey:@"path"];
    NSLog(@"path_rootviewController:%@", path);
    
    NSError *error=nil;
    //    [plist writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
    [plist writeToFile:path atomically:YES encoding:NSUTF32StringEncoding error:&error];
    
    if (error) {
        NSLog(@"Error writing file to path:%@, error was %@", path, error);
    }

}
#pragma mark - Button Actions

- (void) createNewMap
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"New Map Name" message:@"Give your new map a name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[alert textFieldAtIndex:0]setPlaceholder:@"My Map" ];
    [[alert textFieldAtIndex:0]setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    alert.delegate = self;
    [alert show];
    [alert release];
}

/*
- (void) continuedMap
{
    AppDelegate * delegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    MyMap * aMap = [delegate.savedMaps lastObject];
    
    if (aMap) 
    {
        MapViewController * vcContinuedMap = [[MapViewController alloc]init];
        [vcContinuedMap setTitle:aMap.mapTitle];
        [vcContinuedMap setPlaceMarks:aMap.myPlaces];
        
        [self.navigationController pushViewController:vcContinuedMap animated:YES];
        vcContinuedMap.toolBar.hidden = YES;
        
        UIBarButtonItem * editBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:vcContinuedMap action:@selector(edit)];
        vcContinuedMap.navigationItem.rightBarButtonItem = editBtn;
        [editBtn release];
        
        [vcContinuedMap release];
        
        if ([delegate.savedMaps count] > 0)
        {
            [delegate.savedMaps removeLastObject];
        }
    }
    else
    {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"There is no recently editing map " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alertView.delegate = self;
        [alertView show];
        [alertView release];
    }
}
*/

- (void) savedMaps
{
    
//    SavedMapsTableViewController * vcSavedMaps = [[SavedMapsTableViewController alloc]initWithStyle:UITableViewStylePlain];
    SwitchViewsController * vcSavedMaps = [[SwitchViewsController alloc]init];

    [self.navigationController pushViewController:vcSavedMaps animated:YES];
//    [vcSavedMaps setGSavedMaps:[vcSavedMaps retrieveMapsWithAuth:[defaults objectForKey:@"AuthorizationToken"]]];
    [vcSavedMaps release];
}

- (void) goToSetting
{
    tvSetting = [[SettingTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:tvSetting animated:YES];
    tvSetting.vcParent = self;
}

#pragma mark - UIAlertViewDelegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) return;
    if (buttonIndex == 1) 
    {
        MapViewController * vcNewMap = [[MapViewController alloc]init];
        NSMutableArray * array = [[NSMutableArray alloc]init];
        NSLog(@"array:%@", array);
        [vcNewMap setPlaceMarks:array];
        [array release];
        
        NSString * title = [[alertView textFieldAtIndex:0] text];
        [vcNewMap setTitle: title? title: @"no title"];

        [self.navigationController pushViewController:vcNewMap animated:YES];
        
        UIBarButtonItem * doneBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:vcNewMap action:@selector(done)];
        vcNewMap.navigationItem.rightBarButtonItem = doneBtn;
        [doneBtn release];
        
        [vcNewMap release];
    }
}


@end
