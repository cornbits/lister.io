//
//  LTRCreditsViewController.m
//  lister
//
//  Created by Geoff Cornwall on 10/1/13.
//  Copyright (c) 2013 Geoff Cornwall. All rights reserved.
//

#import "LTRCreditsViewController.h"

@interface LTRCreditsViewController ()

@end

@implementation LTRCreditsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // TestFlight / GAI
    [TestFlight passCheckpoint:@"CREDITS_VIEW"];
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-32232417-4"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"appview", kGAIHitType, @"CREDITS_VIEW", kGAIScreenName, nil];
    [tracker send:params];

    self.navigationController.navigationBarHidden = TRUE;
    self.view.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1.0];

    // app icon image
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(110, 100, 100, 100)];
    [iconImageView setImage:[UIImage imageNamed:@"icon_RR.png"]];
    [self.view addSubview:iconImageView];

    
    // lister.io title
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 210, 320, 40)];
    NSDictionary *titleAttr = @{ NSFontAttributeName : [UIFont fontWithName:@"AvenirNext-Regular" size:35],
                                 NSForegroundColorAttributeName : [UIColor purpleColor]};
    NSAttributedString *titleAttrStr = [[NSAttributedString alloc] initWithString:@"Lister.io" attributes:titleAttr];
    [titleLabel setAttributedText:titleAttrStr];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];


    NSDictionary *creditAttrBold = @{ NSFontAttributeName : [UIFont fontWithName:@"AvenirNext-DemiBold" size:15],
                                  NSForegroundColorAttributeName : [UIColor blackColor]};
    NSDictionary *creditAttr = @{ NSFontAttributeName : [UIFont fontWithName:@"AvenirNext-Regular" size:15],
                                  NSForegroundColorAttributeName : [UIColor blackColor]};


    // powered by
    NSMutableAttributedString *powerAttrStr = [[NSMutableAttributedString alloc]
                                                initWithString:@"powered by " attributes:creditAttrBold];
    [powerAttrStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"differential.io" attributes:creditAttr]];
    UILabel *powerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 250, 320, 20)];
    [powerLabel setAttributedText:powerAttrStr];
    powerLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:powerLabel];

    // developed by
    NSMutableAttributedString *creditAttrStr = [[NSMutableAttributedString alloc]
                                                initWithString:@"developed by " attributes:creditAttrBold];
    [creditAttrStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"cornbits" attributes:creditAttr]];
    UILabel *creditLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 320, 320, 20)];
    [creditLabel setAttributedText:creditAttrStr];
    creditLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:creditLabel];

    // build number
    NSMutableAttributedString *buildAttrStr = [[NSMutableAttributedString alloc]
                                                initWithString:@"build " attributes:creditAttr];
    [buildAttrStr appendAttributedString:[[NSAttributedString alloc]
                                          initWithString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
                                          attributes:creditAttr]];
    [buildAttrStr appendAttributedString:[[NSAttributedString alloc] initWithString:@" (" attributes:creditAttr]];
    [buildAttrStr appendAttributedString:[[NSAttributedString alloc]
                                          initWithString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
                                          attributes:creditAttr]];
    [buildAttrStr appendAttributedString:[[NSAttributedString alloc] initWithString:@")" attributes:creditAttr]];
    UILabel *buildLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 340, 320, 20)];
    [buildLabel setAttributedText:buildAttrStr];
    buildLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:buildLabel];
    
    // dismiss gesture
    UITapGestureRecognizer *tapDone = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(done:)];
    tapDone.numberOfTapsRequired = 1;
    self.view.userInteractionEnabled = TRUE;
    [self.view addGestureRecognizer:tapDone];
}

- (void)done:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = FALSE;
}

@end
