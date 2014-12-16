//
//  AppDelegate.m
//  Chat
//
//  Created by sky on 14/12/15.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
//    UIStoryboard *loginStoryBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//    UIViewController *loginCtl = [loginStoryBoard instantiateInitialViewController];
//    
//    self.window.rootViewController = loginCtl;
    [self loginStateChange:nil];
    [self.window makeKeyAndVisible];
    return YES;
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
}


-(void)loginStateChange:(NSNotification *)notification
{
    UIViewController *rootCtl = nil;
    
//    BOOL isAutoLogin = [[[EaseMob sharedInstance] chatManager] isAutoLoginEnabled];
//    BOOL loginSuccess = [notification.object boolValue];
    
    if ( /* DISABLES CODE */ (0) /*isAutoLogin || loginSuccess*/) {
//        [[ApplyViewController shareController] loadDataSourceFromLocalDB];
        if (!self.mainController) {
            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            self.mainController = (SKYRootViewController *)[mainStoryBoard instantiateInitialViewController];

        }else{
            NSLog(@"reuse");
        }
        rootCtl = self.mainController;
    }else{
        self.mainController = nil;
        UIStoryboard *loginStoryBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        rootCtl = [loginStoryBoard instantiateInitialViewController];
        
    }
    
    self.window.rootViewController = rootCtl;

}

@end
