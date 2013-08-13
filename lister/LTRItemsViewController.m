//
//  LTRItemsViewController.m
//  lister
//
//  Created by Geoff Cornwall on 7/31/13.
//  Copyright (c) 2013 Geoff Cornwall. All rights reserved.
//

#import "LTRItemsViewController.h"
#import "LTRAddItemViewController.h"
#import "LTRHTTPClient.h"
#import "LTRUtility.h"

@interface LTRItemsViewController ()

@end

@implementation LTRItemsViewController

- (id)initWithListId:(NSString *)listID {
    self = [super init];
    if (self) {
        _listID = listID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"color"];
    _randomColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    self.tableView.backgroundColor = _randomColor;
    
    self.navigationItem.title = _listName;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                              target:self action:@selector(addItem:)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self refresh:nil];
}

- (void)refresh:(id)sender {
    [[LTRHTTPClient sharedInstance] getItems:_listID onCompletion:^(NSArray *json) {
        _allItems = [[NSMutableArray alloc] initWithArray:json];
        _filteredItems = [NSMutableArray new];
        
        for (NSDictionary *itemDict in _allItems) {
            NSString *evalListID = [itemDict objectForKey:@"listId"];
            if ([_listID isEqualToString:evalListID]) {
                [_filteredItems addObject:itemDict];
            }
        }
        
        [self.tableView reloadData];
    }];
}

- (void)addItem:(id)sender {
    LTRAddItemViewController *addItemViewController = [[LTRAddItemViewController alloc] initWithListId:_listID withListName:_listName];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addItemViewController];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        navController.navigationBar.tintColor = [UIColor lightGrayColor];
    }
	[self presentViewController:navController animated:YES completion:nil];
}

#pragma mark - Table view data source

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
    
    NSDictionary *listDict = [_filteredItems objectAtIndex:indexPath.row];
    cell.textLabel.text = [listDict objectForKey:@"text"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];

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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *listDict = [_filteredItems objectAtIndex:indexPath.row];
        NSString *itemId = [listDict objectForKey:@"_id"];
        [[LTRHTTPClient sharedInstance] deleteItem:itemId onCompletion:^(NSArray *json) {
            [self refresh:nil];
        }];
    }
}

@end
