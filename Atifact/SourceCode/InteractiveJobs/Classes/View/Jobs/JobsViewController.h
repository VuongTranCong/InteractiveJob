//
//  JobsViewController.h
//  VuforiaSamples
//
//  Created by VuongTC on 6/29/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobTableViewCell.h"
#import "Company.h"
#import "RobBoldLabel.h"
#import "TopParentViewController.h"

@interface JobsViewController : TopParentViewController <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *mainTable;
    IBOutlet JobTableViewCell* jobCell;
    IBOutlet UIButton *menuButton;
    Company* company;
    BOOL loadingData;
    IBOutlet UIImageView *logoImageView;
    IBOutlet RobRegularLabel *emptyLabel;
}

- (IBAction)menuTapped:(id)sender;

@end
