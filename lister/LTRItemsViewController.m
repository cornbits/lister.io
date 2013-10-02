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
    [super viewDidLoad];
    
    // TestFlight / GAI
    [TestFlight passCheckpoint:@"ITEMS_VIEW"];
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-32232417-4"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"appview", kGAIHitType, @"ITEMS_VIEW", kGAIScreenName, nil];
    [tracker send:params];

    _randomColor = [LTRUtility randomColor];
    self.tableView.backgroundColor = _randomColor;
    
    self.navigationItem.title = _list.listName;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                              target:self action:@selector(addItem:)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self refresh:nil];
}

- (void)refresh:(id)sender {
    [[LTRHTTPClient sharedInstance] getItems:_list.listId onCompletion:^(BOOL success, NSDictionary *json) {
        NSMutableArray *workingItemsArray = [NSMutableArray new];
        NSArray *itemsArray = [json objectForKey:@"items"];

        for (NSDictionary *dict in itemsArray) {
            LTRItem *item = [[LTRItem alloc] initWithData:dict];
            if (item == nil) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else {
                [workingItemsArray addObject:item];
            }
        }

        NSSortDescriptor *scoreSortor = [NSSortDescriptor sortDescriptorWithKey:@"score" ascending:NO];
        NSArray *sortDescriptors = [NSArray arrayWithObject:scoreSortor];
        _items = [workingItemsArray sortedArrayUsingDescriptors:sortDescriptors];
        
        [self.tableView reloadData];
    }];
}

- (void)addItem:(id)sender {
    LTRAddEditItemViewController *addItemViewController = [[LTRAddEditItemViewController alloc] initWithList:_list];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addItemViewController];
	[self presentViewController:navController animated:YES completion:nil];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"actionSheet clicked: %i", buttonIndex);
    switch (buttonIndex) {
        case 0:
        {
            // upvote
            [[LTRHTTPClient sharedInstance] upDownVoteItem:_itemToVote upVote:TRUE onCompletion:^(BOOL success, NSDictionary *json) {
                [self refresh:nil];
            }];
        }
            break;
        case 1:
        {
            // downvote
            [[LTRHTTPClient sharedInstance] upDownVoteItem:_itemToVote upVote:FALSE onCompletion:^(BOOL success, NSDictionary *json) {
                [self refresh:nil];
            }];
        }
            break;
        default:
            break;

    }
}

#pragma mark - UITableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_items count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    LTRItem *item = [_items objectAtIndex:indexPath.row];
    NSString *dateString = [LTRUtility dateAsString:item.createdAt];
    cell.textLabel.text = item.itemText;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"by %@", item.itemUsername];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ by %@", dateString, item.itemUsername];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];

    UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    scoreLabel.textColor = [UIColor whiteColor];
    scoreLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    scoreLabel.text = [NSString stringWithFormat:@"%i", item.score];
    cell.accessoryView = scoreLabel;

    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_items count] > 0) {
        LTRItem *item = [_items objectAtIndex:indexPath.row];
        if ([item.itemUsername isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:@"username"]]) {
            return UITableViewCellEditingStyleDelete;
        }
        return UITableViewCellEditingStyleNone;
    }
    else {
        return UITableViewCellEditingStyleNone;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
                                            forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        LTRItem *item = [_items objectAtIndex:indexPath.row];
        [[LTRHTTPClient sharedInstance] deleteItem:item.itemId onCompletion:^(BOOL success, NSDictionary *json) {
            [self refresh:nil];
        }];
    }
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _itemToVote = [_items objectAtIndex:indexPath.row];
    
    if (![_itemToVote.itemUsername isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:@"username"]]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:_itemToVote.itemText
                                      delegate:self
                                      cancelButtonTitle:@"Cancel"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"Up vote", @"Down vote", nil];
        
        actionSheet.tag = 1;
        [actionSheet showInView:self.view];
    }
}


@end
