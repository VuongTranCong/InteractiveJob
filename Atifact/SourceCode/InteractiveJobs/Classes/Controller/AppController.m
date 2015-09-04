//
//  AppController.m
//  VuforiaSamples
//
//  Created by VuongTC on 6/29/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import "AppController.h"
#import "SQLiteManager.h"
#import "HtmlParser.h"
#import "NetworkController.h"

static AppController *instance;

@implementation AppController

+ (id) getInstance {
    if (!instance) {
        instance = [[AppController alloc] init];
    }
    return instance;
}

- (id) init {
    if (self = [super init]) {
        [self initCompanyList];
        isStartAR = NO;
        self.isLoadedConfiguration = NO;
        self.categoryList = [[NSMutableArray alloc] init];
        self.jobLevelList = [[NSMutableArray alloc] init];
        self.locationList = [[NSMutableArray alloc] init];
        listOfUrl = [[NSMutableArray alloc] init];
        jobList = [[NSMutableArray alloc] init];
        [self loadHistoryList];
    }
    return self;
}

- (void) loadHistoryList {
    NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
    self.historyList = [userDef valueForKey:@"history"] == nil ? @"" : [userDef valueForKey:@"history"];
}

- (void) initCompanyList {
    self.companyList = [[SQLiteManager getInstance] allCompany];
    
//    Company* s3corp = [[Company alloc] init];
//    s3corp.companyurl = @"http://www.vietnamworks.com/jobs-at-sunrise-software-solutions-corp-e1279268-en";
//    s3corp.companylogo = @"http://images.vietnamworks.com/pictureofcompany/21/10086443.png";
//    s3corp.vuforia = @"s3corp";
//    s3corp.name = @"Sunrise Software Solutions Corp";
//    [self.companyList addObject:s3corp];
//    
//    Company* meCorp = [[Company alloc] init];
//    meCorp.companyurl = @"http://www.vietnamworks.com/jobs-at-mobile-entertainment-corporation-e3641565-en";
//    meCorp.companylogo = @"http://images.vietnamworks.com/pictureofcompany/02/10199738.png";
//    meCorp.vuforia = @"mecorp";
//    meCorp.name = @"Mobile Entertainment Corporation";
//    [self.companyList addObject:meCorp];
//
//    Company* etownBuilding = [[Company alloc] init];
//    etownBuilding.companyurl = @"http://www.vietnamworks.com/jobs-at-orient-software-development-corp-e401287-en;http://www.vietnamworks.com/jobs-at-swiss-it-bridge-co-ltd-e793599-en;http://www.vietnamworks.com/jobs-at-fujinet-co-ltd-e815181-en;http://www.vietnamworks.com/jobs-at-viosoft-vietnam-e3743384-en";
//    etownBuilding.companylogo = @"";
//    etownBuilding.vuforia = @"etown";
//    etownBuilding.name = @"Etown building";
//    [self.companyList addObject:etownBuilding];
 
    
    
}

- (void) foundObjectWithName:(NSString *) vuforiaName {
    if (self.currentCompany != nil && [vuforiaName containsString:self.currentCompany.vuforia]) {
        return;
    }
    NSLog(@"found object with name %@", vuforiaName);
    for (Company* com in self.companyList) {
        if ([vuforiaName containsString:com.vuforia]) {
            self.currentCompany = com;
            [self.cameraViewController doneRegconizedImage];
            [self saveToLocal:vuforiaName];
            return;
        }
    }
}

- (void) saveToLocal:(NSString*) vuforiaName {
    NSArray* localNameList = [self.historyList componentsSeparatedByString:@";"];

    BOOL found = NO;
    for (NSString* str in localNameList) {
        if ([str isEqualToString:vuforiaName]) {
            found = YES;
            break;
        }
    }
    if (!found) {
        if (self.historyList == nil || [self.historyList isEqualToString:@""]) {
            self.historyList = vuforiaName;
        } else {
            self.historyList = [self.historyList stringByAppendingString:[NSString stringWithFormat:@";%@", vuforiaName]];
        }
        NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
        [userDef setValue:self.historyList forKey:@"history"];
        [userDef synchronize];
    }
}

- (void) loadDataOfCompany:(Company *) com successBlock:(void(^)(NSMutableArray*))successBlock {
    listOfUrl = [[com.companyurl componentsSeparatedByString:@";"] mutableCopy];
    [jobList removeAllObjects];
    resultCount = 0;
    for (NSString* url in listOfUrl) {
        [HtmlParser parseCompanyFromURL:url successBlock:^(NSMutableArray *list) {
            NSLog(@"get data from single company url");
            for (Job *job in list) {
                [jobList addObject:job];
            }
            resultCount++;
            
            if (resultCount == listOfUrl.count) {
                successBlock(jobList);
            }
        }];
    }
}

- (CGFloat) heightForText:(NSString *)text fontIndex:(int)fontIndex fontSize:(int) fontSize fixedWidth:(CGFloat)width {
    if (calculateSizeLabel == nil) {
        calculateSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
        calculateSizeLabel.numberOfLines = 0;
    }
    calculateSizeLabel.frame = CGRectMake(0, 0, width, 0);
    
    switch (fontIndex) {
        case RobBoldFont:
            calculateSizeLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:fontSize];
            break;
            
        default:
            break;
    }
    calculateSizeLabel.text = text;
    [calculateSizeLabel sizeToFit];
    return calculateSizeLabel.frame.size.height;
}

- (void) handleAccountStatusWithFacebook {
    [self getFacebookProfileInfos];
}

-(void)getFacebookProfileInfos {
    FBSDKGraphRequest *requestMe = [[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters:nil];
    FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
    [connection addRequest:requestMe completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        
        if(result)
        {
            if ([result objectForKey:@"email"]) {
                currentEmail  = result[@"email"];
            }
            if ([result objectForKey:@"first_name"]) {
                currentFirstName = result[@"first_name"];
            }
            if ([result objectForKey:@"last_name"]) {
                currentLastName = result[@"last_name"];
            }
            [self saveEmail];
            [[NetworkController getInstance] checkAccountStatus:currentEmail successBlock:^(NSString *status) {
                if ([status isEqualToString:@"NEW"]) {
                    [[NetworkController getInstance] signUp:currentEmail firstName:currentFirstName lastName:currentLastName];
                }
            }];
        }
        
    }];
    
    [connection start];
}

- (void) handleAccountStatusWithLinkedIn:(NSString *)accessToken {
    [self requestMeWithToken:accessToken];
    [self saveLinkedInAccessToken: accessToken];
}

- (void) saveLinkedInAccessToken:(NSString *)accessToken {
    NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
    [userDefs setObject:accessToken forKey:@"linkedinaccesstoken"];
    [userDefs synchronize];
}

- (BOOL) isLoggedByLinkedIn {
    NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
    NSString* oldAccessToken = [userDefs valueForKey:@"linkedinaccesstoken"];
    if (oldAccessToken == nil || [oldAccessToken isEqualToString:@""]) {
        return NO;
    }
    return YES;
}

- (void)requestMeWithToken:(NSString *)accessToken {
    NSString *urlStr = [NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~:(id,email-address,first-name,last-name)?oauth2_access_token=%@&format=json", accessToken];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary* result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"current user %@", result);
        
        if(result)
        {
            if ([result objectForKey:@"emailAddress"]) {
                currentEmail  = result[@"emailAddress"];
            }
            if ([result objectForKey:@"firstName"]) {
                currentFirstName = result[@"firstName"];
            }
            if ([result objectForKey:@"lastName"]) {
                currentLastName = result[@"lastName"];
            }
            
            [self saveEmail];
            [[NetworkController getInstance] checkAccountStatus:currentEmail successBlock:^(NSString *status) {
                if ([status isEqualToString:@"NEW"]) {
                    [[NetworkController getInstance] signUp:currentEmail firstName:currentFirstName lastName:currentLastName];
                }
            }];
        }
    }];
}

- (void) saveEmail {
    NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
    [userDefs setObject:currentEmail forKey:@"email"];
    [userDefs synchronize];
}

- (NSString*) email {
    NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
    return [userDefs valueForKey:@"email"];
}

- (void) logOut {
    if ([self isLoggedByLinkedIn]) {
        [self saveLinkedInAccessToken:@""];
    } else {
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logOut];
        [FBSDKAccessToken setCurrentAccessToken:nil];
    }
}

@end
