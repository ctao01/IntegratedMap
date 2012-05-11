//
//  SwitchViewsController.m
//  Map_v3.7
//
//  Created by Joy Tao on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SwitchViewsController.h"

@implementation SwitchViewsController

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
    tableviewOnTop = YES;
    
    tvSavedMaps = [[SavedMapsTableViewController alloc]initWithStyle:UITableViewStylePlain];
    vcSavedMaps = [[iCarouselSavedMapsViewController alloc]init];
    [self.view addSubview:tvSavedMaps.view];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"Saved Maps";
    
    UIBarButtonItem * changeBtn = [[UIBarButtonItem alloc]initWithTitle:@"|||" style:UIBarButtonItemStyleBordered target:self action:@selector(switchView)];
    self.navigationItem.rightBarButtonItem = changeBtn;
    [changeBtn release];
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
