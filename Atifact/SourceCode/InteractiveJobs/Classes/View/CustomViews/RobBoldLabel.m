//
//  RobBoldLabel.m
//  VuforiaSamples
//
//  Created by VuongTC on 6/30/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import "RobBoldLabel.h"

@implementation RobBoldLabel

- (void) awakeFromNib {
    [super awakeFromNib];
    
    self.font = [UIFont fontWithName:@"Roboto-Bold" size:self.font.pointSize];
}

@end