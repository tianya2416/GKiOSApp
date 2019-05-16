//
//  GKNewItemTableViewCell.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/16.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKNewItemTableViewCell.h"

@implementation GKNewItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(GKNewsModel *)model{
    _model = model;
    self.titleLab.text = model.title ?:@"";
    self.subTitleLab.text = model.desc ?:@"";
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.litpic] completed:nil];
    self.timeLab.text = model.pubDate ?:@"";
}
@end
