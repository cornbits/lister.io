//
//  LTRAddEditItemViewController.m
//  lister
//
//  Created by Geoff Cornwall on 7/31/13.
//  Copyright (c) 2013 Geoff Cornwall. All rights reserved.
//

#import "LTRAddEditItemViewController.h"
#import "LTRHTTPClient.h"
#import "LTRUtility.h"

@interface LTRAddEditItemViewController ()

@end

@implementation LTRAddEditItemViewController

- (id)initWithList:(LTRList *)list {
    self = [super init];
    if (self) {
        _list = list;
        _editMode = FALSE;
    }
    return self;
}

- (id)initForEdit:(LTRItem *)item forList:(LTRList *)list {
	self = [super init];
	if (self) {
        _list = list;
		_editItem = item;
        _editMode = TRUE;
	}
	return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"color"];
    _randomColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    self.view.backgroundColor = _randomColor;

    if (_editMode) {
        self.navigationItem.title = @"Edit Item";
    }
    else {
        self.navigationItem.title = @"Add Item";
    }
    

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
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
    _newItem.autocorrectionType = UITextAutocorrectionTypeNo;
    _newItem.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _newItem.keyboardType = UIKeyboardTypeDefault;
    _newItem.returnKeyType = UIReturnKeyDone;
    _newItem.clearButtonMode = UITextFieldViewModeWhileEditing;
    _newItem.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _newItem.delegate = self;
    [_newItem becomeFirstResponder];
    
    if (_editMode) {
        _newItem.text = _editItem.itemText;
    }
    else {
        _newItem.placeholder = @"add item";
    }

    [self.view addSubview:_newItem];
}

- (void)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addItem:(id)sender {
    [[LTRHTTPClient sharedInstance] addItem:_newItem.text forList:_list onCompletion:^(NSArray *json)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)editItem:(id)sender {
    [[LTRHTTPClient sharedInstance] editItem:_editItem onCompletion:^(NSArray *json) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)done:(id)sender {
    if (_editMode) {
        _editItem.itemText = _newItem.text;
        [self editItem:nil];
    }
    else {
        [self addItem:nil];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self done:nil];
    return YES;
}

@end
