//
//  CameraViewController.h
//  VuforiaSamples
//
//  Created by VuongTC on 6/29/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopParentViewController.h"
#import "MenuSlidingViewController.h"

@interface CameraViewController : TopParentViewController {
    MenuSlidingViewController *slidingMenuController;
}

- (void) doneRegconizedImage;
- (void) startRegconizedImage;
- (void) showLoginView;

@end
