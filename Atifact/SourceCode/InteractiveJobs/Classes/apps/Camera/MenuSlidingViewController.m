//
//  MenuSlidingViewController.m
//  VuforiaSamples
//
//  Created by VuongTC on 7/1/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MenuSlidingViewController.h"
#import "LeftMenuViewController.h"

// the duration of the animation to display the menu
//static const CGFloat kSlidingMenuSlideDuration = 0.3;

#define MAX_PAN_VELOCITY 600

// shadow properties
#define SHADOW_OPACITY 0.8f
#define SHADOW_RADIUS_CORNER 3.0f

#define ANIMATION_DURATION .3

@interface MenuSlidingViewController ()
//- (void)setRootViewControllerShadow:(BOOL)val;

@property(nonatomic,retain) LeftMenuViewController *menuViewController;
@property(nonatomic,retain) UIViewController *rootViewController;

@end

@implementation MenuSlidingViewController

@synthesize menuViewController=_menuViewController;
@synthesize rootViewController=_rootViewController;

- (id)initWithRootViewController:(UIViewController*) controller {
    if ((self = [super init])) {
        self.rootViewController = controller;
        // the left view controller is the menu associated to the application
        LeftMenuViewController *  mvc =[[LeftMenuViewController alloc] initWithNibName:@"LeftMenuViewController" bundle:nil];
        self.menuViewController = mvc;
        self.menuViewController.slidingMenuViewController = self;
        
         kSlidingMenuWidth = 0;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(dismiss)
                                                     name:@"kMenuDismissViewController"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(showMenu)
                                                     name:@"show_menu"
                                                   object:nil];
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(BOOL)isIpad{
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // add the view associated to the root view controller
    UIView *view = self.rootViewController.view;
    view.frame = self.view.bounds;
    [self.view addSubview:view];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self showLeftMenu:YES];
}

- (void)showRootController:(BOOL)animated {
    self.rootViewController.view.userInteractionEnabled = YES;
    
    CGRect frame = self.rootViewController.view.frame;
    frame.origin.x = 0.0f;
    
    // keep track of the state of the animations
    BOOL animationEnabled = [UIView areAnimationsEnabled];
    if (!animated) {
        [UIView setAnimationsEnabled:NO];
    }
    
    // the animation will position the root view controller to its final frame position
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        self.rootViewController.view.frame = frame;
    } completion:^(BOOL finished) {
        // at the end, we remove the menu
        // from its superview to make it disappear
        if (self.menuViewController && self.menuViewController.view.superview) {
            [self.menuViewController.view removeFromSuperview];
        }
        showingLeftMenu = NO;
    }];
    
    if (!animated) {
        // restore the state of the animations
        [UIView setAnimationsEnabled:animationEnabled];
    }
    
}

- (void)showLeftMenu:(BOOL)animated {
    showingLeftMenu = YES;
    
    // compute sizes of different frames for the animation
    UIView *view = self.menuViewController.view;
    CGRect frame = self.view.bounds;
    view.frame = frame;
    [self.view insertSubview:view atIndex:1];
    [self.menuViewController viewWillAppear:animated];
    
    frame = self.rootViewController.view.frame;
    frame.origin.x = kSlidingMenuWidth;
    
    // keep track of the state of the animations
    BOOL animationEnabled = [UIView areAnimationsEnabled];
    if (!animated) {
        [UIView setAnimationsEnabled:NO];
    }
    
    // perform the animation
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        self.rootViewController.view.frame = frame;
    } completion:^(BOOL finished) {
    }];
    
    if (!animated) {
        // restore the state of the animations
        [UIView setAnimationsEnabled:animationEnabled];
    }
    
}

- (void) dismiss {
    // dismiss the controller by going back to the root
    // of the navigation controller
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) showMenu {
    if (!showingLeftMenu) {
        [self showLeftMenu:YES];
    }
}

@end
