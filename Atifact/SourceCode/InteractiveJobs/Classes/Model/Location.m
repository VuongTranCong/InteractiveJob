//
//  Location.m
//  VuforiaSamples
//
//  Created by VuongTC on 7/28/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import "Location.h"

@implementation Location
- (id) initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.locationID = dict[@"location_id"];
        self.nameEN = dict[@"lang_en"];
        self.nameVN = dict[@"lang_vn"];
    }
    return self;
}
@end
