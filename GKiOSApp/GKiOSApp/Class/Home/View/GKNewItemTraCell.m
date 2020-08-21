//
//  GKNewItemTraCell.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/23.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKNewItemTraCell.h"

@implementation GKNewItemTraCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.focusLab.textColor = AppColor;

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(GKNewModel *)model{
    [super setModel:model];
    self.titleLab.text = model.title ?:@"";
    [self.imageFirst sd_setImageWithURL:[NSURL URLWithString:model.imgsrc] placeholderImage:placeholdersmall];
    NSString *firstUrl = model.imgextra.firstObject[@"imgsrc"];
    NSString *lastUrl = model.imgextra.lastObject[@"imgsrc"];
    [self.imageCenter sd_setImageWithURL:[NSURL URLWithString:firstUrl] placeholderImage:placeholders];
    [self.imageLast sd_setImageWithURL:[NSURL URLWithString:lastUrl] placeholderImage:placeholders];
    
    self.focusLab.text = model.replyCount;
    
    NSMutableParagraphStyle *stype = [[NSMutableParagraphStyle alloc] init];
    stype.lineSpacing = SCALEW(4.0f);
    stype.paragraphSpacing = SCALEW(4.0f);
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:model.digest ?:@"" attributes:@{NSParagraphStyleAttributeName :stype}];
    self.subTitleLab.attributedText = att;
    self.timeLab.text = model.mtime ?: @"";
}
@end
