//
//  TopParentViewController.h
//  VuforiaSamples
//
//  Created by VuongTC on 6/30/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RobBoldLabel.h"
#import "GMDCircleLoader.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface TopParentViewController : UIViewController <GADBannerViewDelegate, GADInterstitialDelegate> {
    IBOutlet RobBoldLabel *titleLabel;
    BOOL isSpining;
    GADBannerView  *bannerView;
    GADInterstitial *interstitialAds;
}

@property (strong, nonatomic) IBOutlet UIView *bannerViewHolder;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint  *bannerViewHeight;

- (void) showLoading:(BOOL) isShow;
- (IBAction)backTapped:(id)sender;
- (void) showInterstitialAds;

@end
