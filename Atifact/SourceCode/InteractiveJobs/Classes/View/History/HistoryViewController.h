//
//  HistoryViewController.h
//  VuforiaSamples
//
//  Created by VuongTC on 8/4/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopParentViewController.h"
#import "HistoryTableViewCell.h"

@interface HistoryViewController : TopParentViewController<UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *mainTable;
    NSMutableArray* dataList;
    IBOutlet HistoryTableViewCell *historyCell;
}

@end
