//
//  NetworkController.h
//  VuforiaSamples
//
//  Created by VuongTC on 7/27/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkController : NSObject

+ (id) getInstance;

- (void) signUp:(NSString*) email firstName:(NSString*) firstName lastName:(NSString*) lastName;
- (void) signIn:(NSString*) email password:(NSString*) password successBlock:(void(^)()) successBlock;
- (void) checkAccountStatus:(NSString*) email successBlock:(void(^)(NSString* status)) successBlock;
- (void) getConfigurationWithSuccessBlock:(void(^)()) successBlock;
- (void) createJobAlertWithEmail:(NSString*) email keywords:(NSString*) keywords jobCategories:(NSArray*) jobCategories jobLocations:(NSArray*) jobLocations jobLevel:(NSString*)jobLevel minSalary:(NSString*)minSalary;

@end
