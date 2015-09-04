//
//  LocalJobsViewController.h
//  VuforiaSamples
//
//  Created by VuongTC on 8/5/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobTableViewCell.h"
#import "Company.h"
#import "RobBoldLabel.h"
#import "TopParentViewController.h"

@interface LocalJobsViewController : TopParentViewController <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *mainTable;
    IBOutlet JobTableViewCell* jobCell;
    BOOL loadingData;
    IBOutlet UIImageView *logoImageView;
    IBOutlet RobRegularLabel *emptyLabel;
}

@property (nonatomic, strong) Company* company;

@end
