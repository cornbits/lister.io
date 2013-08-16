//
//  LTRLoginViewController.m
//  lister
//
//  Created by Geoff Cornwall on 7/31/13.
//  Copyright (c) 2013 Geoff Cornwall. All rights reserved.
//

#import "LTRLoginViewController.h"
#import "LTRLoginWebViewController.h"
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
    CGRect loginButtonFrame;

    if (SYSTEM_VERSION_LESS_THAN(@"7.0") || !IS_IPHONE5) {
        labelFrame = CGRectMake(25, 60, 100, 20);
        apiTokenFrame = CGRectMake(20, 85, 280, 50);
        loginButtonFrame = CGRectMake(60, 150, 200, 25);
    }
    else {
        labelFrame = CGRectMake(25, 125, 100, 20);
        apiTokenFrame = CGRectMake(20, 150, 280, 50);
        loginButtonFrame = CGRectMake(60, 220, 200, 25);
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.text = @"API Key";
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label];
    
    _apiToken = [[UITextField alloc] initWithFrame:apiTokenFrame];
    _apiToken.borderStyle = UITextBorderStyleRoundedRect;
    _apiToken.font = [UIFont systemFontOfSize:13];
    _apiToken.placeholder = @"api key";
    _apiToken.autocorrectionType = UITextAutocorrectionTypeNo;
    _apiToken.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _apiToken.keyboardType = UIKeyboardTypeDefault;
    _apiToken.returnKeyType = UIReturnKeyGo;
    _apiToken.clearButtonMode = UITextFieldViewModeWhileEditing;
    _apiToken.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _apiToken.delegate = self;
    [_apiToken becomeFirstResponder];
    [self.view addSubview:_apiToken];
    
    _loginButton = [[UIButton alloc] initWithFrame:loginButtonFrame];
    [_loginButton addTarget:self action:@selector(loginWebView:) forControlEvents:UIControlEventTouchUpInside];
    [_loginButton setTitle:@"I don't know my API key" forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _loginButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    _loginButton.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_loginButton];
}

- (void)login:(id)sender {
    // TODO: replace with actual login endpoint once it exists
    [[LTRHTTPClient sharedInstance] getLists:_apiToken.text onCompletion:^(NSArray *json) {
        NSLog(@"Login results = %@", json);
        
        // quick hacky check for login error
        if ([[json objectAtIndex:0] isKindOfClass:[NSString class]] &&
            [[json objectAtIndex:0] rangeOfString:@"Expected status code"].location != NSNotFound) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Error" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else if ([json count] > 0) {
            NSDictionary *listDict = [json objectAtIndex:0];
            [[NSUserDefaults standardUserDefaults] setValue:[listDict objectForKey:@"username"] forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] setValue:[listDict objectForKey:@"userId"] forKey:@"userId"];
            [[NSUserDefaults standardUserDefaults] setValue:_apiToken.text forKey:@"apiToken"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your API Token is no longer valid, or you do not have at least 1 list on Lister.io" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (void)loginWebView:(id)sender {
    LTRLoginWebViewController *webViewController = [[LTRLoginWebViewController alloc] init];
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self login:nil];
    return YES;
}

@end
