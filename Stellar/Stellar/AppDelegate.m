//
//  AppDelegate.m
//  Stellar
//
//  Created by Kai on 4/11/15.
//  Copyright (c) 2015 Appslab. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import "LoginViewController.h"
#import "ChallengesViewController.h"
#import "ProfileViewController.h"
#import "AstronautsViewController.h"
#import "LiveViewController.h"
#import "APIManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [Parse setApplicationId:@"XcKF1osnd9lmHdNW0A3PCvinbCZeYnGb9l1vlT6R" clientKey:@"RgannDRVGc23n5623xB3YuniHI499UobSpPVnNRt"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    UIColor *navColor = [UIColor colorWithRed:238.0 green:81/255.0 blue:51/255.0 alpha:1];
    UIFont *navFont = [UIFont fontWithName:@"Moon" size:18.0f];

    NSDictionary *navStyle = @{
                               NSForegroundColorAttributeName: [UIColor whiteColor]
                               ,NSFontAttributeName: navFont
                               };
    
    UIViewController *liveVC = [[LiveViewController alloc] initWithNibName:@"LiveViewController" bundle:nil];
    UINavigationController *liveNavController = [[UINavigationController alloc] initWithRootViewController:liveVC];
    [liveNavController.navigationBar setBarTintColor: navColor];
    liveNavController.navigationBar.titleTextAttributes =  navStyle;
    liveNavController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIViewController *challengesVC = [[ChallengesViewController alloc] initWithNibName:@"ChallengesViewController" bundle:nil];
    UINavigationController *challengesNavController = [[UINavigationController alloc] initWithRootViewController:challengesVC];
    [challengesNavController.navigationBar setBarTintColor: navColor];
    challengesNavController.navigationBar.titleTextAttributes =  navStyle;
    challengesNavController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIViewController *profileVC = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
    UINavigationController *profileNavControler = [[UINavigationController alloc] initWithRootViewController:profileVC];
    [profileNavControler.navigationBar setBarTintColor: navColor];
    profileNavControler.navigationBar.titleTextAttributes =  navStyle;
    profileNavControler.navigationBar.tintColor = [UIColor whiteColor];
    
    
    UIViewController *astronautsVC = [[AstronautsViewController alloc] initWithNibName:@"AstronautsViewController" bundle:nil];
    UINavigationController *astronautsNavControler = [[UINavigationController alloc] initWithRootViewController:astronautsVC];
    [astronautsNavControler.navigationBar setBarTintColor: navColor];
    astronautsNavControler.navigationBar.titleTextAttributes =  navStyle;
    astronautsNavControler.navigationBar.tintColor = [UIColor whiteColor];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects: challengesNavController, astronautsNavControler, liveNavController, profileNavControler, nil];
    
    UIColor *titleHighlightedColor = [UIColor colorWithRed:153/255.0 green:192/255.0 blue:48/255.0 alpha:1.0];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleHighlightedColor, UITextAttributeTextColor,
                                                       nil] forState:UIControlStateHighlighted];
    
    [[UITabBar appearance] setTintColor:navColor];
    
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    
    LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [PFFacebookUtils initializeFacebook];
    
    NSLog(@"Verifyng session ****");
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        NSLog(@"Ready session **** %@", [PFUser currentUser]);
        [self.window setRootViewController:self.tabBarController];
        NSData* currentUserData = [prefs objectForKey:@"sessionKey"];
        Client *currentUser = [NSKeyedUnarchiver unarchiveObjectWithData:currentUserData];
        [[APIManager sharedManager] setSharedUser:currentUser];
    }else{
        NSLog(@"Login session ****");
        [prefs setObject:nil forKey:@"sessionKey"];
        [prefs synchronize];
        
        self.window.rootViewController = loginViewController;
    }
    
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
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:[PFFacebookUtils session]];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
