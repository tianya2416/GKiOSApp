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
    [self.watchBtn setTitleColor:AppColor forState:UIControlStateNormal];
    self.watchBtn.userInteractionEnabled = NO;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(GKNewsModel *)model{
    [super setModel:model];
    self.titleLab.text = model.title ?:@"";
    self.subTitleLab.text = model.digest ?:@"";
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.imgsrc] completed:nil];
    self.timeLab.text = model.mtime ?:@"";
    [self.watchBtn setTitle:model.replyCount forState:UIControlStateNormal];
}
@end
