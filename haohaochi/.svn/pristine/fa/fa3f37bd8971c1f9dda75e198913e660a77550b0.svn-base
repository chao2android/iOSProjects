//
//  AppDelegate.m
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-11-3.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "ThirdLoginViewController.h"
#import "UMSocial.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialWechatHandler.h"
#import "UIDevice+Orientation.h"
#import "VideoUploadManager.h"
//#import ""


#pragma mark - LandScapeUINavigation

@interface UINavigationController (LandScapeUINavigation)

- (BOOL)shouldAutorotate;

@end

@implementation UINavigationController (LandScapeUINavigation)

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //NSLog(@"Nav shouldAutorotateToInterfaceOrientation");
    return [self.topViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

- (BOOL)shouldAutorotate
{
    //NSLog(@"Nav shouldAutorotate");
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    //NSLog(@"Nav supportedInterfaceOrientations:%ld", [self.topViewController supportedInterfaceOrientations]);
    return [self.topViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    //NSLog(@"Nav preferredInterfaceOrientationForPresentation");
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

@end


@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //3登录
    [UMSocialData setAppKey:UMENG_KEY];
    
    [UMSocialSinaHandler openSSOWithRedirectURL:nil];
    [UMSocialWechatHandler setWXAppId:WX_APPKey appSecret:WX_APPSecret url:@"http://www.umeng.com/social"];
    
    _mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [_mapManager start:BAIDU_KEY generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }

    application.statusBarStyle = UIStatusBarStyleDefault;
    application.statusBarHidden = YES;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [[MDeviceOrientation Share] GetDeviceRotation];
    
    HomeViewController *homeCtrl = [[HomeViewController alloc] init];
    UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:homeCtrl];
    navCtrl.navigationBarHidden = YES;
    self.window.rootViewController = navCtrl;
    
    if (!kkIsLogin) {
        ThirdLoginViewController *tvc = [[ThirdLoginViewController alloc] init];
        [navCtrl pushViewController:tvc animated:NO];
    }
    return YES;
}



#pragma mark - UIInterfaceOrientation

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskAll;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // 上传
    [kVideoUpload.uploadItems writeToPlistFile:DWUploadItemPlistFilename];
    for (DWUploadItem *item in kVideoUpload.uploadItems.items) {
        if (item.uploader) {
            [item.uploader pause];
        }
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_BecomeActive object:nil];
    
    // 上传
    kVideoUpload.uploadItems = [[DWUploadItems alloc] initWithPath:DWUploadItemPlistFilename];
    for (DWUploadItem *item in kVideoUpload.uploadItems.items) {
        switch (item.videoUploadStatus) {
            case DWUploadStatusStart:
                item.videoUploadStatus = DWUploadStatusWait;
                break;
                
            case DWUploadStatusUploading:
                item.videoUploadStatus = DWUploadStatusWait;
                break;
                
            default:
                break;
        }
    }
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

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TestVideoJoiner" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"TestVideoJoiner.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}



#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
