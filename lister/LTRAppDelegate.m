//
//  LTRAppDelegate.m
//  lister
//
//  Created by Geoff Cornwall on 7/31/13.
//  Copyright (c) 2013 Geoff Cornwall. All rights reserved.
//

#import "LTRAppDelegate.h"
#import "LTRListsViewController.h"
#import <Crashlytics/Crashlytics.h>

@implementation LTRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // TestFlight and Crashlytics integration
    [TestFlight takeOff:@"73ed7ed8-c4f4-4433-9c33-1d4c980ddbc4"];
    [Crashlytics startWithAPIKey:@"c5a1a833f477c2c1bc556289437cee0418ada93d"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    LTRListsViewController *listsViewController = [[LTRListsViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:listsViewController];
	self.window.rootViewController = navigationController;

    //Set the navbar if not iOS7
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        navigationController.navigationBar.tintColor = [UIColor lightGrayColor];
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
