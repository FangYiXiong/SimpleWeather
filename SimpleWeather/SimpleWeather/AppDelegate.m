//
//  AppDelegate.m
//  SimpleWeather
//
//  Created by Yixiong on 14-5-23.
//  Copyright (c) 2014年 Fang Yixiong. All rights reserved.
//

#import "AppDelegate.h"
#import "WXController.h"
#import <TSMessage.h>
#import "GAI.h"

#define LAST_RUN_TIME        @"last_run_time_of_application"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-20258124"];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.rootViewController = [WXController new];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //
    [TSMessage setDefaultViewController:self.window.rootViewController];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    double timeSince2001 = (double)[NSDate timeIntervalSinceReferenceDate];
    NSInteger currentTime = timeSince2001 / (60*60*24);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger lastRunTime    = [[defaults objectForKey:LAST_RUN_TIME] integerValue];
    if (lastRunTime == 0) {
        [defaults setObject:@(currentTime) forKey:LAST_RUN_TIME];
        // App is being run for first time
    }
    else if (currentTime - lastRunTime > 0) {
        [defaults setObject:@(currentTime) forKey:LAST_RUN_TIME];
        WXController *controller = (WXController *)self.window.rootViewController;
        [controller refreshBackgroundImage];
        // App has been updated since last run
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
