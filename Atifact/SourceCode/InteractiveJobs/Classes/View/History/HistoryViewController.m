//
//  HistoryViewController.m
//  VuforiaSamples
//
//  Created by VuongTC on 8/4/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import "HistoryViewController.h"
#import "AppController.h"
#import "UIImageView+WebCache.h"
#import "LocalJobsViewController.h"

@interface HistoryViewController ()

@end

@implementation HistoryViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    dataList = [[NSMutableArray alloc] init];
    NSArray* localNameList = [[[AppController getInstance] historyList] componentsSeparatedByString:@";"];
    for (int i = (int)localNameList.count - 1; i >= 0; i--) {
        NSString* vuforiaName = [localNameList objectAtIndex:i];
        for (Company* com in [[AppController getInstance] companyList]) {
            if ([vuforiaName containsString:com.vuforia]) {
                [dataList addObject:com];
                break;
            }
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HistoryTableViewCell* cell = (HistoryTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        [[NSBundle mainBundle] loadNibNamed:@"HistoryTableViewCell" owner:self options:nil];
        cell = historyCell;
        historyCell = nil;
    }
    Company* com = [dataList objectAtIndex:indexPath.row];
    cell.nameLabel.text = com.name;
    [cell.logoImageView sd_setImageWithURL:[NSURL URLWithString:com.companylogo]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LocalJobsViewController* view = [[LocalJobsViewController alloc] initWithNibName:@"LocalJobsViewController" bundle:nil];
    Company* com = [dataList objectAtIndex:indexPath.row];
    view.company = com;
    [self.navigationController pushViewController:view animated:YES];
}

@end
