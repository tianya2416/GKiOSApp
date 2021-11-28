//
//  GKNewItemTableViewCell.m
//  GKiOSApp
//
//  Created by wangws1990 on 2017/5/16.
//  Copyright © 2017 wangws1990. All rights reserved.
//

#import "GKNewItemTableViewCell.h"

@implementation GKNewItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.height.constant = SCALEW(80);
    self.top.constant = 8;
    self.bottom.constant = 6;
    [self.watchBtn setTitleColor:AppColor forState:UIControlStateNormal];
    self.watchBtn.userInteractionEnabled = NO;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(GKNewModel *)model{
    [super setModel:model];
    self.titleLab.text = model.title ?:@"";

    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.imgsrc] placeholderImage:placeholdersmall];
    self.timeLab.text = model.mtime ?:@"";
    [self.watchBtn setTitle:model.replyCount forState:UIControlStateNormal];
    
    NSMutableParagraphStyle *stype = [[NSMutableParagraphStyle alloc] init];
    stype.lineSpacing = SCALEW(4.0f);
    stype.paragraphSpacing = SCALEW(4.0f);
    [self.watchBtn setTitle:model.replyCount forState:UIControlStateNormal];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:model.digest ?:@"" attributes:@{NSParagraphStyleAttributeName :stype}];
    self.subTitleLab.attributedText = att;
}
@end
