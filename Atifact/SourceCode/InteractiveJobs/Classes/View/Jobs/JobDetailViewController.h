//
//  JobDetailViewController.h
//  VuforiaSamples
//
//  Created by VuongTC on 6/30/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RobBoldLabel.h"
#import "Job.h"
#import "TopParentViewController.h"

@interface JobDetailViewController : TopParentViewController <UIWebViewDelegate> {
    IBOutlet UIWebView *webView;
    Job* job;
}

- (void) setJob:(Job*) data;

@end
