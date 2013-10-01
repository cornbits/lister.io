//
//  LTRAppDelegate.m
//  lister
//
//  Created by Geoff Cornwall on 7/31/13.
//  Copyright (c) 2013 Geoff Cornwall. All rights reserved.
//

#import "LTRAppDelegate.h"
#import "LTRListsViewController.h"

@implementation LTRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // TestFlight integration
    //[TestFlight takeOff:@"73ed7ed8-c4f4-4433-9c33-1d4c980ddbc4"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    LTRListsViewController *listsViewController = [[LTRListsViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:listsViewController];
	self.window.rootViewController = navigationController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
