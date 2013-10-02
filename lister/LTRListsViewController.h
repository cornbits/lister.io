//
//  LTRListsViewController.h
//  lister
//
//  Created by Geoff Cornwall on 7/31/13.
//  Copyright (c) 2013 Geoff Cornwall. All rights reserved.
//

#import "LTRList.h"
#import "LTRSettingsViewController.h"

@interface LTRListsViewController : UITableViewController <SettingsDelegate, UISearchBarDelegate, UISearchDisplayDelegate> {
    NSString *_apiToken;
    NSString *_userId;
    NSString *_username;
    NSArray *_lists;
    NSMutableArray *_filteredLists;
    UIColor *_randomColor;
    UISegmentedControl *_listSegControl;
    BOOL isSearching;
    UISearchBar *searchBar;
    UISearchDisplayController *searchDisplayController;
}

@end
