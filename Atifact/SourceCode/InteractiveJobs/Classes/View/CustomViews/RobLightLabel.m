//
//  RobLightLabel.m
//  VuforiaSamples
//
//  Created by VuongTC on 6/30/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import "RobLightLabel.h"

@implementation RobLightLabel

- (void) awakeFromNib {
    [super awakeFromNib];
    
    self.font = [UIFont fontWithName:@"Roboto-Light" size:self.font.pointSize];
}
@end