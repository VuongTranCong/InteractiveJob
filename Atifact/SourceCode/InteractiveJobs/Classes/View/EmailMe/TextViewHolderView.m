//
//  TextViewHolderView.m
//  VuforiaSamples
//
//  Created by VuongTC on 7/28/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import "TextViewHolderView.h"

@implementation TextViewHolderView

- (void) awakeFromNib {
    [self.layer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [self.layer setBorderWidth:0.5];
}

@end
