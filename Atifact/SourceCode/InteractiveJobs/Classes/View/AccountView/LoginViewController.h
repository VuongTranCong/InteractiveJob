//
//  LoginViewController.h
//  VuforiaSamples
//
//  Created by VuongTC on 7/2/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "TopParentViewController.h"

#import "LIALinkedInHttpClient.h"
//#import "LIALinkedInClientExampleCredentials.h"
#import "LIALinkedInApplication.h"
#import "AFHTTPRequestOperation.h"

@interface LoginViewController : TopParentViewController <FBSDKLoginButtonDelegate> {
    IBOutlet UITextField *emailTextField;
    IBOutlet UITextField *passwordTextField;
    
    LIALinkedInHttpClient *client;
}

@property (strong, nonatomic) IBOutlet FBSDKLoginButton *loginButton;
- (IBAction)linkedInTapped:(id)sender;

@end
