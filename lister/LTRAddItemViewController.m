//
//  LTRAddItemViewController.m
//  lister
//
//  Created by Geoff Cornwall on 7/31/13.
//  Copyright (c) 2013 Geoff Cornwall. All rights reserved.
//

#import "LTRAddItemViewController.h"
#import "LTRHTTPClient.h"
#import "LTRUtility.h"

@interface LTRAddItemViewController ()

@end

@implementation LTRAddItemViewController

- (id)initWithListId:(NSString *)listId withListName:(NSString *)listName {
    self = [super init];
    if (self) {
        _listId = listId;
        _listName = listName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"color"];
    _randomColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    self.view.backgroundColor = _randomColor;
    self.navigationItem.title = @"Add Item";
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(addItem:)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = doneButton;
    
    // Set the needed frames
    CGRect newItemFrame;
    if (SYSTEM_VERSION_LESS_THAN(@"7.0") || !IS_IPHONE5) {
        newItemFrame = CGRectMake(20, 65, 280, 50);
    }
    else {
        newItemFrame = CGRectMake(20, 125, 280, 50);
    }

    _newItem = [[UITextField alloc] initWithFrame:newItemFrame];
    _newItem.borderStyle = UITextBorderStyleRoundedRect;
    _newItem.font = [UIFont systemFontOfSize:15];
    _newItem.placeholder = @"add item";
    _newItem.autocorrectionType = UITextAutocorrectionTypeNo;
    _newItem.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _newItem.keyboardType = UIKeyboardTypeDefault;
    _newItem.returnKeyType = UIReturnKeyDone;
    _newItem.clearButtonMode = UITextFieldViewModeWhileEditing;
    _newItem.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _newItem.delegate = self;
    [_newItem becomeFirstResponder];
    [self.view addSubview:_newItem];
}

- (void)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addItem:(id)sender {
    [[LTRHTTPClient sharedInstance] addItem:_newItem.text withListId:_listId
                            withListName:_listName onCompletion:^(NSArray *json)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self addItem:nil];
    return YES;
}

@end
