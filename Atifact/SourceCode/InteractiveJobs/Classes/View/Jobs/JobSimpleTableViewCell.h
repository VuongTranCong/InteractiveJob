//
//  JobSimpleTableViewCell.h
//  VuforiaSamples
//
//  Created by VuongTC on 7/1/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Job.h"

@interface JobSimpleTableViewCell : UITableViewCell {
    Job* job;
    IBOutlet UILabel* nameLabel;
}

- (void) setJob:(Job*) dataJob;

@end
