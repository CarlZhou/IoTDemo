//
//  AppDelegate.m
//  DEMO Framework
//
//  Created by Zhou, Zian on 2015-02-17.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import "AppDelegate.h"
#import "RightViewController.h"
#import "MasterViewController.h"
#import "DataManager.h"
#import "APIManager.h"
#import "Constants.h"

@interface AppDelegate () <UISplitViewControllerDelegate>
{
    UIView* launchScreen;
    UIView* errorScreen;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.splitViewController = (UISplitViewController *)self.window.rootViewController;
    self.splitViewController.delegate = self;
    
    // Set API Request Authorization Info
    [APIManager sharedManager].APIAuthorizationMethod = @"Basic";
    [APIManager sharedManager].APIAuthorizationAccount = @"I847885";
    [APIManager sharedManager].APIAuthorizationPassword = @"Black920417!";
    
    [self enforceLaunchScreen];
    
    return YES;
}

- (void)enforceLaunchScreen
{
    // Enforce LaunchScreen Until The Data is loaded
    NSArray* nibViews= [[NSBundle mainBundle] loadNibNamed:@"LaunchScreen"
                                                     owner:self
                                                   options:nil];
    launchScreen = [nibViews objectAtIndex:0];
    [self.splitViewController.view addSubview:launchScreen];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissLaunchScreen) name:SENSOR_DATA_UPDATED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showErrorScreen) name:SENSOR_DATA_UPDATED_FAILED object:nil];
}

- (void)dismissLaunchScreen
{
    [launchScreen removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SENSOR_DATA_UPDATED object:nil];
}

- (void)showErrorScreen
{
    // Enforce LaunchScreen Until The Data is loaded
    NSArray* nibViews= [[NSBundle mainBundle] loadNibNamed:@"ErrorScreen"
                                                     owner:self
                                                   options:nil];
    errorScreen = [nibViews objectAtIndex:0];
    [self.splitViewController.view addSubview:errorScreen];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissErrorScreen) name:SENSOR_DATA_UPDATED object:nil];
}

- (void)dismissErrorScreen
{
    if (errorScreen)
    {
        [errorScreen removeFromSuperview];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SENSOR_DATA_UPDATED object:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}

#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[RightViewController class]] && ([(RightViewController *)[(UINavigationController *)secondaryViewController topViewController] detailItem] == nil)) {
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return YES;
    } else {
        return NO;
    }
}

@end
