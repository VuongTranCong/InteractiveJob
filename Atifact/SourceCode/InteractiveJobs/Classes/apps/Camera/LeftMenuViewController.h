//
//  LeftMenuViewController.h
//  VuforiaSamples
//
//  Created by VuongTC on 7/1/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobSimpleTableViewCell.h"
#import "Company.h"
#import "TopParentViewController.h"

@class MenuSlidingViewController;

@interface LeftMenuViewController : TopParentViewController {
    id observer;
    Company* company;
    BOOL loadingData;
    IBOutlet UILabel *nameLabel;
    IBOutlet UITableView *mainTable;
    IBOutlet JobSimpleTableViewCell *jobCell;
    IBOutlet UIView *contentView;
    IBOutlet UILabel *guideLabel;
}

@property(nonatomic,assign) MenuSlidingViewController *slidingMenuViewController;

- (IBAction)menuTapped:(id)sender;
- (void) updateData;

@end