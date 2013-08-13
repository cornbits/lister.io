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
