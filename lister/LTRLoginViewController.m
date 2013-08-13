//
//  LTRLoginViewController.m
//  lister
//
//  Created by Geoff Cornwall on 7/31/13.
//  Copyright (c) 2013 Geoff Cornwall. All rights reserved.
//

#import "LTRLoginViewController.h"
#import "LTRHTTPClient.h"

@interface LTRLoginViewController ()

@end

@implementation LTRLoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"color"];
    _randomColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    self.view.backgroundColor = _randomColor;
    self.navigationItem.title = @"Login";
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(login:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    // Set the frames
    CGRect labelFrame;
    CGRect apiTokenFrame;

    if (SYSTEM_VERSION_LESS_THAN(@"7.0") || !IS_IPHONE5) {
        labelFrame = CGRectMake(25, 60, 100, 20);
        apiTokenFrame = CGRectMake(20, 85, 280, 50);
    }
    else {
        labelFrame = CGRectMake(25, 125, 100, 20);
        apiTokenFrame = CGRectMake(20, 150, 280, 50);
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.text = @"API Token";
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label];
    
    _apiToken = [[UITextField alloc] initWithFrame:apiTokenFrame];
    _apiToken.borderStyle = UITextBorderStyleRoundedRect;
    _apiToken.font = [UIFont systemFontOfSize:15];
    _apiToken.placeholder = @"api token";
    _apiToken.autocorrectionType = UITextAutocorrectionTypeNo;
    _apiToken.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _apiToken.keyboardType = UIKeyboardTypeDefault;
    _apiToken.returnKeyType = UIReturnKeyGo;
    _apiToken.clearButtonMode = UITextFieldViewModeWhileEditing;
    _apiToken.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _apiToken.delegate = self;
    [_apiToken becomeFirstResponder];
    [self.view addSubview:_apiToken];
}

- (void)login:(id)sender {
    // TODO: replace with actual login endpoint once it exists
    [[LTRHTTPClient sharedInstance] getLists:_apiToken.text onCompletion:^(NSArray *json) {
        NSLog(@"Login results = %@", json);
        
        if ([json count] > 0) {
            NSDictionary *listDict = [json objectAtIndex:0];
            [[NSUserDefaults standardUserDefaults] setValue:[listDict objectForKey:@"username"] forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] setValue:[listDict objectForKey:@"userId"] forKey:@"userId"];
            [[NSUserDefaults standardUserDefaults] setValue:_apiToken.text forKey:@"apiToken"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSLog(@"username = %@; userId = %@; apiToken = %@", [listDict objectForKey:@"username"],
                  [listDict objectForKey:@"userId"], _apiToken.text);

            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your API Token is no longer valid, or you do not have at least 1 list on Lister.io" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self login:nil];
    return YES;
}

@end
