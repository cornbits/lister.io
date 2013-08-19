//
//  LTRLoginWebViewController.m
//  lister
//
//  Created by Geoff Cornwall on 8/16/13.
//  Copyright (c) 2013 Geoff Cornwall. All rights reserved.
//

#import "LTRLoginWebViewController.h"

@interface LTRLoginWebViewController ()

@end

@implementation LTRLoginWebViewController

- (void) viewWillAppear:(BOOL)animated {
    [TestFlight passCheckpoint:@"WEBLOGIN"];
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"Lister.io";
    NSURL *url = [NSURL URLWithString:@"http://lister.io/api"];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    [_webView loadRequest:requestObj];
    [_webView setScalesPageToFit:YES];
    _webView.delegate = self;
    [self.view addSubview:_webView];
}

@end
