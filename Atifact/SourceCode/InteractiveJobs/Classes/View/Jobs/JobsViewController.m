//
//  JobsViewController.m
//  VuforiaSamples
//
//  Created by VuongTC on 6/29/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import "JobsViewController.h"
#import "AppController.h"
#import "JobDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "KxMenu.h"
#import "EmailMeViewController.h"
#import "HistoryViewController.h"
#import "Job.h"

@interface JobsViewController ()

@end

@implementation JobsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    company = [[AppController getInstance] currentCompany];
    
    if (company == nil) {
        company = [[[AppController getInstance] companyList] lastObject];
    }
    
    titleLabel.text = company.name;
    loadingData = NO;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (company != nil && company.jobs.count == 0) {
        if (!loadingData) {
            loadingData = YES;
            [self showLoading:YES];
            [[AppController getInstance] loadDataOfCompany:company successBlock:^(NSMutableArray *jobs) {
                [company addJobs:jobs];
                
                if (company.jobs.count == 0) {
                    mainTable.hidden = YES;
                    emptyLabel.hidden = NO;
                } else {
                    mainTable.hidden = NO;
                    emptyLabel.hidden = YES;
                    [mainTable reloadData];
                }
                [self showLoading:NO];
                loadingData = NO;
            }];
        }
        
        [logoImageView sd_setImageWithURL:[NSURL URLWithString:company.companylogo]];
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JobTableViewCell *cell = (JobTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        [[NSBundle mainBundle] loadNibNamed:@"JobTableViewCell" owner:self options:nil];
        cell = jobCell;
        jobCell = nil;
    }
    
    Job* job = [company.jobs objectAtIndex:indexPath.row];
    [cell setJob:job];
    
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return company.jobs.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Job* job = [company.jobs objectAtIndex:indexPath.row];
    CGFloat height = [[AppController getInstance] heightForText:job.title fontIndex:RobBoldFont fontSize:23 fixedWidth:280];
    return height + 112;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Job* job = [company.jobs objectAtIndex:indexPath.row];
    
    JobDetailViewController* jobDetailViewController = [[JobDetailViewController alloc] initWithNibName:@"JobDetailViewController" bundle:nil];
    [self.navigationController pushViewController:jobDetailViewController animated:YES];
    [jobDetailViewController setJob:job];
}

- (void) backTapped:(id)sender {
    [[AppController getInstance] setCurrentCompany:nil];
    [[[AppController getInstance] cameraViewController] startRegconizedImage];
    [super backTapped:sender];
}

- (void) logOutTapped:(id) sender {
    [[AppController getInstance] logOut];
    [[AppController getInstance] setCurrentCompany:nil];
    [self.navigationController popViewControllerAnimated:YES];
    [[[AppController getInstance] cameraViewController] showLoginView];
}

- (void) emailMeTapped:(id) sender {
    EmailMeViewController* emailMeView = [[EmailMeViewController alloc] initWithNibName:@"EmailMeViewController" bundle:nil];
    [self.navigationController pushViewController:emailMeView animated:YES];
}

- (void) historyTapped:(id) sender {
    HistoryViewController* view = [[HistoryViewController alloc] initWithNibName:@"HistoryViewController" bundle:nil];
    [self.navigationController pushViewController:view animated:YES];
}

- (IBAction)menuTapped:(id)sender {
    NSArray *menuItems =
    @[

      [KxMenuItem menuItem:@"Company information"
                     image:nil
                    target:self
                    action:@selector(infoTapped:)],

      [KxMenuItem menuItem:@"History"
                     image:nil
                    target:self
                    action:@selector(historyTapped:)],

      [KxMenuItem menuItem:@"Email me"
                     image:nil
                    target:self
                    action:@selector(emailMeTapped:)],
      
      [KxMenuItem menuItem:@"Log out"
                     image:nil
                    target:self
                    action:@selector(logOutTapped:)]
      ];
    
    [KxMenu showMenuInView:self.view
                  fromRect:menuButton.frame
                 menuItems:menuItems];
}

- (void)infoTapped:(id)sender {
    Job* com = [[Job alloc] init];
    com.title = company.name;
    com.urlDetail = company.companyweb;
 
    if (company.companyweb != nil && ![company.companyweb isEqualToString:@""]) {
        JobDetailViewController* jobDetailViewController = [[JobDetailViewController alloc] initWithNibName:@"JobDetailViewController" bundle:nil];
        [self.navigationController pushViewController:jobDetailViewController animated:YES];
        [jobDetailViewController setJob:com];
    } else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Company information is missing." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}
@end
