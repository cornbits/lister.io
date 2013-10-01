//
//  LTRSettingsViewController.h
//  lister
//
//  Created by Geoff Cornwall on 10/1/13.
//  Copyright (c) 2013 Geoff Cornwall. All rights reserved.
//

@interface LTRSettingsViewController : UITableViewController {
    id _delegate;
}

@property (nonatomic, retain) NSArray *dataSourceArray;

- (id)initWithDelegate:(id)delegate;

@end


@protocol SettingsDelegate <NSObject>
- (void)logout:(id)sender;
@end