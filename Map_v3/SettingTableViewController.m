//
//  SettingTableViewController.m
//  Map_v3.7
//
//  Created by Joy Tao on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingTableViewController.h"
#import "AppDelegate.h"

@interface SettingTableViewController () {
    NSMutableDictionary * settingDict;
}
@end

@implementation SettingTableViewController
@synthesize vcParent;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        settingDict = [[NSMutableDictionary alloc]init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(apiGraphMe) name:@"FBDidLogin" object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fbLogout) name:@"FBDidLogout" object:nil];

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

#pragma mark - Facebook Graph API

- (void)apiGraphMe {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"name,picture",  @"fields",
                                   nil];
    [[Facebook shared]requestWithGraphPath:@"me" andParams:params andDelegate:self];
    NSLog(@"apiGraphMe");
}

//- (void) fbLogout
//{
//    [[Facebook shared]logout];
//}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSArray * usernameArray = [NSArray arrayWithObjects:@"Username", nil];
    NSArray * accountArray = [NSArray arrayWithObjects:@"Google" , @"Facebook" , @"Twitter", nil];
    NSArray * controlArray = [NSArray arrayWithObjects:@"Sounds" , @"Brightness" , @"Type", @"GeoReverse", nil];
    NSArray * otherArray = [NSArray arrayWithObjects:@"Support" , @"Help" , @"About Us", nil];
    
    [settingDict setObject:usernameArray forKey:@"username_setting"];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FBDidLogin" object:nil];

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
    if (section == UserNameSetting) 
        return [[settingDict objectForKey:@"username_setting"]count];
    else if (section == AccountSetting) 
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
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];

    
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
    if (indexPath.section == UserNameSetting) 
    {
        cell.textLabel.text = [[settingDict objectForKey:@"username_setting"]objectAtIndex:indexPath.row]; 
        cell.accessoryView = arrowBtn;
        cell.detailTextLabel.text = [defaults objectForKey:@"IMUsername"]? [defaults objectForKey:@"IMUsername"] : @"(none)";
    }
    
    else if (indexPath.section == AccountSetting) 
    {
        cell.textLabel.text = [[settingDict objectForKey:@"account_setting"]objectAtIndex:indexPath.row]; 
        if (indexPath.row == 0) 
            cell.detailTextLabel.text = [defaults objectForKey:@"GL_USERNAME"]? [defaults objectForKey:@"GL_USERNAME"] : @"no config";
        
        if (indexPath.row == 1) 
            cell.detailTextLabel.text = [defaults objectForKey:@"FB_USERNAME"]? [defaults objectForKey:@"FB_USERNAME"] : @"no config";
        cell.accessoryView = arrowBtn;
    }
    else if (indexPath.section == ControlSetting) 
    {
        cell.textLabel.text = [[settingDict objectForKey:@"control_setting"]objectAtIndex:indexPath.row]; 
        if (indexPath.row == 3) 
        {
            UISwitch * geoReversedSwitch = [[UISwitch alloc]initWithFrame:CGRectZero];
            [geoReversedSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = geoReversedSwitch;
            
            //TODO: checkButtonTapped:(id)sender event:(id)event
        }
    }
    else if (indexPath.section == OtherSetting) 
        cell.textLabel.text = [[settingDict objectForKey:@"other_setting"]objectAtIndex:indexPath.row]; 
    else return nil; 
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

- (void) switchChanged:(id)sender
{
    UISwitch * switchControl = sender;
    NSLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );

}

#pragma mark - Table view delegate

- (void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//    AppDelegate * delegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    
    if (indexPath.section == UserNameSetting) {
        if (![defaults objectForKey:@"IMUsername"])
        {
            UIAlertView * usernameSettingView = [[UIAlertView alloc]initWithTitle:@"Username" message:@"please create your username" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"That's it", nil];
            [usernameSettingView setAlertViewStyle:UIAlertViewStylePlainTextInput];
            
            [usernameSettingView setDelegate:self];
            [usernameSettingView show];
            [usernameSettingView release];
        }
    }
    
    if (indexPath.section == AccountSetting ) 
    {
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
            
            [self.tableView reloadData];

            
        }
        
        else if (indexPath.row == 1)
        {
            if ( ![defaults objectForKey:@"FB_USERNAME"])
            {
                [[Facebook shared]authorize];
                [self apiGraphMe];
            }
            else {
                [[Facebook shared]logout];
                [defaults removeObjectForKey:@"FB_USERNAME"];
                [defaults synchronize];
                
            }
//            if (![[delegate facebook] isSessionValid]) 
//            {   
//                NSArray *permissions = [[NSArray alloc] initWithObjects:
//                                        @"user_activities", 
//                                        @"read_friendlists",
//                                        @"offline_access",
//                                        nil];
//                [[delegate facebook] authorize:permissions];
//                [permissions release];
//            }
//            else
//                [delegate.facebook logout];
        }
        
        [self.tableView reloadData];
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
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];

    if (buttonIndex == alertView.cancelButtonIndex)  return;
    
    if ([alertView.title isEqualToString:@"Username"])
    {
        if (buttonIndex == 1) {
            [defaults setObject:[[alertView textFieldAtIndex:0] text] forKey:@"IMUsername"];
            [defaults synchronize];
            [self.tableView reloadData];

        }
        else return;
    }
    
    if ([alertView.title isEqualToString:@"Google"])
    {
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
                [defaults setObject:[[alertView textFieldAtIndex:0] text] forKey:@"GL_USERNAME"];
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
                [defaults removeObjectForKey:@"GL_USERNAME"];
                [defaults synchronize];
            }
        }
    } 
}

/*
#pragma mark - FBSessionDelegate
- (void)fbDidLogin
{
    AppDelegate * delegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[delegate.facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[delegate.facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}
- (void)fbDidNotLogin:(BOOL)cancelled
{
    
}


- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
}
- (void)fbDidLogout
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]) {
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"];
        [defaults synchronize];
    }
}

- (void)fbSessionInvalidated
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Auth Exception"
                              message:@"Your session has expired."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil,
                              nil];
    [alertView show];
    [alertView release];
    [self fbDidLogout];
}
*/

#pragma mark - FBRequestDelegate Method

/**
 * Called just before the request is sent to the server.
 */
- (void)requestLoading:(FBRequest *)request{
    
}

/**
 * Called when the server responds and begins to send back data.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"received response!");
}

/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error{
   
    NSLog(@"Error message: %@", [[error userInfo] objectForKey:@"error_msg"]);

}

/**
 * Called when a request returns and its response has been parsed into
 * an object.
 *
 * The resulting object may be a dictionary, an array, a string, or a number,
 * depending on thee format of the API response.
 */
- (void)request:(FBRequest *)request didLoad:(id)result
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if ([result isKindOfClass:[NSDictionary class]])
    {
        NSString * fbUsername = [result objectForKey:@"name"];
        [defaults setObject:fbUsername forKey:@"FB_USERNAME"];
        [defaults synchronize];
    } 
    [self.tableView reloadData];
}

/**
 * Called when a request returns a response.
 *
 * The result object is the raw response from the server of type NSData
 */
- (void)request:(FBRequest *)request didLoadRawResponse:(NSData *)data{
    
}

@end
