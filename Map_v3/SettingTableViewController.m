//
//  SettingTableViewController.m
//  Map_v3.7
//
//  Created by Joy Tao on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingTableViewController.h"

@interface SettingTableViewController () {
    NSMutableDictionary * settingDict;
}
@end

@implementation SettingTableViewController
@synthesize vcParent;
@synthesize facebook;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        settingDict = [[NSMutableDictionary alloc]init];
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
    [settingDict release]; 
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSArray * accountArray = [NSArray arrayWithObjects:@"Google" , @"Facebook" , @"Twitter", nil];
    NSArray * controlArray = [NSArray arrayWithObjects:@"Sounds" , @"Brightness" , @"Type", @"GeoReverse", nil];
    NSArray * otherArray = [NSArray arrayWithObjects:@"Support" , @"Help" , @"About Us", nil];
    
    [settingDict setObject:accountArray forKey:@"account_setting"];
    [settingDict setObject:controlArray forKey:@"control_setting"];
    [settingDict setObject:otherArray forKey:@"other_setting"];

    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"Setting";
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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (settingDict) 
       return  [settingDict count];
    else
        return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == AccountSetting) 
        return [[settingDict objectForKey:@"account_setting"]count];
    else if (section == ControlSetting) 
        return [[settingDict objectForKey:@"control_setting"]count];
    else if (section == OtherSetting) 
        return [[settingDict objectForKey:@"other_setting"]count];
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UIButton * arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage * image = [UIImage imageNamed:@"Black_Arrowhead_right.png"];
    [arrowBtn setFrame:CGRectMake(0.0f, 0.0f, image.size.width, image.size.height)];
    [arrowBtn setBackgroundImage:image forState:UIControlStateNormal];
    [arrowBtn addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    if (indexPath.section == AccountSetting) 
    {
        cell.textLabel.text = [[settingDict objectForKey:@"account_setting"]objectAtIndex:indexPath.row]; 
        cell.accessoryView = arrowBtn;
    }
    else if (indexPath.section == ControlSetting) 
        cell.textLabel.text = [[settingDict objectForKey:@"control_setting"]objectAtIndex:indexPath.row]; 
    else if (indexPath.section == OtherSetting) 
        cell.textLabel.text = [[settingDict objectForKey:@"other_setting"]objectAtIndex:indexPath.row]; 
    else
        cell.textLabel.text = nil;
    // Configure the cell...
    
    return cell;
}
- (void)checkButtonTapped:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    if (indexPath != nil)
        [self tableView:self.tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
}

#pragma mark - Table view delegate

- (void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    if (indexPath.row == 0) {
        if (! [defaults objectForKey:@"AuthorizationToken"])
        {
            UIAlertView * gLoginView = [[UIAlertView alloc]initWithTitle:@"Google" message:@"Connect to Google Account" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Connect", nil];
            [gLoginView setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
            [[gLoginView textFieldAtIndex:0]setPlaceholder:@"Username" ];
            [[gLoginView textFieldAtIndex:0]setFont:[UIFont fontWithName:@"Helvetica" size:14]];
            [[gLoginView textFieldAtIndex:1]setPlaceholder:@"Password" ];
            [[gLoginView textFieldAtIndex:1]setFont:[UIFont fontWithName:@"Helvetica" size:14]];
            
            [gLoginView setDelegate:self];
            [gLoginView show];
            [gLoginView release];
        }
        else
        {
            UIAlertView * gLogoutView = [[UIAlertView alloc]initWithTitle:@"Google" message:@"Disconnect to Google Account" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Disconnect", nil];
            [gLogoutView setDelegate:self];
            [gLogoutView show];
            [gLogoutView release];
        }
        
    }
}

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

#pragma mark - UIAlertViewDelegate 
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex)  return;
    
    if ([alertView.title isEqualToString:@"Google"])
    {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        if (buttonIndex == 1)
        {
            if ( ![defaults objectForKey:@"AuthorizationToken"])
            {
                NSURL * url = [NSURL URLWithString:@"https://www.google.com/accounts/ClientLogin"];
                ASIFormDataRequest * loginRequest = [ASIFormDataRequest requestWithURL:url];
                [loginRequest setPostValue:@"GOOGLE" forKey:@"accountType"];
                [loginRequest setPostValue:@"local" forKey:@"service"];
                [loginRequest setPostValue:@"scroll" forKey:@"source"];
                
                [loginRequest setPostValue:[[alertView textFieldAtIndex:0] text] forKey:@"Email"];
                [loginRequest setPostValue:[[alertView textFieldAtIndex:1] text] forKey:@"Passwd"];
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
                [defaults setObject:clientAuth forKey:@"AuthorizationToken"];
                [defaults synchronize];
                
                if (!clientSID || !clientAuth) {
                    // return error
                    UIAlertView *alertUserError= [[UIAlertView alloc]initWithTitle:@"Error" message:@ "Please re-check your Google ID and password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertUserError show];
                    [alertUserError release];
                }
            }
            
            else
            {
                [defaults removeObjectForKey:@"AuthorizationToken"];
                [defaults synchronize];
            }
        }
    }
    
    
    
    
}

@end
