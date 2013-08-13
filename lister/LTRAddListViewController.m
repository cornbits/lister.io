//
//  LTRAddListViewController.m
//  lister
//
//  Created by Geoff Cornwall on 7/31/13.
//  Copyright (c) 2013 Geoff Cornwall. All rights reserved.
//

#import "LTRAddListViewController.h"
#import "LTRHTTPClient.h"
#import "LTRUtility.h"

@interface LTRAddListViewController ()

@end

@implementation LTRAddListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"color"];
    _randomColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    self.view.backgroundColor = _randomColor;
    self.navigationItem.title = @"Add List";
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(addItem:)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = doneButton;
    
    // Set the needed frames
    CGRect newListFrame;
    CGRect labelFrame;
    CGRect switchFrame;
    if (SYSTEM_VERSION_LESS_THAN(@"7.0") || !IS_IPHONE5) {
        newListFrame = CGRectMake(20, 65, 280, 50);
        labelFrame = CGRectMake(50, 135, 150, 30);
        switchFrame = CGRectMake(210, 135, 50, 30);
    }
    else {
        newListFrame = CGRectMake(20, 125, 280, 50);
        labelFrame = CGRectMake(50, 200, 150, 30);
        switchFrame = CGRectMake(210, 200, 50, 30);
    }

    _newList = [[UITextField alloc] initWithFrame:newListFrame];
    _newList.borderStyle = UITextBorderStyleRoundedRect;
    _newList.font = [UIFont systemFontOfSize:15];
    _newList.placeholder = @"new list";
    _newList.autocorrectionType = UITextAutocorrectionTypeNo;
    _newList.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _newList.keyboardType = UIKeyboardTypeDefault;
    _newList.returnKeyType = UIReturnKeyDone;
    _newList.clearButtonMode = UITextFieldViewModeWhileEditing;
    _newList.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _newList.delegate = self;
    [_newList becomeFirstResponder];
    [self.view addSubview:_newList];
    
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
    label.text = @"Allow anyone to add to it?";
    [self.view addSubview:label];
    
    _switch = [[UISwitch alloc] initWithFrame:switchFrame];
    [self.view addSubview:_switch];
}

- (void)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addItem:(id)sender {
    [[LTRHTTPClient sharedInstance] addList:_newList.text isOpen:_switch.isOn onCompletion:^(NSArray *json) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self addItem:nil];
    return YES;
}

@end
