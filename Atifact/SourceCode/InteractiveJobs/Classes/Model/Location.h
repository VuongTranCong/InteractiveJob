//
//  Location.h
//  VuforiaSamples
//
//  Created by VuongTC on 7/28/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject

@property (nonatomic, strong) NSString* locationID;
@property (nonatomic, strong) NSString* nameEN;
@property (nonatomic, strong) NSString* nameVN;

- (id) initWithDictionary:(NSDictionary*) dict;

@end
