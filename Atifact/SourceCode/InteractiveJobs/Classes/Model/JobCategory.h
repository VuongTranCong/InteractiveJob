//
//  JobCategory.h
//  VuforiaSamples
//
//  Created by VuongTC on 7/27/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JobCategory : NSObject

@property (nonatomic, strong) NSString* categoryID;
@property (nonatomic, strong) NSString* nameEN;
@property (nonatomic, strong) NSString* nameVN;

- (id) initWithDictionary:(NSDictionary*) dict;


@end
