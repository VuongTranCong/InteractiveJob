//
//  RobRegularTextField.m
//  VuforiaSamples
//
//  Created by VuongTC on 7/2/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import "RobRegularTextField.h"

@implementation RobRegularTextField

- (void) awakeFromNib {
    [super awakeFromNib];
    
    self.font = [UIFont fontWithName:@"Roboto-Regular" size:self.font.pointSize];
}

@end
