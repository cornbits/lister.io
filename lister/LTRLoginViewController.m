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
#import "LTRUtility.h"

@interface LTRLoginViewController ()

@end

@implementation LTRLoginViewController


- (void)viewDidLoad {
    [TestFlight passCheckpoint:@"LOGIN_VIEW"];
    [super viewDidLoad];
    
    _randomColor = [LTRUtility randomColor];
    self.view.backgroundColor = _randomColor;
    self.navigationItem.title = @"Login";
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(login:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    // Set the frames
    CGRect usernameLabelFrame = CGRectMake(25, 75, 100, 20);
    CGRect usernameFrame = CGRectMake(20, 100, 280, 50);
    CGRect pwdLabelFrame = CGRectMake(25, 175, 100, 20);
    CGRect pwdFrame = CGRectMake(20, 200, 280, 50);
    
    if (IS_IPHONE5) {
        usernameLabelFrame = CGRectMake(25, 100, 100, 20);
        usernameFrame = CGRectMake(20, 125, 280, 50);
        pwdLabelFrame = CGRectMake(25, 200, 100, 20);
        pwdFrame = CGRectMake(20, 225, 280, 50);
    }

    UILabel *usernameLabel = [[UILabel alloc] initWithFrame:usernameLabelFrame];
    usernameLabel.text = @"Username";
    usernameLabel.textColor = [UIColor whiteColor];
    usernameLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:usernameLabel];
    
    UILabel *pwdLabel = [[UILabel alloc] initWithFrame:pwdLabelFrame];
    pwdLabel.text = @"Password";
    pwdLabel.textColor = [UIColor whiteColor];
    pwdLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:pwdLabel];
    
    _username = [[UITextField alloc] initWithFrame:usernameFrame];
    _username.borderStyle = UITextBorderStyleRoundedRect;
    _username.font = [UIFont systemFontOfSize:13];
    _username.placeholder = @"username";
    _username.autocorrectionType = UITextAutocorrectionTypeNo;
    _username.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _username.keyboardType = UIKeyboardTypeDefault;
    _username.returnKeyType = UIReturnKeyGo;
    _username.clearButtonMode = UITextFieldViewModeWhileEditing;
    _username.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _username.delegate = self;
    [_username becomeFirstResponder];
    [self.view addSubview:_username];
    
    _password = [[UITextField alloc] initWithFrame:pwdFrame];
    _password.borderStyle = UITextBorderStyleRoundedRect;
    _password.font = [UIFont systemFontOfSize:13];
    _password.placeholder = @"password";
    _password.autocorrectionType = UITextAutocorrectionTypeNo;
    _password.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _password.keyboardType = UIKeyboardTypeDefault;
    _password.returnKeyType = UIReturnKeyGo;
    _password.clearButtonMode = UITextFieldViewModeWhileEditing;
    _password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _password.secureTextEntry = TRUE;
    _password.delegate = self;
    [_password becomeFirstResponder];
    [self.view addSubview:_password];
}

- (void)login:(id)sender {
    [self presentHUD];
    
    [[LTRHTTPClient sharedInstance] userLogin:_username.text withPassword:_password.text onCompletion:^(BOOL success, NSDictionary *json) {
        NSLog(@"Login results = %@", json);

        
        if (success) {
            [self dismissHUDWithText:@"Succesful" withDelay:2 withImage:@"checkmark.png"];
            
            [[NSUserDefaults standardUserDefaults] setValue:_username.text forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] setValue:_password.text forKey:@"password"];
            [[NSUserDefaults standardUserDefaults] setValue:[json objectForKey:@"userId"] forKey:@"userId"];
            [[NSUserDefaults standardUserDefaults] setValue:[json objectForKey:@"loginToken"] forKey:@"apiToken"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            [self dismissHUDWithText:@"Login error" withDelay:2 withImage:@"x-mark.png"];
        }
    }];
}

- (void)loginWebView:(id)sender {
    LTRLoginWebViewController *webViewController = [[LTRLoginWebViewController alloc] init];
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)presentHUD {
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    _hud.bounds = CGRectMake(_hud.bounds.origin.x, (_hud.bounds.origin.y + 110), _hud.bounds.size.width, _hud.bounds.size.height);
    _hud.labelText = @"Loading...";
    [self.view addSubview:_hud];
    [_hud show:YES];
}

- (void)dismissHUDWithText:(NSString *)text withDelay:(NSTimeInterval)delay withImage:(NSString *)image {
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
    _hud.labelText = text;
    _hud.dimBackground = TRUE;
    [_hud hide:YES afterDelay:delay];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self login:nil];
    return YES;
}

@end
