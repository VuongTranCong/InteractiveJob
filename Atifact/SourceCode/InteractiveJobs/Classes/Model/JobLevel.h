//
//  JobLevel.h
//  VuforiaSamples
//
//  Created by VuongTC on 7/28/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JobLevel : NSObject

@property (nonatomic, strong) NSString* jobLevelID;
@property (nonatomic, strong) NSString* nameEN;
@property (nonatomic, strong) NSString* nameVN;

- (id) initWithDictionary:(NSDictionary*) dict;

@end
