//
//  RobRegularLabel.m
//  VuforiaSamples
//
//  Created by VuongTC on 6/30/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import "RobRegularLabel.h"

@implementation RobRegularLabel

- (void) awakeFromNib {
    [super awakeFromNib];
    
    self.font = [UIFont fontWithName:@"Roboto-Regular" size:self.font.pointSize];
}

@end
