//
//  EmailMeViewController.h
//  VuforiaSamples
//
//  Created by VuongTC on 7/27/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopParentViewController.h"
#import "JGActionSheet.h"
#import "JobLevel.h"

@interface EmailMeViewController : TopParentViewController<UITextFieldDelegate, UIAlertViewDelegate> {
    IBOutlet UIScrollView *scrollView;
    IBOutlet UITextField *emailTextField;
    IBOutlet UITextField *keywordsTextField;
    IBOutlet UILabel *categoriesLabel;
    IBOutlet UIButton *categoriesButton;
    IBOutlet UITextField *jobLevelTextField;
    IBOutlet UILabel *locationLabel;
    IBOutlet UITextField *minSalaryTextField;
    
    NSMutableArray* selectedCategories;
    NSMutableArray* selectedLocation;
    JobLevel* selectedJobLevel;
    
    NSMutableArray* currentCatList;
    NSMutableArray* currentLocationList;
}

- (IBAction)emailMeTapped:(id)sender;

- (IBAction)categoriesTapped:(id)sender;
- (IBAction)categoriesClearTapped:(id)sender;

- (IBAction)jobLevelTapped:(id)sender;

- (IBAction)locationTapped:(id)sender;
- (IBAction)locationClearTapped:(id)sender;

@end
