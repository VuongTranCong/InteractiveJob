//
//  JobDetailViewController.m
//  VuforiaSamples
//
//  Created by VuongTC on 6/30/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import "JobDetailViewController.h"

@interface JobDetailViewController ()

@end

@implementation JobDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:job.urlDetail]]];
    titleLabel.text = job.title;
    [self showLoading:YES];
}

- (void) setJob:(Job *)data {
    job = data;
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
    [self showLoading:NO];
}

@end
