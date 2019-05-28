//
//  GKNewSelectCell.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/27.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKNewSelectCell.h"

@implementation GKNewSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLab.layer.masksToBounds = YES;
    self.titleLab.layer.cornerRadius = AppRadius;
    self.titleLab.backgroundColor = [UIColor colorWithRGB:0xf6f6f6];
    // Initialization code
}

@end
