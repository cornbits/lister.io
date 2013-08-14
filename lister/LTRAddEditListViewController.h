//
//  LTRAddEditListViewController.h
//  lister
//
//  Created by Geoff Cornwall on 7/31/13.
//  Copyright (c) 2013 Geoff Cornwall. All rights reserved.
//

#import "LTRList.h"

@interface LTRAddEditListViewController : UIViewController <UITextFieldDelegate> {
    UITextField *_newList;
    UISwitch *_switch;
    UIColor *_randomColor;
    LTRList *_editList;
    BOOL _editMode;
}

- (id)initForEdit:(LTRList *)list;

@end
