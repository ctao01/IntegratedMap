//
//  DetailedViewController.m
//  Map_v3
//
//  Created by Joy Tao on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailedViewController.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "EditableCell.h"
#import "MyPlace.h"
#import "MapViewController.h"

#import "Reachability.h"

@implementation DetailedViewController
@synthesize thePlace ;
@synthesize nameCell , noteCell;
@synthesize address1Cell, address2Cell, cityCell, stateCell, zipCodeCell, countryCell;
@synthesize parentViewController;

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
    [thePlace release];
    
    [nameCell release];
    [address1Cell release];
    [address2Cell release];
    [cityCell release];
    [stateCell release];
    [zipCodeCell release];
    [countryCell release];
    [noteCell release];
    
    NSLog(@"detailedViewController - dealloc");
    [super dealloc];
}

#pragma mark - 

- (BOOL)isModal
{
    NSArray *viewControllers = [[self navigationController] viewControllers];
    UIViewController *rootViewController = [viewControllers objectAtIndex:0];
    NSLog(@"%@",NSStringFromClass([rootViewController class]));
    
    return rootViewController == self;
}


- (EditableCell *) newDetailCellWithTag:(NSInteger)tag
{
    EditableCell * cell = [[EditableCell alloc]initWithFrame:CGRectZero];
    
    [cell.textField setDelegate:self];
    [cell.textField setTag:tag];
    
    return cell;
}
// TODO: modify saved data

//- (void) update
//{
//    NSArray *viewControllers = [[self navigationController] viewControllers];
//    MapViewController * vcMap = [viewControllers objectAtIndex:[viewControllers count]-2];
//    NSLog(@"%@",[vcMap description]);
//    [thePlace setLatitude:[NSNumber numberWithDouble:vcMap.lat]];
//    [thePlace setLongitude:[NSNumber numberWithDouble:vcMap.lng]];
//    
//    NSDate * timestamp = [NSDate date];
//    [thePlace setTimestamp:timestamp];
//}

#pragma mark - UIButton Action

- (void) save 
{
    if ([self isModal])
    {
        AppDelegate * delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        MapViewController * vcMap = (MapViewController *)delegate.navigationController.topViewController;
        [thePlace setLatitude:[NSNumber numberWithDouble:vcMap.lat]];
        [thePlace setLongitude:[NSNumber numberWithDouble:vcMap.lng]];
        
        NSDate * timestamp = [NSDate date];
        [thePlace setTimestamp:timestamp];
        
        [vcMap.placeMarks addObject:thePlace];
        [self.navigationController dismissModalViewControllerAnimated:YES];
    }
            
    else
    {
        NSArray *viewControllers = [[self navigationController] viewControllers];
        MapViewController * vcMap = (MapViewController *)[viewControllers objectAtIndex:[viewControllers count] -2];
//        [vcMap.placeMarks removeObject:thePlace];
        
//        MyPlace * theModifiedPlace = [[MyPlace alloc]init];
//        [theModifiedPlace setLatitude:[NSNumber numberWithDouble:vcMap.lat]];
//        [theModifiedPlace setLongitude:[NSNumber numberWithDouble:vcMap.lng]];
        
//        NSDate * timestamp = [NSDate date];
//        [theModifiedPlace setTimestamp:timestamp]; 
//        [vcMap.placeMarks addObject:theModifiedPlace];
//        [vcMap.placeMarks addObject:thePlace];
        NSDate * timestamp = [NSDate date];
        [thePlace setTimestamp:timestamp];
        [vcMap.placeMarks addObject:thePlace];


        [[self navigationController] popViewControllerAnimated:YES];
    }
    
}

- (void) cancel
{
    [self.navigationController dismissModalViewControllerAnimated:YES];

}

#pragma mark - Check for networking connection

-(void) checkNetworkStatus:(NSNotification *)notice
{
    // called after network status changes
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable:
        {
            NSLog(@"The internet is down.");
            isConnected = NO;
            
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI.");
            isConnected = YES;
            
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN.");
            isConnected = YES;
            break;
        }
    }
    
    NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
    switch (hostStatus)
    {
        case NotReachable:
        {
            NSLog(@"A gateway to the host server is down.");
            isConnected = NO;
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"A gateway to the host server is working via WIFI.");
            isConnected = YES;
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"A gateway to the host server is working via WWAN.");
            isConnected = YES;
            break;
        }
    }
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
//    [super viewDidLoad];
//    annotation = [[Annotation alloc]init];

    if ([self isModal])
    {
        
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] 
                                         initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                         target:self
                                         action:@selector(cancel)];
        
        [[self navigationItem] setLeftBarButtonItem:cancelButton];
        [cancelButton release];
        
    }

        
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] 
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                       target:self
                                       action:@selector(save)];
        
        [[self navigationItem] setRightBarButtonItem:saveButton];
        [saveButton release];
  
    [self setNameCell: [self newDetailCellWithTag:locationName]];
    [self setAddress1Cell: [self newDetailCellWithTag:locationAddress_1]];
    [self setAddress2Cell: [self newDetailCellWithTag:locationAddress_1]];
    [self setCityCell: [self newDetailCellWithTag:locationCity]];
    [self setStateCell: [self newDetailCellWithTag:locationState]];
    [self setZipCodeCell: [self newDetailCellWithTag:locationZipCode]];
    [self setCountryCell: [self newDetailCellWithTag:locationCountry]];
    [self setNoteCell: [self newDetailCellWithTag:locationNote]];
    
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
    
    NSUInteger indexes[] = { 0, 0 };
    NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:indexes
                                                        length:2];
    
    EditableCell *cell = (EditableCell *)[[self tableView] cellForRowAtIndexPath:indexPath];    
    [[cell textField] becomeFirstResponder];
    
    // check for internet connection
    if (! [self isModal]) 
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
        
        internetReachable = [[Reachability reachabilityForInternetConnection] retain];
        [internetReachable startNotifier];
        
        // check if a pathway to a random host exists
        hostReachable = [[Reachability reachabilityWithHostName: @"www.apple.com"] retain];
        [hostReachable startNotifier];
    }
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    for (NSUInteger section = 0; section < [[self tableView] numberOfSections]; section++)
    {
        for (NSUInteger row = 0; row < [[self tableView] numberOfRowsInSection:section]; row++)
        {
            NSUInteger indexes[] = { section, row };
            NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:indexes
                                                                length:2];
            
            EditableCell *cell = (EditableCell *)[[self tableView]cellForRowAtIndexPath:indexPath];
            if ([[cell textField] isFirstResponder])
            {
                [[cell textField] resignFirstResponder];
            }
            
            
        }
    }
    
    if ([APPLICATION_DEFAULTS boolForKey:@"Reverse_Geocoder"] == YES) {
        if (isConnected == YES) {
            UIAlertView * reverseGeocoderAlert = [[UIAlertView alloc]initWithTitle:@"Notice" message:@"Would you like to get the place information?" delegate:self cancelButtonTitle:@"No, thanks." otherButtonTitles:@"Sure, do it", nil];
            [reverseGeocoderAlert show];
            [reverseGeocoderAlert release];
        }
        else {
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"Notice" message:@"Please check the internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
            [alertView release];
        }
    }
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIAlertView Delegate Method

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) return;
    if (buttonIndex == 1) 
    {
        CLLocationCoordinate2D pinCenter;
        pinCenter.latitude = [thePlace.latitude doubleValue];
        pinCenter.longitude = [thePlace.longitude doubleValue];
        
        MKReverseGeocoder * myReverse = [[MKReverseGeocoder alloc] initWithCoordinate:pinCenter];
        myReverse.delegate = self;
        [myReverse start];
    }
}

#pragma mark - MKReverseGeocoderDelegate Method

- (void) reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    geocoder.delegate = nil;
    [geocoder autorelease];
}

- (void) reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
    NSLog(@"Reverse Geocoder completed");
    
//    nameCell.textField.text = [placemark name];
//    address1Cell.textField.text = [placemark thoroughfare];
//    address2Cell.textField.text = [placemark subThoroughfare];
//    cityCell.textField.text = [placemark locality];
//    stateCell.textField.text = [placemark administrativeArea];
//    zipCodeCell.textField.text = [placemark postalCode];
//    countryCell.textField.text = [placemark country];

    [thePlace setLocationName:[placemark name]];
    [thePlace setStreetAddress:[placemark thoroughfare]];
    [thePlace setSubStreetAddress:[placemark subThoroughfare]];
    [thePlace setCity:[placemark locality]];
    [thePlace setState:[placemark administrativeArea]];
    [thePlace setZipCode:[placemark postalCode]];
    [thePlace setCountry:[placemark country]];
    
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark UITextFieldDelegate Protocol

//  Sets the label of the keyboard's return key to 'Done' when the insertion
//  point moves to the table view's last field.
//
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField tag] == locationNote)
    {
        [textField setReturnKeyType:UIReturnKeyDone];
    }
    
    
    return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
//    self.navigationItem.title = nameCell.textField.text;
}

//  UITextField sends this message to its delegate after resigning
//  firstResponder status. Use this as a hook to save the text field's
//  value to the corresponding property of the model object.
//
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // TODO: DONE vs SAVE
    static NSNumberFormatter *_formatter;
    
    if (_formatter == nil)
    {
        _formatter = [[NSNumberFormatter alloc] init];
    }
    
    NSString *text = [textField text];
    
    switch ([textField tag])
    {
        case locationName:          [thePlace setLocationName:text];                  break;
        case locationAddress_1:     [thePlace setStreetAddress:text];         break;
        case locationAddress_2:     [thePlace setSubStreetAddress:text];      break;
        case locationCity:          [thePlace setCity:text];                  break;
        case locationState:         [thePlace setState:text];                 break;
        case locationZipCode:       [thePlace setZipCode:text];               break;
        case locationCountry:       [thePlace setCountry:text];               break;
        case locationNote:          [thePlace setComment:text];               break;

    }
}

//  UITextField sends this message to its delegate when the return key
//  is pressed. Use this as a hook to navigate back to the list view 
//  (by 'popping' the current view controller, or dismissing a modal nav
//  controller, as the case may be).
//
//  If the user is adding a new item rather than editing an existing one,
//  respond to the return key by moving the insertion point to the next cell's
//  textField, unless we're already at the last cell.
//
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField returnKeyType] != UIReturnKeyDone)
    {
        //  If this is not the last field (in which case the keyboard's
        //  return key label will currently be 'Next' rather than 'Done'), 
        //  just move the insertion point to the next field.
        //
        //  (See the implementation of -textFieldShouldBeginEditing: above.)
        //
        NSInteger nextTag = [textField tag] + 1;
        UIView *nextTextField = [[self tableView] viewWithTag:nextTag];
        
        [nextTextField becomeFirstResponder];
    }
    
    else if ([self isModal])
    {
        //  We're in a modal navigation controller, which means the user is
        //  adding a new book rather than editing an existing one.
        //
        [self save];
    }
    else
    {
//        [self update];      
        [[self navigationController] popViewControllerAnimated:YES];
    }

    
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
//    return section == 1 ? 6 : 1;
    switch (section) 
    {
        case NameSection:  return 1;
        case LocationSection: return 6;
        case CommentSection:  return 1;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView
  titleForHeaderInSection:(NSInteger)section
{
    switch (section) 
    {
        case NameSection:  return @"Name";
        case LocationSection: return @"Location";
        case CommentSection:  return @"Comment";
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditableCell *cell = nil;
    NSInteger tag = INT_MIN;
    NSString *text = nil;
    NSString *placeholder = nil;
    
    //  Pick the editable cell and the values for its textField
    //
    NSUInteger section = [indexPath section];
    switch (section) 
    {
        case NameSection:
        {
            cell = [self nameCell];
            text = [thePlace locationName];
            tag = locationName;
            placeholder = @"Location Name";
            break;
        }
        case LocationSection:
        {
            if ([indexPath row] == 0)
            {
                cell = [self address1Cell];
                text = [thePlace streetAddress];
                tag = locationAddress_1;
                placeholder = @"Address 1";
            }
            else if ([indexPath row] == 1)
            {
                
                cell = [self address2Cell];
                text = [thePlace subStreetAddress];
                tag = locationAddress_2;
                placeholder = @"Address 2";
            }
            
            else if ([indexPath row] == 2)
            {
                cell = [self cityCell];
                text = [thePlace city];
                tag = locationCity;
                placeholder = @"City";
            }
            
            else if ([indexPath row] == 3)
            {
                cell = [self stateCell];
                text = [thePlace state];
                tag = locationState;
                placeholder = @"State";
            }
            
            else if ([indexPath row] == 4)
            {
                cell = [self zipCodeCell];
                text = [thePlace zipCode];
                tag = locationZipCode;
                placeholder = @"Zipcode";
            }
            else
            {
                cell = [self countryCell];
                text = [thePlace country];
                tag = locationCountry;
                placeholder = @"Country";
            }
           
            
            break;            
        }
        case CommentSection:
        {
            cell = [self noteCell];
            text = [thePlace comment];
            tag = locationNote;
            placeholder = @"Comment";
            break;
        }
    }
    
    UITextField *textField = [cell textField];
    [textField setTag:tag];
    [textField setText:text];
    [textField setPlaceholder:placeholder];
    
    
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
