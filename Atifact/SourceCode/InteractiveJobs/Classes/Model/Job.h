//
//  Job.h
//  VuforiaSamples
//
//  Created by VuongTC on 6/29/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Job : NSObject

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* address;
@property (nonatomic, strong) NSString* jobTitle;
@property (nonatomic, strong) NSString* dateStr;
@property (nonatomic, strong) NSString* viewCount;
@property (nonatomic, strong) NSString* salary;
@property (nonatomic, strong) NSString* companyName;
@property (nonatomic, strong) NSString* skill1;
@property (nonatomic, strong) NSString* skill2;
@property (nonatomic, strong) NSString* skill3;
@property (nonatomic, strong) NSString* urlDetail;

- (id) initWithJson:(NSDictionary *) dict;

@end
