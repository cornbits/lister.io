//
//  LTRAddItemViewController.h
//  lister
//
//  Created by Geoff Cornwall on 7/31/13.
//  Copyright (c) 2013 Geoff Cornwall. All rights reserved.
//

@interface LTRAddItemViewController : UIViewController <UITextFieldDelegate> {
    UITextField *_newItem;
    UIColor *_randomColor;
}

@property (nonatomic) NSString *listId;
@property (nonatomic) NSString *listName;

- (id)initWithListId:(NSString *)listId withListName:(NSString *)listName;

@end
