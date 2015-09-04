//
//  JobCategory.m
//  VuforiaSamples
//
//  Created by VuongTC on 7/27/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import "JobCategory.h"

@implementation JobCategory

- (id) initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.categoryID = dict[@"category_id"];
        self.nameEN = dict[@"lang_en"];
        self.nameVN = dict[@"lang_vn"];
    }
    return self;
}

@end
