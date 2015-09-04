//
//  BorderView.m
//  VuforiaSamples
//
//  Created by VuongTC on 6/30/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import "BorderView.h"

@implementation BorderView

- (void) awakeFromNib {
    [super awakeFromNib];
    
    [self.layer setMasksToBounds:YES];
    self.layer.borderWidth = 1;
    self.layer.borderColor = [[UIColor colorWithRed:0 green:178/255.f blue:244/255.f alpha:1] CGColor];
    self.layer.cornerRadius = 4;
}

@end
