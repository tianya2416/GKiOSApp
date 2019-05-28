//
//  GKNewItemBaseCell.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/23.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKNewItemBaseCell.h"

@implementation GKNewItemBaseCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineView.superview).offset(10);
        make.right.equalTo(self.lineView.superview).offset(-10);
        make.bottom.equalTo(self.lineView.superview);
        make.height.offset(0.6f);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithRGB:0xdddddd];
    }
    return _lineView;
}
- (void)setModel:(GKNewsModel *)model{
    _model = model;
}
@end
