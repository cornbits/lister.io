//
//  LTRAddEditItemViewController.h
//  lister
//
//  Created by Geoff Cornwall on 7/31/13.
//  Copyright (c) 2013 Geoff Cornwall. All rights reserved.
//

#import "LTRList.h"
#import "LTRItem.h"

@interface LTRAddEditItemViewController : UIViewController <UITextFieldDelegate> {
    UITextField *_newItem;
    UIColor *_randomColor;
    LTRItem *_editItem;
    BOOL _editMode;
}

@property (nonatomic) LTRList *list;

- (id)initWithList:(LTRList *)list;
- (id)initForEdit:(LTRItem *)item forList:(LTRList *)list;

@end
