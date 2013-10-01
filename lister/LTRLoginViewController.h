//
//  LTRLoginViewController.h
//  lister
//
//  Created by Geoff Cornwall on 7/31/13.
//  Copyright (c) 2013 Geoff Cornwall. All rights reserved.
//

#import "MBProgressHUD.h"

@interface LTRLoginViewController : UIViewController <UITextFieldDelegate> {
    UITextField *_username;
    UITextField *_password;
    UIColor *_randomColor;
    MBProgressHUD *_hud;
}

@end
