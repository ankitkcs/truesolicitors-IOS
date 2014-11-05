//
//  KCSAppDelegate.m
//  TrueClaim
//
//  Created by krish on 7/19/14.
//  Copyright (c) 2014 KCSPL. All rights reserved.
//

#import "KCSAppDelegate.h"
#import "IntroViewController.h"

@implementation KCSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //get and save the uuid
//    if([ApplicationData sharedInstance].deviceUUID == nil)
//    {
//        NSString *getUUID = [ApplicationData uuid];
//        [ApplicationData setOfflineObject:getUUID forKey:DEVICE_UUID];
//    }
    
    if([ApplicationData offlineObjectForKey:DEVICE_UUID] == nil)
    {
        NSString *getUUID = [ApplicationData uuid];
        [ApplicationData setOfflineObject:getUUID forKey:DEVICE_UUID];
    }
    
    NSLog(@"SAVED UUID : %@",[ApplicationData offlineObjectForKey:DEVICE_UUID]);
    
    if([ApplicationData offlineObjectForKey:FIRST_RUN] == nil)
    {
        NSString *FirstTimeRun = @"running_first_time";
        [ApplicationData setOfflineObject:FirstTimeRun forKey:FIRST_RUN];
    }

    // Override point for customization after application launch.
    //    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //    HomeViewController *introViewController = [storyBoard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    //
    //    self.navCon = [[UINavigationController alloc] initWithRootViewController:introViewController];
    //    [self.window setRootViewController:self.navCon];
    //
    //    [ApplicationData sharedInstance].isFirstTime = YES;
    //    [ApplicationData sharedInstance].isDisply_PassCodeScreen = YES;
    
    NSLog(@"DIRECTORY FOUND HERE : %@", [self applicationDocumentsDirectory]);
    
    //DIRECTORY FOUND HERE : /Users/krish/Library/Application Support/iPhone Simulator/
    
    return YES;
}


- (NSString *)applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = [paths firstObject];
    return basePath;
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
