//
//  iCarouselSavedMapsViewController.m
//  Map_v3.7
//
//  Created by Joy Tao on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "iCarouselSavedMapsViewController.h"
#import "iCarousel.h"

@interface iCarouselSavedMapsViewController () <iCarouselDataSource , iCarouselDelegate >

@property (nonatomic , retain) iCarousel * carousel;

@end


@implementation iCarouselSavedMapsViewController
@synthesize carousel;

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
    [carousel release];
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
    self.view.frame = [[UIScreen mainScreen]bounds];

    //create carousel
	carousel = [[iCarousel alloc] initWithFrame:self.view.bounds];
	carousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    carousel.type = iCarouselTypeCoverFlow2;
	carousel.delegate = self;
	carousel.dataSource = self;
    
	//add carousel to view
	[self.view addSubview:carousel];

}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.carousel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - iCarouselDataSource

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    NSLog(@"%i",[[APPLICATION_DELEGATE savedMaps] count]);
    return [[APPLICATION_DELEGATE savedMaps] count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UIButton *button = (UIButton *)view;
    if (button == nil)
	{
            MyMap * theMap = [[APPLICATION_DELEGATE savedMaps]objectAtIndex:index];
            //no button available to recycle, so create new one
        
        //if statement for checking NSString is NULL or NOT NULL

            NSString * imagePath = [[NSString stringWithFormat:@"%@",theMap.mapImagePath] isEqual:[NSNull null]]? @"placeholder.png":[NSString stringWithFormat:@"%@",theMap.mapImagePath] ;
            UIImage *image = [UIImage imageNamed:@"placeholder.png" ];
            NSLog(@"%@",NSStringFromCGSize(image.size));
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setBackgroundImage:image forState:UIControlStateNormal];
//            button.titleLabel.font = [button.titleLabel.font fontWithSize:50];
            [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
	}
	
	//set button label
	[button setTitle:[NSString stringWithFormat:@"%i", index] forState:UIControlStateNormal];
	
	return button;
}

#pragma mark -
#pragma mark Button tap event

- (void)buttonTapped:(UIButton *)sender
{
	//get item index for button
	NSInteger index = [carousel indexOfItemView:sender];
	
    [[[[UIAlertView alloc] initWithTitle:@"Button Tapped"
                                 message:[NSString stringWithFormat:@"You tapped button number %i", index]
                                delegate:nil
                       cancelButtonTitle:@"OK"
                       otherButtonTitles:nil] autorelease] show];
}

#pragma mark - iCarouselDelegate



@end