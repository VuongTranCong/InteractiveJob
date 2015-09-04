//
//  LoginViewController.m
//  VuforiaSamples
//
//  Created by VuongTC on 7/2/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import "LoginViewController.h"
#import "CameraViewController.h"
#import "AppController.h"
#import "NetworkController.h"
//#import <linkedin-sdk/LISDK.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    client = [self client];
}

- (void) moveToCameraView {
    //    [self dismissViewControllerAnimated:YES completion:^{
    [[[AppController getInstance] cameraViewController] startRegconizedImage];
    [super backTapped:nil];
    //    }];
}

- (void)  loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
                error:(NSError *)error {
    NSLog(@"facebook login result %@", result);
    [[AppController getInstance] handleAccountStatusWithFacebook];
    [self moveToCameraView];
}

- (void) loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {}

- (IBAction)linkedInTapped:(id)sender {
    [client getAuthorizationCode:^(NSString *code) {
        [client getAccessToken:code success:^(NSDictionary *accessTokenData) {
            NSString *accessToken = [accessTokenData objectForKey:@"access_token"];
            [[AppController getInstance] handleAccountStatusWithLinkedIn:accessToken];
            [self moveToCameraView];
        }                   failure:^(NSError *error) {
            NSLog(@"Quering accessToken failed %@", error);
        }];
    }                      cancel:^{
        NSLog(@"Authorization was cancelled by user");
    }                     failure:^(NSError *error) {
        NSLog(@"Authorization failed %@", error);
    }];
}

- (LIALinkedInHttpClient *)client {
    LIALinkedInApplication *application = [LIALinkedInApplication applicationWithRedirectURL:@"https://www.facebook.com/tcvuong"
                                                                                    clientId:@"75tyarfyoidrhf"
                                                                                clientSecret:@"jmbo7AVYZkTpT8Qy"
                                                                                       state:@"DCEEFWF45453sdffef424"
                                                                               grantedAccess:@[@"r_basicprofile+r_emailaddress"]];
    return [LIALinkedInHttpClient clientForApplication:application presentingViewController:nil];
}

@end
