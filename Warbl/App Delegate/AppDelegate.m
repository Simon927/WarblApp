//
//  AppDelegate.m
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#import <CoreTelephony/CoreTelephonyDefines.h>
#import <FacebookSDK/FacebookSDK.h>

#import "AppDelegate.h"

#import "Flurry.h"

// --- Defines ---;
// Flurry API Key;
static NSString * const kFlurryAPIKey = @"VSN5KTVRYF2CHK3KBTJB";

// AppDelegate Class;
@implementation AppDelegate

// Functions;
#pragma mark - AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Flurry;
    [Flurry setCrashReportingEnabled:YES];
    [Flurry startSession:kFlurryAPIKey];
    
    // Status Bar;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // Navigation Bar;
    [[UINavigationBar appearance] setBarTintColor:DEFAULT_COLOR];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont fontWithName:@"Station" size:22.0f]}];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Station" size:15.0f]} forState:UIControlStateNormal];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBAppEvents activateApp];
    [FBAppCall handleDidBecomeActiveWithSession:[FBSession activeSession]];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[FBSession activeSession] close];
}

- (BOOL)application:(UIApplication *) application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:[FBSession activeSession]];
}

@end
