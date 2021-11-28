//
//  GKSearchViewCell.m
//  GKiOSApp
//
//  Created by wangws1990 on 2017/5/15.
//  Copyright © 2017 wangws1990. All rights reserved.
//

#import "GKSearchViewCell.h"

@implementation GKSearchViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
