//
//  AppDelegate.m
//  Twitter
//
//  Created by Jhih-Yan Lin on 6/27/15.
//  Copyright (c) 2015 Jhih-Yan Lin. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TweetViewController.h"
#import "TwitterClient.h"
#import "User.h"
#import "Tweet.h"
#import "MainVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLogout) name:UserLogoutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLogin) name:UserLoginNotification object:nil];

    
   
    UINavigationController *navgationController = [[UINavigationController alloc] init];

    self.window.rootViewController = navgationController;

    
    User *user = [User getUser];
    
    if (user != nil) {
        NSLog(@"User %@ login", user.name);
        [navgationController pushViewController:[[TweetViewController alloc]init] animated:YES];
    
    } else {
        NSLog(@"User logout");
        [navgationController pushViewController:[[LoginViewController alloc] init] animated:YES];
    }
    
    [self.window makeKeyAndVisible];

   
    return YES;
}

- (void)onLogout {
    NSLog(@"User logout");

    UINavigationController *navgationController = [[UINavigationController alloc] init];
    
    self.window.rootViewController = navgationController;

    [navgationController pushViewController: [[LoginViewController alloc] init] animated:YES];

}

- (void)onLogin {
    NSLog(@"User login");
    
    UINavigationController *navgationController = [[UINavigationController alloc] init];
    
    self.window.rootViewController = navgationController;
    
    [navgationController pushViewController: [[TweetViewController alloc] init] animated:YES];
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

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    [[TwitterClient sharedInstance] openUrl:url];
        
    return YES;
}

@end
