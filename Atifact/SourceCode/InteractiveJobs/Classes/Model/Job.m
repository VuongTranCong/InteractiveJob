//
//  Job.m
//  VuforiaSamples
//
//  Created by VuongTC on 6/29/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import "Job.h"

@implementation Job

- (id) initWithJson:(NSDictionary *)dict {
    if (self = [super init]) {
        self.title = dict[@"title/_text"];
        self.urlDetail = dict[@"title"];
        self.address = dict[@"address"];
        self.jobTitle = dict[@"jobtitle"];
        self.dateStr = dict[@"datestr"];
        self.viewCount = dict[@"viewcount"];
        self.companyName = dict[@"companyname"];
        self.skill1 = dict[@"skill1"];
        self.skill2 = dict[@"skill2"];
        self.skill3 = dict[@"skill3"];
    }
    return self;
}

@end
