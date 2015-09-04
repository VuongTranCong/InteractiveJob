//
//  TopParentViewController.m
//  VuforiaSamples
//
//  Created by VuongTC on 6/30/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import "TopParentViewController.h"
#import "GMDCircleLoader.h"

@interface TopParentViewController ()

@end

@implementation TopParentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isSpining = NO;
    
    NSLog(@"Google Mobile Ads SDK version: %@", [GADRequest sdkVersion]);
    
    bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    bannerView.adUnitID = @"ca-app-pub-5973128916042439/7297808709";
    bannerView.rootViewController = self;
    bannerView.delegate = self;
//    [bannerView loadRequest:[GADRequest request]];
    [self.bannerViewHolder addSubview:bannerView];
    
//    interstitialAds = [self createAndLoadInterstitial];
}

- (void) showInterstitialAds {
    if ([interstitialAds isReady]) {
        [interstitialAds presentFromRootViewController:self];
    }
}

- (void) showLoading:(BOOL)isShow {    
    if (isSpining) {
        [GMDCircleLoader hideFromView:self.view animated:YES];
    }
    
    if (isShow) {
        [GMDCircleLoader setOnView:self.view withTitle:@"Loading..." animated:YES];
        isSpining = YES;
    }
    
    if (!isShow) {
        [GMDCircleLoader hideFromView:self.view animated:YES];
        isSpining = NO;
    }
}

- (IBAction)backTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) adViewDidReceiveAd:(GADBannerView *)view {
    self.bannerViewHeight.constant = 50;
}

- (GADInterstitial *)createAndLoadInterstitial {
    GADInterstitial *inters = [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-5973128916042439/5681474704"];
    inters.delegate = self;
    [inters loadRequest:[GADRequest request]];
    return inters;
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    interstitial = [self createAndLoadInterstitial];
}

@end
