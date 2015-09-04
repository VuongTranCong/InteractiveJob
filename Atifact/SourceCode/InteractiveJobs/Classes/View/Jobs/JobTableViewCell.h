//
//  JobTableViewCell.h
//  VuforiaSamples
//
//  Created by VuongTC on 6/29/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RobRegularLabel.h"
#import "Job.h"

@interface JobTableViewCell : UITableViewCell {
    Job* job;
    IBOutlet RobRegularLabel *titleLabel;
    IBOutlet RobRegularLabel *subTitleLabel;
    IBOutlet RobRegularLabel *dateLabel;
    IBOutlet RobRegularLabel *viewLabel;
    IBOutlet RobRegularLabel *skill1Label;
    IBOutlet RobRegularLabel *skill2Label;
    IBOutlet RobRegularLabel *skill3Label;
}

- (void) setJob:(Job*) dataJob;

@end
