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

    // TestFlight / GAI
    [TestFlight passCheckpoint:@"ADD_ITEMS"];
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-32232417-4"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"appview", kGAIHitType, @"ADD_ITEMS", kGAIScreenName, nil];
    [tracker send:params];

    _randomColor = [LTRUtility randomColor];
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
    CGRect newItemURLFrame;
    
    if (!IS_IPHONE5) {
        newItemFrame = CGRectMake(20, 100, 280, 50);
        newItemURLFrame = CGRectMake(20, 175, 280, 50);
    }
    else {
        newItemFrame = CGRectMake(20, 125, 280, 50);
        newItemURLFrame = CGRectMake(20, 200, 280, 50);
    }

    // new item text
    _newItem = [[UITextField alloc] initWithFrame:newItemFrame];
    _newItem.borderStyle = UITextBorderStyleRoundedRect;
    _newItem.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
    _newItem.autocorrectionType = UITextAutocorrectionTypeNo;
    _newItem.autocapitalizationType = UITextAutocapitalizationTypeSentences;
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
        _newItem.placeholder = @"text";
    }
    [self.view addSubview:_newItem];
    
    // new item URL
    _newItemURL = [[UITextField alloc] initWithFrame:newItemURLFrame];
    _newItemURL.borderStyle = UITextBorderStyleRoundedRect;
    _newItemURL.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
    _newItemURL.autocorrectionType = UITextAutocorrectionTypeNo;
    _newItemURL.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    _newItemURL.keyboardType = UIKeyboardTypeDefault;
    _newItemURL.returnKeyType = UIReturnKeyDone;
    _newItemURL.clearButtonMode = UITextFieldViewModeWhileEditing;
    _newItemURL.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _newItemURL.placeholder = @"url (optional)";
    _newItemURL.delegate = self;
    [self.view addSubview:_newItemURL];
}

- (void)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addItem:(id)sender {
    NSLog(@"_newItemURL = %@", _newItemURL);
    
    [[LTRHTTPClient sharedInstance] addItem:_newItem.text withURL:_newItemURL.text forList:_list
                               onCompletion:^(BOOL success, NSDictionary *json) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)editItem:(id)sender {
    [[LTRHTTPClient sharedInstance] editItem:_editItem onCompletion:^(BOOL success, NSDictionary *json) {
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
