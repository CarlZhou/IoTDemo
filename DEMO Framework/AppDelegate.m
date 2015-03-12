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
#import "WebSocketManager.h"
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
    
    [self readUpdatingFrequencyFromUserDefaults];
    [self enforceLaunchScreen];
    
    return YES;
}

- (void)readUpdatingFrequencyFromUserDefaults
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults integerForKey:@"Sensor_Reading_Updating_Frequency"] == 0)
    {
        [defaults setObject:[NSNumber numberWithInteger:5]
                     forKey:@"Sensor_Reading_Updating_Frequency"];
    }
    if ([defaults integerForKey:@"Sensor_Updating_Frequency"] == 0)
    {
        [defaults setObject:[NSNumber numberWithInteger:5]
                     forKey:@"Sensor_Updating_Frequency"];
    }
    
    [DataManager sharedManager].sensorUpdatingFrequency = [NSNumber numberWithInteger:[defaults integerForKey:@"Sensor_Updating_Frequency"]];
    [DataManager sharedManager].sensorReadingUpdatingFrequency = [NSNumber numberWithInteger:[defaults integerForKey:@"Sensor_Reading_Updating_Frequency"]];
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
    [[WebSocketManager sharedManager] closeWebSocketConnection];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self readUpdatingFrequencyFromUserDefaults];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[WebSocketManager sharedManager] closeWebSocketConnection];
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
