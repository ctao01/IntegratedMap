//
//  AppDelegate.m
//  Map_v3
//
//  Created by Joy Tao on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"

@implementation AppDelegate
@synthesize navigationController = _navigationController;
@synthesize rootViewController = _rootViewController;
@synthesize window = _window;
@synthesize path = _path;
@synthesize savedMaps = _savedMaps;
@synthesize facebook;

- (void)dealloc
{
    [_rootViewController release];
    [_navigationController release];
    [_window release];
    
    [_savedMaps release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    self.rootViewController = [[RootViewController alloc]init];
    self.navigationController = [[UINavigationController alloc]initWithRootViewController:self.rootViewController];
    [self.window addSubview:self.navigationController.view];

    // Initialize plist data
    NSError * error;
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentDirectory = [paths objectAtIndex:0];
    self.path = [documentDirectory stringByAppendingPathComponent:@"SavedData.plist"];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:self.path])
    {
        NSString * bundle = [[NSBundle mainBundle]pathForResource:@"SavedMaps" ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath:self.path error:&error];
        //        path = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"SavedData.plist"]];
        NSLog(@"file doesn't exist, create a new path:%@", self.path);
    }
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.path forKey:@"path"];
    [defaults synchronize];
    NSLog(@"%@", defaults);
    
    if (self.savedMaps == nil) 
    {
        NSArray * mapDicts = [NSMutableArray arrayWithContentsOfFile:self.path];
        if (mapDicts == nil)
        {
            NSLog(@"Unable to read plist file at path: %@", self.path);
            self.path = [[NSBundle mainBundle] pathForResource:@"SavedMaps"
                                                   ofType:@"plist"];
            mapDicts = [NSMutableArray arrayWithContentsOfFile:self.path];
        }
        
        self.savedMaps = [[NSMutableArray alloc] initWithCapacity:[mapDicts count]];
    }
    SettingTableViewController * settingVC = (SettingTableViewController*)self.rootViewController.tvSetting;
    facebook = [[Facebook alloc] initWithAppId:kAPPID andDelegate:settingVC];
    
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    self.window.backgroundColor = [UIColor blackColor];
    
    NSLog(@"NSDATE%@",[NSDate date]);
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}
#pragma mark -
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url 
{
    return [self.facebook handleOpenURL:url];
}

- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [self.facebook handleOpenURL:url];
    
}

@end
