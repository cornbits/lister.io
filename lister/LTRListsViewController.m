//
//  LTRListsViewController.m
//  lister
//
//  Created by Geoff Cornwall on 7/31/13.
//  Copyright (c) 2013 Geoff Cornwall. All rights reserved.
//

#import "LTRListsViewController.h"
#import "LTRItemsViewController.h"
#import "LTRAddEditListViewController.h"
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
    
    UISwipeGestureRecognizer *gestureRight = [[UISwipeGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(editList:)];
    gestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.tableView addGestureRecognizer:gestureRight];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
    [self refresh:nil];
}

- (void)refresh:(id)sender {
    _apiToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"apiToken"];

    if (_apiToken == nil) {
        [self displayLogin];
    }
    else {
        [[LTRHTTPClient sharedInstance] getLists:_apiToken onCompletion:^(NSArray *json) {
            _lists = [NSMutableArray new];
            for (NSDictionary *dict in json) {
                LTRList *list = [[LTRList alloc] initWithData:dict];
                if (list == nil) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An API error occured" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    [self logout:nil];
                }
                else {
                    [_lists addObject:list];
                }
            }
            
            [self.tableView reloadData];
        }];
    }
}

- (void)addList:(id)sender {
    LTRAddEditListViewController *addListViewController = [[LTRAddEditListViewController alloc] init];
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

- (void)editList:(UISwipeGestureRecognizer *)recognizer {
    CGPoint swipeLocation = [recognizer locationInView:self.tableView];
    NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:swipeLocation];
    LTRList *list = [_lists objectAtIndex:swipedIndexPath.row];

    LTRAddEditListViewController *editListViewController = [[LTRAddEditListViewController alloc] initForEdit:list];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:editListViewController];
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

#pragma mark - UITableView data source

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
    
    LTRList *list = [_lists objectAtIndex:indexPath.row];
    cell.textLabel.text = list.listName;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
                                            forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        LTRList *list = [_lists objectAtIndex:indexPath.row];
        [[LTRHTTPClient sharedInstance] deleteList:list.listId onCompletion:^(NSArray *json) {
            [self refresh:nil];
        }];
    }
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LTRList *list = [_lists objectAtIndex:indexPath.row];
    LTRItemsViewController *itemsViewController = [[LTRItemsViewController alloc] initWithList:list];
    [self.navigationController pushViewController:itemsViewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
