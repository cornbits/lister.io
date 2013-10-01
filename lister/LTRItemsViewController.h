//
//  LTRItemsViewController.h
//  lister
//
//  Created by Geoff Cornwall on 7/31/13.
//  Copyright (c) 2013 Geoff Cornwall. All rights reserved.
//

#import "LTRList.h"
#import "LTRItem.h"

@interface LTRItemsViewController : UITableViewController <UIActionSheetDelegate> {
    LTRItem *_itemToVote;
    LTRList *_list;
    NSArray *_items;
    UIColor *_randomColor;
}

- (id)initWithList:(LTRList *)list;

@end
