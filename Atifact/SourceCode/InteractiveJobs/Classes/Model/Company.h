//
//  Company.h
//  VuforiaSamples
//
//  Created by VuongTC on 6/30/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Company : NSObject

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* companyurl;
@property (nonatomic, strong) NSString* companylogo;
@property (nonatomic, strong) NSString* vuforia;
@property (nonatomic, strong) NSString* companyweb;
@property (nonatomic, strong) NSMutableArray* jobs;

- (void) addJobs:(NSArray *)objects;

@end
