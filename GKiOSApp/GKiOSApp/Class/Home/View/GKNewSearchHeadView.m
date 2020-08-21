//
//  GKNewSearchHeadView.m
//  GKiOSApp
//
//  Created by wangws1990 on 2017/5/30.
//  Copyright © 2017 wangws1990. All rights reserved.
//

#import "GKNewSearchHeadView.h"

@implementation GKNewSearchHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self loadUI];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self loadUI];
    }
    return self;
}
- (void)loadUI{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleLab];
    [self addSubview:self.deleteBtn];
    [self addSubview:self.lineView];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab.superview).offset(8);
        make.centerY.equalTo(self.titleLab.superview);
        
    }];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.deleteBtn.superview).offset(-8);
        make.centerY.equalTo(self.titleLab);
        make.left.equalTo(self.titleLab.mas_right).offset(10);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.lineView.superview);
        make.bottom.equalTo(self.lineView.superview);
        make.height.offset(0.6f);
    }];
    [self.titleLab setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.deleteBtn setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont systemFontOfSize:13];
        _titleLab.textColor = AppColor;
    }
    return _titleLab;
}
- (UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage imageNamed:@"icon_music_clear"] forState:UIControlStateNormal];
    }
    return _deleteBtn;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        [_lineView setBackgroundColor:Appxdddddd];
    }
    return _lineView;
}
@end
