//
//  RobRegularButton.m
//  VuforiaSamples
//
//  Created by VuongTC on 7/2/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import "RobRegularButton.h"

@implementation RobRegularButton

- (void) awakeFromNib {
    [super awakeFromNib];
    
    self.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:self.titleLabel.font.pointSize];
}

@end
