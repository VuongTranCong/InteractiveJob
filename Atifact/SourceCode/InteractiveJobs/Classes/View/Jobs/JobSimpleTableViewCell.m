//
//  JobSimpleTableViewCell.m
//  VuforiaSamples
//
//  Created by VuongTC on 7/1/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import "JobSimpleTableViewCell.h"

@implementation JobSimpleTableViewCell

- (void) setJob:(Job*) dataJob {
    job = dataJob;
    
    nameLabel.text = job.title;
    
}
@end
