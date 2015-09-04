//
//  JobTableViewCell.m
//  VuforiaSamples
//
//  Created by VuongTC on 6/29/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import "JobTableViewCell.h"

@implementation JobTableViewCell

- (void) setJob:(Job*) dataJob {
    job = dataJob;
    
    titleLabel.text = job.title;
    subTitleLabel.text = [NSString stringWithFormat:@"%@ | %@", job.address, job.jobTitle];
    dateLabel.text = job.dateStr;
    viewLabel.text = job.viewCount;
    
    if (![self isStringNil:job.skill1]) {
        skill1Label.text = job.skill1;
        skill1Label.superview.hidden = NO;
    } else {
        skill1Label.superview.hidden = YES;
    }

    if (![self isStringNil:job.skill2]) {
        skill2Label.text = job.skill2;
        skill2Label.superview.hidden = NO;
    } else {
        skill2Label.superview.hidden = YES;
    }

    if (![self isStringNil:job.skill3]) {
        skill3Label.text = job.skill3;
        skill3Label.superview.hidden = NO;
    } else {
        skill3Label.superview.hidden = YES;
    }
}

- (BOOL) isStringNil:(NSString*) str {
    if (str == nil || [str isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

@end
