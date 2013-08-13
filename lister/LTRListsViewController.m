//
//  LTRListsViewController.m
//  lister
//
//  Created by Geoff Cornwall on 7/31/13.
//  Copyright (c) 2013 Geoff Cornwall. All rights reserved.
//

#import "LTRListsViewController.h"
#import "LTRItemsViewController.h"
#import "LTRAddListViewController.h"
#import "LTRLoginViewController.h"
#import "LTRHTTPClient.h"
#import "LTRUtility.h"

@interface LTRListsViewController ()

@end

@implementation LTRListsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    self.navigationItem.title = @"My Lists";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                              target:self action:@selector(addList:)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@"Logout" style:UIBarButtonSystemItemAction
                                             target:self action:@selector(logout:)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _apiToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"apiToken"];
    [self refresh:nil];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)appDidBecomeActive:(NSNotification *)notification {
    _randomColor = [LTRUtility randomColor];
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:_randomColor];
    [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:@"color"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.tableView.backgroundColor = _randomColor;
}

- (void)refresh:(id)sender {
    if (_apiToken == nil) {
        [self displayLogin];
    }
    else {
        [[LTRHTTPClient sharedInstance] getLists:_apiToken onCompletion:^(NSArray *json) {
            _lists = [[NSMutableArray alloc] initWithArray:json];
            [self.tableView reloadData];
        }];
    }
}

- (void)addList:(id)sender {
    LTRAddListViewController *addListViewController = [[LTRAddListViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addListViewController];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        navController.navigationBar.tintColor = [UIColor lightGrayColor];
    }
	[self presentViewController:navController animated:YES completion:nil];
}

- (void)displayLogin {
    LTRLoginViewController *loginViewController = [[LTRLoginViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        navController.navigationBar.tintColor = [UIColor lightGrayColor];
    }
	[self presentViewController:navController animated:YES completion:nil];
}

- (void)logout:(id)sender {
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"userId"];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"apiToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _apiToken = nil;
    
    [self refresh:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_lists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *listDict = [_lists objectAtIndex:indexPath.row];
    cell.textLabel.text = [listDict objectForKey:@"name"];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_lists count] > 0) {
        return UITableViewCellEditingStyleDelete;
    }
    else {
        return UITableViewCellEditingStyleNone;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Call delete
        NSDictionary *listDict = [_lists objectAtIndex:indexPath.row];
        NSString *listId = [listDict objectForKey:@"_id"];
        [[LTRHTTPClient sharedInstance] deleteList:listId onCompletion:^(NSArray *json) {
            [self refresh:nil];
        }];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *listDict = [_lists objectAtIndex:indexPath.row];
    LTRItemsViewController *itemsViewController = [[LTRItemsViewController alloc] initWithListId:[listDict objectForKey:@"_id"]];
    itemsViewController.listName = [listDict objectForKey:@"name"];
    [self.navigationController pushViewController:itemsViewController animated:YES];
}

@end
