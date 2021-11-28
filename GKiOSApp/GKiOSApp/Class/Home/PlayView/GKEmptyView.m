//
//  GKEmptyView.m
//  GKiOSApp
//
//  Created by wangws1990 on 2021/5/7.
//  Copyright © 2021 wangws1990. All rights reserved.
//

#import "GKEmptyView.h"

@implementation GKEmptyView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.titleLab];
        [self addSubview:self.imageV];
        [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.imageV.superview);
            make.width.height.offset(80);
        }];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.titleLab.superview);
            make.top.equalTo(self.imageV.mas_bottom).offset(20);
        }];
        [self addSubview:self.loadView];
        [self.loadView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.loadView.superview);
        }];
    }
    return self;
}
- (GKBallLoadingView *)loadView{
    if (!_loadView) {
        _loadView = [[GKBallLoadingView alloc] init];
    }
    return _loadView;
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont systemFontOfSize:16];
        _titleLab.textColor = Appxf8f8f8;
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.text = @"数据加载失败,请下拉重试";
    }
    return _titleLab;
}
- (UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc] init];
        _imageV.image = [UIImage imageNamed:@"icon_data_empty"];
    }
    return _imageV;
}
@end
