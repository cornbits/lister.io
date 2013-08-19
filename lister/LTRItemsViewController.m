//
//  LTRItemsViewController.m
//  lister
//
//  Created by Geoff Cornwall on 7/31/13.
//  Copyright (c) 2013 Geoff Cornwall. All rights reserved.
//

#import "LTRItemsViewController.h"
#import "LTRAddEditItemViewController.h"
#import "LTRHTTPClient.h"
#import "LTRUtility.h"

@interface LTRItemsViewController ()

@end

@implementation LTRItemsViewController

- (id)initWithList:(LTRList *)list {
    self = [super init];
    if (self) {
        _list = list;
    }
    return self;
}

- (void)viewDidLoad {
    [TestFlight passCheckpoint:@"ITEMS_VIEW"];
    [super viewDidLoad];
    
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"color"];
    _randomColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    self.tableView.backgroundColor = _randomColor;
    
    self.navigationItem.title = _list.listName;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                              target:self action:@selector(addItem:)];

    UISwipeGestureRecognizer *gestureRight = [[UISwipeGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(editItem:)];
    gestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.tableView addGestureRecognizer:gestureRight];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self refresh:nil];
}

- (void)refresh:(id)sender {
    [[LTRHTTPClient sharedInstance] getItems:_list.listId onCompletion:^(NSArray *json) {
        _allItems = [NSMutableArray new];
        _filteredItems = [NSMutableArray new];

        for (NSDictionary *dict in json) {
            LTRItem *item = [[LTRItem alloc] initWithData:dict];
            if (item == nil) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else {
                [_allItems addObject:item];
            
                if ([_list.listId isEqualToString:item.listId]) {
                    [_filteredItems addObject:item];
                }
            }
        }

        [self.tableView reloadData];
    }];
}

- (void)addItem:(id)sender {
    LTRAddEditItemViewController *addItemViewController = [[LTRAddEditItemViewController alloc] initWithList:_list];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addItemViewController];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        navController.navigationBar.tintColor = [UIColor lightGrayColor];
    }
	[self presentViewController:navController animated:YES completion:nil];
}

- (void)editItem:(UISwipeGestureRecognizer *)recognizer {
    CGPoint swipeLocation = [recognizer locationInView:self.tableView];
    NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:swipeLocation];
    LTRItem *item = [_filteredItems objectAtIndex:swipedIndexPath.row];
    
    LTRAddEditItemViewController *editItemViewController = [[LTRAddEditItemViewController alloc] initForEdit:item
                                                                                                     forList:_list];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:editItemViewController];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        navController.navigationBar.tintColor = [UIColor lightGrayColor];
    }
	[self presentViewController:navController animated:YES completion:nil];
}

#pragma mark - UITableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_filteredItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    LTRItem *item = [_filteredItems objectAtIndex:indexPath.row];
    cell.textLabel.text = item.itemText;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    
    if (item.score > 0) {
        UIImageView *heartImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"heart.png"]];
        cell.accessoryView = heartImgView;
    }

    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_filteredItems count] > 0) {
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
        LTRItem *item = [_filteredItems objectAtIndex:indexPath.row];
        [[LTRHTTPClient sharedInstance] deleteItem:item.itemId onCompletion:^(NSArray *json) {
            [self refresh:nil];
        }];
    }
}

@end
