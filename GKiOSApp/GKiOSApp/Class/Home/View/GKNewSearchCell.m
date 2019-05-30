//
//  GKNewSearchCell.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/30.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKNewSearchCell.h"

@implementation GKNewSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.commenBtn.layer.masksToBounds = YES;
    self.commenBtn.layer.cornerRadius = AppRadius;
    self.commenBtn.layer.borderWidth = 0.5f;
    self.commenBtn.layer.borderColor = AppColor.CGColor;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
