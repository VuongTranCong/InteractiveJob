//
//  JobLevel.m
//  VuforiaSamples
//
//  Created by VuongTC on 7/28/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import "JobLevel.h"

@implementation JobLevel

- (id) initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.jobLevelID = dict[@"job_level_id"];
        self.nameEN = dict[@"lang_en"];
        self.nameVN = dict[@"lang_vn"];
    }
    return self;
}

@end
