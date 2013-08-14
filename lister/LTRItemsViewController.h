//
//  LTRItemsViewController.h
//  lister
//
//  Created by Geoff Cornwall on 7/31/13.
//  Copyright (c) 2013 Geoff Cornwall. All rights reserved.
//

#import "LTRList.h"

@interface LTRItemsViewController : UITableViewController {
    LTRList *_list;
    NSMutableArray *_allItems;
    NSMutableArray *_filteredItems;
    UIColor *_randomColor;
}

- (id)initWithList:(LTRList *)list;

@end
