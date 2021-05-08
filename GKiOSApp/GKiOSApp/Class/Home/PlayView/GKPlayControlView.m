//
//  GKPlayControlView.m
//  GKiOSApp
//
//  Created by wangws1990 on 2021/5/7.
//  Copyright © 2021 wangws1990. All rights reserved.
//

#import "GKPlayControlView.h"
#import "GKLineLoadingView.h"
@implementation GKPlayControlView
- (void)showLoading{
    [GKLineLoadingView showLoadingInView:self.slider withLineHeight:3];
}
- (void)hiddenLoading{
    [GKLineLoadingView hideLoadingInView:self.slider];
}
- (void)current:(NSTimeInterval )current{
    self.slider.value = current;
}
- (void)duration:(NSTimeInterval )duration{
    self.slider.maximumValue = duration;
}
- (void)setShowPause:(BOOL)showPause{
    _showPause = showPause;
    self.imagePause.hidden = !_showPause;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [self loadUI];
}
- (void)loadUI{
    self.bottom.constant = 1;
    self.backgroundColor = [UIColor blackColor];
    [self.slider bringSubviewToFront:self];

    self.slider.thumbTintColor = [UIColor clearColor];
    self.slider.minimumTrackTintColor = [UIColor colorWithRGB:0xf4f4f4];
    self.slider.maximumTrackTintColor = [UIColor clearColor];
    
    self.slider.userInteractionEnabled = NO;
    self.imageIcon.layer.masksToBounds = true;
    self.imageIcon.layer.cornerRadius = 22.5;
    self.imageIcon.layer.borderWidth = 2;
    self.imageIcon.layer.borderColor = [UIColor whiteColor].CGColor;
    [self resetUI];
}
- (void)resetUI{
    self.slider.minimumValue = 0;
    self.slider.maximumValue = 10;
    self.slider.value = 0;
    self.imageV.contentMode = UIViewContentModeScaleAspectFit;
    self.showPause = NO;
    self.imageV.hidden = NO;
}
- (void)setModel:(GKVideoModel *)model{
    if (_model != model) {
        _model = model;
    }
    [self resetUI];
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    [self.imageIcon sd_setImageWithURL:[NSURL URLWithString:model.topicImg]];
    self.nickNameLab.text = model.topicName ?: @"";
    self.titleLab.text = model.title ?: @"";
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    NSTimeInterval delayTime = 0.3f;
    
    if (touch.tapCount <= 1) {
        [self performSelector:@selector(controlViewDidClick) withObject:nil afterDelay:delayTime];
    }else {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(controlViewDidClick) object:nil];
    }
}
#pragma mark - Action
- (void)controlViewDidClick {
    if ([self.delegate respondsToSelector:@selector(controlView:pause:)]) {
        [self.delegate controlView:self pause:YES];
    }
}
@end
