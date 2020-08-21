//
//  GKVideoItemController.m
//  GKiOSApp
//
//  Created by wangws1990 on 2017/5/20.
//  Copyright © 2017 wangws1990. All rights reserved.
//

#import "GKVideoItemController.h"
#import <PLPlayerKit/PLPlayerKit.h>
@interface GKVideoItemController ()<PLPlayerDelegate>

@property (nonatomic, strong) PLPlayer *player;
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@end

@implementation GKVideoItemController
- (void)dealloc{
    [self.player stop];
    [self.player.playerView removeFromSuperview];
    self.player = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.imageV];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.imageV.superview);
    }];
}
- (void)setModel:(GKVideoModel *)model{
    if (_model != model) {
        _model = model;
        self.imageV.hidden = NO;
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:placeholders];
    }
}
- (void)play{
    if (self.model == nil) {
        return;
    }
    if (self.player.playerView) {
        [self.player.playerView removeFromSuperview];
    }
    PLPlayerOption *option = [PLPlayerOption defaultOption];
    NSString *URLString = [self.model.mp4_url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:URLString];
    self.player = [PLPlayer playerWithURL:url option:option];
    self.player.delegate = self;
    self.player.delegateQueue = dispatch_get_main_queue();
    self.player.playerView.contentMode = UIViewContentModeScaleAspectFit;
    self.player.mute = NO;
    self.player.playerView.hidden = NO;
    [self.view addSubview:self.player.playerView];
    [self.player.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.player.playerView.superview);
    }];
    self.player.loopPlay = YES;
    [self.player play];
    [self.view sendSubviewToBack:self.player.playerView];
}
- (void)stop{
    [self.player stop];
}
- (void)vtm_prepareForReuse{
    NSLog(@"vtm_prepareForReuse");
    self.imageV.alpha = 1.0f;
    self.player.playerView.hidden = YES;
}
- (UIImageView *)imageV{
    if (!_imageV ) {
        _imageV = [[UIImageView alloc] init];
        _imageV.clipsToBounds = YES;
        _imageV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageV;
}
#pragma mark PLPlayerDelegate

/**
 告知代理对象播放器状态变更
 
 @param player 调用该方法的 PLPlayer 对象
 @param state  变更之后的 PLPlayer 状态
 
 @since v1.0.0
 */
- (void)player:(nonnull PLPlayer *)player statusDidChange:(PLPlayerStatus)state{
    if (state == PLPlayerStatusReady) {
        self.imageV.alpha = 1.0f;
        [UIView animateWithDuration:0.3 animations:^{
            self.imageV.alpha = 0.0f;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }
    NSLog(@"statusDidChange %@========%lf",@(state), [player getVolume]);
    
}

/**
 告知代理对象播放器因错误停止播放
 
 @param player 调用该方法的 PLPlayer 对象
 @param error  携带播放器停止播放错误信息的 NSError 对象
 
 @since v1.0.0
 */
- (void)player:(nonnull PLPlayer *)player stoppedWithError:(nullable NSError *)error{
    
}

/**
 点播已缓冲区域
 
 @param player 调用该方法的 PLPlayer 对象
 @param timeRange  CMTime , 表示从0时开始至当前缓冲区域，单位秒。
 
 @warning 仅对点播有效
 
 @since v2.4.1
 */
- (void)player:(nonnull PLPlayer *)player loadedTimeRange:(CMTime)timeRange{
    
}



@end
