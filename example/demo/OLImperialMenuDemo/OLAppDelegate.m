//
// OLAppDelegate.m
// OLImperialMenuDemo
//
// Created by Pay Liu on 13/10/16.
// Copyright (c) 2013年 Octalord Information Inc. All rights reserved.
//

#import "OLAppDelegate.h"

/* logger system */
#import <CocoaLumberjack/DDTTYLogger.h>
#import <OLCustomCocoaLumberjack/OLDDFormatter.h>
#import <NSLogger-CocoaLumberjack-connector/DDNSLoggerLogger.h>
#import <NSLogger/LoggerClient.h>

@implementation OLAppDelegate

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupLoggerSystem];

    // Override point for customization after application launch.
    return YES;
}

- (void) applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void) applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void) applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void) applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void) applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Logger System

/*
 * setup logger system,
 *    1. Lumberjack
 *    2. NSLogger
 *    3. NSLogger-CocoaLumberjack-connector
 *    4. custom formatter, PSDDForamtter
 *    5. XcodeColors
 *        setup :Edit Schema > Run {Project} > Arguments > add an environment variable, arg: NSLOGGER_BONJOUR_NAME
 *
 */
- (void) setupLoggerSystem
{
    [DDLog addLogger:[DDTTYLogger sharedInstance]]; // Lumberjack

    OLDDFormatter *psLogger = [[OLDDFormatter alloc] init]; // custom format

    [[DDTTYLogger sharedInstance] setLogFormatter:psLogger];

#ifdef DEBUG

    Boolean colorsEnabled = NO;

    char *xcodeColors = getenv("XcodeColors");

    if (xcodeColors != nil && strcmp(xcodeColors, "YES") == 0) {

        colorsEnabled = YES;
    }

    DDLogVerbose(@"colorsEnabled: %@", NSStringFromBOOL(colorsEnabled));

    [[DDTTYLogger sharedInstance] setColorsEnabled:colorsEnabled]; // XcodeColors plugins

    [DDLog addLogger:[DDNSLoggerLogger sharedInstance]]; // connect to NSLogger

    /* Edit Schema > Run {Project} > Arguments > add an environment variable
     * arg: NSLOGGER_BONJOUR_NAME
     * value: your bonjor name for NSLogger.app
     */
    char *bonjorName = getenv("NSLOGGER_BONJOUR_NAME");

    DDLogVerbose(@"bonjorName: %s", bonjorName);

    if (bonjorName != nil) {
        LoggerSetupBonjour(NULL, NULL, (__bridge CFStringRef)[NSString stringWithUTF8String:bonjorName]);  // for your NSLogger.app
    } else {
        LoggerSetupBonjour(NULL, NULL, (__bridge CFStringRef)[NSString stringWithUTF8String:"public"]);  // for your NSLogger.app
    }

#endif
}

@end
