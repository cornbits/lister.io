//
//  LTRItemsViewController.h
//  lister
//
//  Created by Geoff Cornwall on 7/31/13.
//  Copyright (c) 2013 Geoff Cornwall. All rights reserved.
//

@interface LTRItemsViewController : UITableViewController {
    NSMutableArray *_allItems;
    NSMutableArray *_filteredItems;
    UIColor *_randomColor;
}

@property (nonatomic) NSString *listID;
@property (nonatomic) NSString *listName;

- (id)initWithListId:(NSString *)listID;

@end
