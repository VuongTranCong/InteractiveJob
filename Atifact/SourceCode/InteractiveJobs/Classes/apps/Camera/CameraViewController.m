//
//  CameraViewController.m
//  VuforiaSamples
//
//  Created by VuongTC on 6/29/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import "CameraViewController.h"
#import "AppController.h"
#import "JobsViewController.h"
#import "LoginViewController.h"
#import "NetworkController.h"

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[AppController getInstance] setCameraViewController:self];
    
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    if ([FBSDKAccessToken currentAccessToken] || [[AppController getInstance] isLoggedByLinkedIn]) {
        [self startRegconizedImage];
    } else {
        [self showLoginView];
    }
}

- (void) showLoginView {
    LoginViewController* loginView = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:loginView animated:YES];
}

- (void) doneRegconizedImage {
    [slidingMenuController dismissViewControllerAnimated:YES completion:nil];
    
    JobsViewController* jobsView = [[JobsViewController alloc] initWithNibName:@"JobsViewController" bundle:nil];
    [self.navigationController pushViewController:jobsView animated:YES];
    
    [self showInterstitialAds];
}

- (void) startRegconizedImage {
    Class vcClass = NSClassFromString(@"ImageTargetsViewController");
    UIViewController* vc = [[vcClass alloc]  initWithNibName:nil bundle:nil];

    slidingMenuController = [[MenuSlidingViewController alloc] initWithRootViewController:vc];
    [self presentViewController:slidingMenuController animated:YES completion:nil];
}

@end
