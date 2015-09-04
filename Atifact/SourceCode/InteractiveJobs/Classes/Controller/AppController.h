//
//  AppController.h
//  VuforiaSamples
//
//  Created by VuongTC on 6/29/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CameraViewController.h"
#import "LeftMenuViewController.h"
#import "Company.h"
#import "Job.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

enum {
    RobBoldFont
};

@interface AppController : NSObject {
    BOOL isStartAR;
        UILabel *calculateSizeLabel;
    
    NSString* currentEmail;
    NSString* currentFirstName;
    NSString* currentLastName;
    NSMutableArray* listOfUrl;
    NSMutableArray* jobList;
    int resultCount;
}

@property (nonatomic, strong) CameraViewController* cameraViewController;
@property (nonatomic, strong) LeftMenuViewController* leftMenuViewController;
@property (nonatomic, strong) NSMutableArray* companyList;
@property (nonatomic, strong) Company* currentCompany;
@property (nonatomic, strong) NSMutableArray* categoryList;
@property (nonatomic, strong) NSMutableArray* jobLevelList;
@property (nonatomic, strong) NSMutableArray* locationList;
@property (nonatomic, strong) NSString* historyList;
@property BOOL isLoadedConfiguration;

+ (id) getInstance;

- (void) foundObjectWithName:(NSString *) vuforiaName;
- (void) loadDataOfCompany:(Company *) com successBlock:(void(^)(NSMutableArray*))successBlock;
- (CGFloat) heightForText:(NSString*) text fontIndex:(int) fontIndex fontSize:(int) fontSize fixedWidth:(CGFloat) width;

- (void) handleAccountStatusWithFacebook;
- (void) handleAccountStatusWithLinkedIn:(NSString*) accessToken;
- (BOOL) isLoggedByLinkedIn;

- (void) logOut;
- (NSString*) email;
@end
