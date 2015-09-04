//
//  Company.m
//  VuforiaSamples
//
//  Created by VuongTC on 6/30/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import "Company.h"
#import "Job.h"

@implementation Company

- (id) init {
    if (self = [super init]) {
        self.jobs = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) addJobs:(NSArray *)objects {
    for (Job* job in objects) {
        [self.jobs addObject:job];
    }
}

@end
