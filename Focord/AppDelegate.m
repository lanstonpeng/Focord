//
//  AppDelegate.m
//  Focord
//
//  Created by Lanston Peng on 2/7/14.
//  Copyright (c) 2014 Vtmer. All rights reserved.
//

#import "AppDelegate.h"
#import "CollectionViewController.h"
#import "DataAbstract.h"
#import "MotionMonitor.h"
@interface AppDelegate()
- (NSURL *)applicationDocumentsDirectory;
@end

@implementation AppDelegate
// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
  return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //disable device from automatically sleeping
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"will resign active");
    [self saveContext];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"did enter background");
    DataAbstract* da = [DataAbstract sharedData];
    [da flushData];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"will enter foreground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"did become active");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self saveContext];
}
- (void)saveContext{
    MotionMonitor* monitor = [MotionMonitor sharedMotionManager];
    [monitor stopMonitor];
    DataAbstract* da = [DataAbstract sharedData];
    [da flushData];
}
@end
