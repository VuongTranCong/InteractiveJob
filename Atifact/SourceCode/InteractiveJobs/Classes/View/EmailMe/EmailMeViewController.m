//
//  EmailMeViewController.m
//  VuforiaSamples
//
//  Created by VuongTC on 7/27/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import "EmailMeViewController.h"
#import "NetworkController.h"
#import "AppController.h"
#import "JobCategory.h"
#import "JobLevel.h"
#import "KxMenu.h"
#import "Location.h"

@interface EmailMeViewController ()

@end

@implementation EmailMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    selectedCategories = [[NSMutableArray alloc] init];
    selectedLocation = [[NSMutableArray alloc] init];
    currentCatList = [[NSMutableArray alloc] init];
    currentLocationList = [[NSMutableArray alloc] init];

    [self registerForKeyboardNotifications];

    if ([[AppController getInstance] isLoadedConfiguration] == NO) {
        [self showLoading:YES];
        [[NetworkController getInstance] getConfigurationWithSuccessBlock:^{
            [self resetView];
        }];
    } else {
        [self resetView];
    }
    
    emailTextField.text = [[AppController getInstance] email];
}

- (void) resetView {
    [self showLoading:NO];
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}

- (void) showAlert:(NSString*) message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (IBAction)emailMeTapped:(id)sender {
    if (selectedCategories.count == 0) {
        [self showAlert:@"Please select at least one category."];
        return;
    }
    if (selectedJobLevel == nil) {
        [self showAlert:@"Please select job level."];
        return;
    }

    [[[UIAlertView alloc] initWithTitle:@"" message:@"You will receive emails when we found any job that match your need!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];

    [[NetworkController getInstance] createJobAlertWithEmail:emailTextField.text keywords:keywordsTextField.text jobCategories:[self parseSelectedCategories] jobLocations:[self parseSelectedLocations] jobLevel:selectedJobLevel.jobLevelID minSalary:minSalaryTextField.text];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self backTapped:nil];
}

- (IBAction)categoriesTapped:(id)sender {
    [self showJobCategories];
}

- (IBAction)categoriesClearTapped:(id)sender {
    [selectedCategories removeAllObjects];
    [self resetCategoriesText];
}

- (IBAction)jobLevelTapped:(id)sender {
    [self showJobLevel];
}

- (IBAction)locationTapped:(id)sender {
    [self showLocation];
}

- (IBAction)locationClearTapped:(id)sender {
    [selectedLocation removeAllObjects];
    [self resetLocationText];
}

- (NSArray*) parseSelectedCategories {
    NSMutableArray* result = [[NSMutableArray alloc] init];
    for (JobCategory* jobCat in selectedCategories) {
        NSNumber* idNumber = [NSNumber numberWithInt:[jobCat.categoryID intValue]];
        [result addObject:idNumber];
    }
    return result;
}

- (NSArray*) parseSelectedLocations {
    NSMutableArray* result = [[NSMutableArray alloc] init];
    for (Location* jobCat in selectedLocation) {
        NSNumber* idNumber = [NSNumber numberWithInt:[jobCat.locationID intValue]];
        [result addObject:idNumber];
    }
    return result;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void) showJobCategories {
    [currentCatList removeAllObjects];
    NSMutableArray* menuItems = [[NSMutableArray alloc] init];
    
    for (JobCategory* jobCat in [[AppController getInstance] categoryList]) {
        bool hasCatAdded = false;
        for (JobCategory* curCat in selectedCategories) {
            if ([curCat.categoryID isEqualToString:jobCat.categoryID]) {
                hasCatAdded = true;
                break;
            }
        }
        if (!hasCatAdded) {
            [menuItems addObject:jobCat.nameEN];
            [currentCatList addObject:jobCat];
        }
    }

    JGActionSheetSection *section1 = [JGActionSheetSection sectionWithTitle:@"Please select category" message:nil buttonTitles:menuItems buttonStyle:JGActionSheetButtonStyleDefault];
    JGActionSheetSection *cancelSection = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"Cancel"] buttonStyle:JGActionSheetButtonStyleCancel];
    
    NSArray *sections = @[section1, cancelSection];
    
    JGActionSheet *sheet = [JGActionSheet actionSheetWithSections:sections];
    
    [sheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
        [sheet dismissAnimated:YES];
        
        if (indexPath.section != 1) {
            if (selectedCategories.count < 3) {
                [selectedCategories addObject:[currentCatList objectAtIndex:indexPath.row]];
                [self resetCategoriesText];
            }
        }
    }];
    
    [sheet showInView:self.view animated:YES];
}

- (void) showLocation {
    [currentLocationList removeAllObjects];
    NSMutableArray* menuItems = [[NSMutableArray alloc] init];
    
    for (Location* jobLocation in [[AppController getInstance] locationList]) {
        bool hasLocationAdded = false;
        for (Location* curLocation in selectedLocation) {
            if ([curLocation.locationID isEqualToString:jobLocation.locationID]) {
                hasLocationAdded = true;
                break;
            }
        }
        if (!hasLocationAdded) {
            [menuItems addObject:jobLocation.nameEN];
            [currentLocationList addObject:jobLocation];
        }
    }
    
    JGActionSheetSection *section1 = [JGActionSheetSection sectionWithTitle:@"Please select location" message:nil buttonTitles:menuItems buttonStyle:JGActionSheetButtonStyleDefault];
    JGActionSheetSection *cancelSection = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"Cancel"] buttonStyle:JGActionSheetButtonStyleCancel];
    
    NSArray *sections = @[section1, cancelSection];
    
    JGActionSheet *sheet = [JGActionSheet actionSheetWithSections:sections];
    
    [sheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
        [sheet dismissAnimated:YES];
        
        if (indexPath.section != 1) {
            if (selectedLocation.count < 3) {
                [selectedLocation addObject:[currentLocationList objectAtIndex:indexPath.row]];
                [self resetLocationText];
            }
        }
    }];
    
    [sheet showInView:self.view animated:YES];
}

- (void) showJobLevel {
    NSMutableArray *menuItems = [[NSMutableArray alloc] init];
    for (JobLevel* jobCat in [[AppController getInstance] jobLevelList]) {
        [menuItems addObject:jobCat.nameEN];
    }
    
    JGActionSheetSection *section1 = [JGActionSheetSection sectionWithTitle:@"Please select job level" message:nil buttonTitles:menuItems buttonStyle:JGActionSheetButtonStyleDefault];
    JGActionSheetSection *cancelSection = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"Cancel"] buttonStyle:JGActionSheetButtonStyleCancel];
    
    NSArray *sections = @[section1, cancelSection];
    
    JGActionSheet *sheet = [JGActionSheet actionSheetWithSections:sections];
    
    [sheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
        [sheet dismissAnimated:YES];
        selectedJobLevel = [[[AppController getInstance] jobLevelList] objectAtIndex:indexPath.row];
        jobLevelTextField.text = selectedJobLevel.nameEN;
    }];
    
    [sheet showInView:self.view animated:YES];
}

- (void) resetCategoriesText {
    categoriesLabel.text = @"";
    for (JobCategory* jobCat in selectedCategories) {
        categoriesLabel.text = [categoriesLabel.text stringByAppendingString:jobCat.nameEN];

        if (jobCat != selectedCategories.lastObject) {
            categoriesLabel.text = [categoriesLabel.text stringByAppendingString:@", "];
        }
    }
    
    if ([categoriesLabel.text isEqualToString:@""]) {
        categoriesLabel.text = @"Please select (Max 3 categories)";
        categoriesLabel.textColor = [UIColor colorWithRed:179/255.f green:179/255.f blue:179/255.f alpha:0.5];
    } else {
        categoriesLabel.textColor = [UIColor darkGrayColor];
    }
    categoriesLabel.frame = CGRectMake(8, 6, 215, 30);
    [categoriesLabel sizeToFit];
}

- (void) resetLocationText {
    locationLabel.text = @"";
    for (Location* jobCat in selectedLocation) {
        locationLabel.text = [locationLabel.text stringByAppendingString:jobCat.nameEN];
        
        if (jobCat != selectedLocation.lastObject) {
            locationLabel.text = [locationLabel.text stringByAppendingString:@", "];
        }
    }
    
    if ([locationLabel.text isEqualToString:@""]) {
        locationLabel.text = @"Please select (Max 3 locations)";
        locationLabel.textColor = [UIColor colorWithRed:179/255.f green:179/255.f blue:179/255.f alpha:0.5];
    } else {
        locationLabel.textColor = [UIColor darkGrayColor];
    }
    locationLabel.frame = CGRectMake(8, 6, 215, 30);
    [locationLabel sizeToFit];
}

@end
