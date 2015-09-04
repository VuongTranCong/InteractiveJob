//
//  LeftMenuViewController.m
//  VuforiaSamples
//
//  Created by VuongTC on 7/1/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "SampleAppMenu.h"
#import "SampleAppSlidingMenuController.h"
#import "AppController.h"

@interface LeftMenuViewController ()
@end

@implementation LeftMenuViewController

@synthesize slidingMenuViewController=_slidingMenuViewController;

- (void) viewDidLoad {
    [super viewDidLoad];
    [[AppController getInstance] setLeftMenuViewController:self];
    

    contentView.hidden = YES;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JobSimpleTableViewCell *cell = (JobSimpleTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        [[NSBundle mainBundle] loadNibNamed:@"JobSimpleTableViewCell" owner:self options:nil];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    Job* job = [company.jobs objectAtIndex:indexPath.row];
    
    //    JobDetailViewController* jobDetailViewController = [[JobDetailViewController alloc] initWithNibName:@"JobDetailViewController" bundle:nil];
    //    [self.navigationController pushViewController:jobDetailViewController animated:NO];
    //    [jobDetailViewController setJob:job];
}


- (IBAction)menuTapped:(id)sender {
    NSLog(@"tappMenu");
}

- (void) updateData {
    contentView.hidden = NO;
    guideLabel.hidden = YES;
    company = [[AppController getInstance] currentCompany];
     if (company != nil && company.jobs.count == 0) {
        if (!loadingData) {
            loadingData = YES;
            [[AppController getInstance] loadDataOfCompany:company successBlock:^(NSMutableArray *jobs) {
                [company addJobs:jobs];
                [mainTable reloadData];
                [self showLoading:NO];
                loadingData = NO;
                NSLog(@"done load company data");
                [self updateView];
            }];
        }
    }

//    [self performSelector:@selector(updateView) withObject:nil afterDelay:0.1];
}

- (void) updateView {
    nameLabel.text = company.name;
    CGRect f = contentView.frame;
//    f.origin.x = 200;
    nameLabel.frame = f;

    guideLabel.frame = f;
    //    [UIView animateWithDuration:0.2 animations:^{
//        CGRect frame = contentView.frame;
//        frame.origin.y = self.view.frame.size.height - frame.size.height - 10;
        contentView.frame = f;
    
    [self.view layoutIfNeeded];
//    }];
}
@end

