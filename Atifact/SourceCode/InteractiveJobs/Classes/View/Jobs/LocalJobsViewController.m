//
//  LocalJobsViewController.m
//  VuforiaSamples
//
//  Created by VuongTC on 8/5/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import "LocalJobsViewController.h"
#import "AppController.h"
#import "JobDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "KxMenu.h"
#import "EmailMeViewController.h"
#import "HistoryViewController.h"

@interface LocalJobsViewController ()

@end

@implementation LocalJobsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    titleLabel.text = self.company.name;
    loadingData = NO;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.company != nil && self.company.jobs.count == 0) {
        if (!loadingData) {
            loadingData = YES;
            [self showLoading:YES];
            [[AppController getInstance] loadDataOfCompany:self.company successBlock:^(NSMutableArray *jobs) {
                [self.company addJobs:jobs];
                
                if (self.company.jobs.count == 0) {
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
        
        [logoImageView sd_setImageWithURL:[NSURL URLWithString:self.company.companylogo]];
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JobTableViewCell *cell = (JobTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        [[NSBundle mainBundle] loadNibNamed:@"JobTableViewCell" owner:self options:nil];
        cell = jobCell;
        jobCell = nil;
    }
    
    Job* job = [self.company.jobs objectAtIndex:indexPath.row];
    [cell setJob:job];
    
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.company.jobs.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Job* job = [self.company.jobs objectAtIndex:indexPath.row];
    CGFloat height = [[AppController getInstance] heightForText:job.title fontIndex:RobBoldFont fontSize:23 fixedWidth:280];
    return height + 112;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Job* job = [self.company.jobs objectAtIndex:indexPath.row];
    
    JobDetailViewController* jobDetailViewController = [[JobDetailViewController alloc] initWithNibName:@"JobDetailViewController" bundle:nil];
    [self.navigationController pushViewController:jobDetailViewController animated:YES];
    [jobDetailViewController setJob:job];
}
@end
