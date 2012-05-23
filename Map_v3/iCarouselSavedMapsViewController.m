//
//  iCarouselSavedMapsViewController.m
//  Map_v3.7
//
//  Created by Joy Tao on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "iCarouselSavedMapsViewController.h"
#import "iCarousel.h"
#import "UIImage+FiltrrCompositions.h"

@interface iCarouselSavedMapsViewController () <iCarouselDataSource , iCarouselDelegate >

@property (nonatomic, assign) BOOL wrap;
@property (nonatomic , retain) iCarousel * carousel;
//@property (nonatomic, retain) NSMutableArray *items;

@end


@implementation iCarouselSavedMapsViewController
@synthesize carousel;
@synthesize wrap;
@synthesize vcParent;

//@synthesize items;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        // set up data
//    
//        self.items = [[NSMutableArray alloc] init];
//        for (int i = 0; i < [[APPLICATION_DELEGATE savedMaps] count]; i++) 
//            [items addObject:[NSNumber numberWithInt:i]];
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
    carousel.delegate = self; 
    carousel.dataSource = self;
    
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
    
    wrap = YES;
    
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
    return [[APPLICATION_DELEGATE savedMaps] count];
}

//- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
//{
//    if ([[APPLICATION_DELEGATE savedMaps]count] > 0) {
//        return 1;
//    }
//    else
//        return 0;
//}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UIButton *button = (UIButton *)view;
    if (button == nil)
	{        
       
            //no button available to recycle, so create new one
        
        //if statement for checking NSString is NULL or NOT NULL

//            NSString * imagePath = [[NSString stringWithFormat:@"%@",theMap.mapImagePath] isEqual:[NSNull null]]? @"placeholder.png":[NSString stringWithFormat:@"%@",theMap.mapImagePath] ;
//            UIImage * image = [UIImage imageNamed:@"placeholder.png" ];

        // set buttonImage background
        UIImage * bgImg = [UIImage imageNamed:@"websbook_960x720.png"];
        UIImageView * bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, bgImg.size.width * 0.7f , bgImg.size.height *0.7f)];
        bgImageView.image = bgImg;
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0.0f, 0.0f, bgImageView.frame.size.width , bgImageView.frame.size.height);
//        button.frame = CGRectMake(0.0f, 0.0f, image.size.width , image.size.height);
        [button setBackgroundImage:bgImg forState:UIControlStateNormal];
//            button.titleLabel.font = [button.titleLabel.font fontWithSize:50];
        
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        MyMap * theMap = [[APPLICATION_DELEGATE savedMaps]objectAtIndex:index];

        // If it has imagePath
        if (theMap.mapImagePath) {
            UIImage * mapImg = [[[UIImage alloc]initWithContentsOfFile:theMap.mapImagePath] e11];
            CGSize mapRect = mapImg.size;
            UIImageView * mapImageVIew = [[[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, mapRect.width * 0.6f , mapRect.height * 0.6f)] autorelease];
            mapImageVIew.image = mapImg;
            mapImageVIew.layer.shadowColor = [[UIColor blackColor]CGColor];
            mapImageVIew.layer.shadowOpacity = 1.0f;
            mapImageVIew.layer.shadowOffset = CGSizeMake(-3.0f, 3.0f);
            mapImageVIew.layer.shadowRadius =3.0f;
            mapImageVIew.clipsToBounds = YES;
            mapImageVIew.layer.cornerRadius = 8.0f;
            
            mapImageVIew.center = button.center;
            [button addSubview:mapImageVIew];
        }
        
        else
        {
            NSLog(@"no Image");
            UILabel * label = [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 24.0f)] autorelease];
            label.backgroundColor = [UIColor clearColor];
            label.center = button.center;
            label.text = theMap.mapTitle ? theMap.mapTitle : @"Unknown map";
            [button addSubview:label];
        }
	}
	
	//set button label
//	[button setTitle:[NSString stringWithFormat:@"%i", index] forState:UIControlStateNormal];
	
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

- (BOOL) carouselShouldWrap:(iCarousel *)carousel
{
    // wrap all carousels
    return wrap;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    //slightly wider than item view
    return ITEM_SPACING;
}

- (CGFloat)carousel:(iCarousel *)carousel itemAlphaForOffset:(CGFloat)offset
{
	//set opacity based on distance from camera
    return 1.0f - fminf(fmaxf(offset, 0.0f), 1.0f);
}

- (CATransform3D)carousel:(iCarousel *)_carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * carousel.itemWidth);
}


@end
