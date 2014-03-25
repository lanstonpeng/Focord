//
//  AppDelegate.m
//  Focord
//
//  Created by Lanston Peng on 2/7/14.
//  Copyright (c) 2014 Vtmer. All rights reserved.
//

#import "AppDelegate.h"
#import "CollectionViewController.h"
@interface AppDelegate()
@property (strong,readonly,nonatomic)NSManagedObjectModel* managedObjectModel;
@property(strong,readonly,nonatomic)NSManagedObjectContext* managedObjectContext;
@property(strong,readonly,nonatomic)NSPersistentStoreCoordinator* persistentStoreCoordinator;
- (NSURL *)applicationDocumentsDirectory;
@end

@implementation AppDelegate
@synthesize managedObjectModel=_managedObjectModel, managedObjectContext=_managedObjectContext, persistentStoreCoordinator=_persistentStoreCoordinator;

- (NSManagedObjectContext *) managedObjectContext
{
  if (_managedObjectContext != nil) {
    return _managedObjectContext;
  }
  NSPersistentStoreCoordinator* coordinator = [self persistentStoreCoordinator];
  if(coordinator != nil){
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator: coordinator];
  }
  //NSLog(@"==>%@",_managedObjectContext);
  return _managedObjectContext;
}

-(NSManagedObjectModel *)managedObjectModel
{
  if(!_managedObjectModel){
    //It's not a recommended way
    //NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Focord" withExtension:@"momd"];
    //_managedObjectModel  = [[NSManagedObjectModel alloc]initWithContentsOfURL:modelURL];
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
  }
  return _managedObjectModel;
}
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
  if (_persistentStoreCoordinator != nil) {
    return _persistentStoreCoordinator;
  }
  NSURL* storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoreDataFocord.CDStore"];
  NSFileManager* fileManager = [NSFileManager defaultManager];
  if(![fileManager fileExistsAtPath:[storeURL path]]){
    NSURL* defaultStoreURL = [[NSBundle mainBundle]URLForResource:@"CoreDataFocord" withExtension:@"CDStore"];
    if(defaultStoreURL){
      [fileManager copyItemAtURL:defaultStoreURL toURL:storeURL error:NULL];
    }
  }
  NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @YES, NSInferMappingModelAutomaticallyOption: @YES};
  _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:[self managedObjectModel]];
  NSError* error;
  if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]){
    NSLog(@"oops persistenSotreCoordinator crashed %@",error);
    
    //This's a ugly fixed,since the model would changed sometimes,and it needs to migrate,so just delete the old one...
    NSError* fileDeleteError;
    if([fileManager fileExistsAtPath:[storeURL path]]){
      [fileManager removeItemAtPath:[storeURL path] error:&fileDeleteError];
    }
    [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error];
  }
  return _persistentStoreCoordinator;
}

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
  return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
  CollectionViewController* cvc = (CollectionViewController*)self.window.rootViewController;
  cvc.managedObjectContext = self.managedObjectContext;
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
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
