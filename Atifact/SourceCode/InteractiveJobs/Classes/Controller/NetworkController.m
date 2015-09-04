//
//  NetworkController.m
//  VuforiaSamples
//
//  Created by VuongTC on 7/27/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import "NetworkController.h"
#import "JobCategory.h"
#import "JobLevel.h"
#import "Location.h"
#import "AppController.h"

#define STAGING 1

#ifdef STAGING

#define API_DOMAIN @"https://api-staging.vietnamworks.com" //Staging API server
#define COMSUMERKEY @"017c8fbe29cc15972401579a81861da47a57b6f0a67aa0782c26436cdc0338a4"

#else

#define API_DOMAIN @"https://api.vietnamworks.com" //Production API server
#define COMSUMERKEY @"017c8fbe29cc15972401579a81861da47a57b6f0a67aa0782c26436cdc0338a4"

#endif

static NetworkController* instance;

@implementation NetworkController

+ (id) getInstance {
    if (!instance) {
        instance = [[NetworkController alloc] init];
    }
    return instance;
}

- (NSMutableURLRequest*) createRequest:(NSDictionary*) paramDict apiPath:(NSString*) apiPath{
    NSString* urlStr = [NSString stringWithFormat:@"%@%@", API_DOMAIN, apiPath];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramDict
                                                       options:0
                                                         error:nil];
    NSString *sendString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL URLWithString:API_DOMAIN]];
    [request setHTTPMethod:@"POST"];
    [request setValue:COMSUMERKEY forHTTPHeaderField:@"CONTENT-MD5"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setValue:[NSString stringWithFormat:@"%d", sendString.length] forHTTPHeaderField:@"Content-Length"];
    [request setURL:[NSURL URLWithString:urlStr]];
    
    [request setValue:[NSString stringWithFormat:@"%d", [sendString length]] forHTTPHeaderField:@"Content-length"];
    
    NSLog(@"Request body: %@", sendString);
    [request setHTTPBody:[sendString dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}

- (void) signUp:(NSString *)email firstName:(NSString *)firstName lastName:(NSString *)lastName{
    NSString* apiPath = @"/users/registerWithoutConfirm";
    
    NSDictionary* paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
                               email, @"email",
                               firstName, @"firstname",
                               lastName, @"lastname",
                               nil];
    
    NSMutableURLRequest *request = [self createRequest:paramDict apiPath:apiPath];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary* resultDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@", resultDict);
    }];
}

- (void) checkAccountStatus:(NSString *)email successBlock:(void(^)(NSString* status)) successBlock {
    NSString* apiPath = @"/users/account-status/";
    NSString* encodedEmail = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* urlStr = [NSString stringWithFormat:@"%@%@email/%@", API_DOMAIN, apiPath, encodedEmail];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL URLWithString:API_DOMAIN]];
    [request setHTTPMethod:@"GET"];
    [request setValue:COMSUMERKEY forHTTPHeaderField:@"CONTENT-MD5"];
    [request setURL:[NSURL URLWithString:urlStr]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary* resultDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@", resultDict);
        successBlock(resultDict[@"data"][@"accountStatus"]);
    }];
}

- (void) signIn:(NSString *)email password:(NSString *)password successBlock:(void (^)())successBlock{
    NSString* apiPath = @"/users/login";
    NSDictionary* paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
                               email, @"user_email",
                               password, @"user_password", nil];
    NSMutableURLRequest *request = [self createRequest:paramDict apiPath:apiPath];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary* resultDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@", resultDict);
        successBlock();
    }];
}

- (void) getConfigurationWithSuccessBlock:(void (^)())successBlock {
    NSString* apiPath = @"/general/configuration/";
    NSString* urlStr = [NSString stringWithFormat:@"%@%@", API_DOMAIN, apiPath];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL URLWithString:API_DOMAIN]];
    [request setHTTPMethod:@"GET"];
    [request setValue:COMSUMERKEY forHTTPHeaderField:@"CONTENT-MD5"];
    [request setURL:[NSURL URLWithString:urlStr]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary* resultDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"%@", resultDict);
        NSArray* categoriesDict = resultDict[@"data"][@"categories"];
        for (NSDictionary* dict in categoriesDict) {
            JobCategory* jobCat = [[JobCategory alloc] initWithDictionary:dict];
            [[[AppController getInstance] categoryList] addObject:jobCat];
        }

        NSArray* jobLevelDict = resultDict[@"data"][@"job_levels"];
        for (NSDictionary* dict in jobLevelDict) {
            JobLevel* jobCat = [[JobLevel alloc] initWithDictionary:dict];
            [[[AppController getInstance] jobLevelList] addObject:jobCat];
        }

        NSArray* locationDict = resultDict[@"data"][@"locations"];
        for (NSDictionary* dict in locationDict) {
            Location* jobCat = [[Location alloc] initWithDictionary:dict];
            [[[AppController getInstance] locationList] addObject:jobCat];
        }

        successBlock();
        [[AppController getInstance] setIsLoadedConfiguration:YES];
    }];
}

- (void) createJobAlertWithEmail:(NSString *)email keywords:(NSString *)keywords jobCategories:(NSArray *)jobCategories jobLocations:(NSArray *)jobLocations jobLevel:(NSString *)jobLevel minSalary:(NSString *)minSalary {
    NSString* apiPath = @"/users/create-jobalert/";
    NSDictionary* paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
                               email, @"email",
                               keywords, @"keywords",
                               jobCategories, @"job_categories",
                               jobLocations, @"job_locations",
                               jobLevel, @"job_level",
                               minSalary, @"min_salary",
                               @"3", @"frequency",
                               @"1", @"lang",
                               nil];
    
    NSMutableURLRequest *request = [self createRequest:paramDict apiPath:apiPath];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data != nil) {
//            NSDictionary* resultDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"" message:@"Please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}
@end