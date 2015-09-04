//
//  MenuSlidingViewController.h
//  VuforiaSamples
//
//  Created by VuongTC on 7/1/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LeftMenuViewController;

@interface MenuSlidingViewController : UIViewController <UIGestureRecognizerDelegate>{
    CGFloat kSlidingMenuWidth;

    // true when the left menu is displayed
    BOOL showingLeftMenu;
}

- (id)initWithRootViewController:(UIViewController*)controller;

- (void) showRootController:(BOOL)animated;
- (void) showLeftMenu:(BOOL)animated;

- (void) dismiss;

@end