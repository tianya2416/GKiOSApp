//
//  QNPlayer.m
//  GKiOSApp
//
//  Created by wangws1990 on 2021/5/7.
//  Copyright © 2021 wangws1990. All rights reserved.
//

#import "QNPlayer.h"
#import <PLPlayerKit/PLPlayerKit.h>

@interface QNPlayer ()<PLPlayerDelegate>
@property (assign, nonatomic) PLPlayerStatus status;
@property (assign, nonatomic) NSTimeInterval duration;
@property (assign, nonatomic) NSTimeInterval current;
@property (strong, nonatomic) PLPlayer *player;
@property (strong, nonatomic) CADisplayLink *displayLink;
@end

@implementation QNPlayer
- (void)playUrl:(NSString *)url playView:(GKPlayControlView *)playView{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self releasePlayer];
        self.player = [[PLPlayer alloc] initWithURL:[NSURL URLWithString:url] option:[PLPlayerOption defaultOption]];
        self.player.delegate = self;
        self.player.delegateQueue = dispatch_get_main_queue();
        UIView *contentView = self.player.playerView;
        if (contentView) {
            [playView insertSubview:contentView atIndex:0];
            [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(contentView.superview);
            }];
        }
        self.player.playerView.contentMode = playView.imageV.contentMode;
        self.player.loopPlay = true;
        self.player.backgroundPlayEnable = NO;
        [self play];
    });
}
- (void)seek:(NSTimeInterval)seek{
    [self.player seekTo:CMTimeMake(seek, 1)];
    
}
- (void)setStatus:(PLPlayerStatus)status{
    if (_status != status) {
        _status = status;
        if ([self.delegate respondsToSelector:@selector(player:status:)]) {
            [self.delegate player:self status:_status];
        }
    }
}
- (NSTimeInterval )duration{
    return CMTimeGetSeconds(self.player.totalDuration) ;
}
- (NSTimeInterval)current{
    return CMTimeGetSeconds(self.player.currentTime) ;
}
- (BOOL)playing{
    return self.player.playing;
}
- (void)play{
    [self startPlayLink];
    [self.player play];
}
- (void)stop{
    [self stopPlayLink];
    [self.player stop];
}
- (void)resume{
    [self startPlayLink];
    if (self.playing == NO){
        [self.player resume];
    }
}
- (void)pause{
    [self stopPlayLink];
    if (self.playing) {
        [self.player pause];
    }
}
- (void)releasePlayer{
    [self stopPlayLink];
    if (self.player.playerView.superview) {
        [self.player.playerView removeFromSuperview];
    }
}
- (void)startPlayLink{
    [self stopPlayLink];
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction)];
    if (@available(iOS 10.0, *)) {
        self.displayLink.preferredFramesPerSecond = 5;
    } else {
        self.displayLink.frameInterval = 5;
    }
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}
- (void)stopPlayLink{
    if (self.displayLink) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}
- (void)displayLinkAction{
    if ([self.delegate respondsToSelector:@selector(player:progress:)]) {
        [self.delegate player:self progress:self.current];
    }
}
#pragma mark PLPlayerDelegate
- (void)player:(nonnull PLPlayer *)player statusDidChange:(PLPlayerStatus)state{
    self.status = state;
}
- (void)player:(PLPlayer *)player stoppedWithError:(NSError *)error{
    self.status = PLPlayerStatusError;
}
- (void)player:(PLPlayer *)player firstRender:(PLPlayerFirstRenderType)firstRenderType{
    if ([self.delegate respondsToSelector:@selector(player:firstRender:)]) {
        [self.delegate player:self firstRender:firstRenderType == PLPlayerFirstRenderTypeVideo];
    }
}
- (void)player:(PLPlayer *)player loadedTimeRange:(CMTime)timeRange{
    NSTimeInterval time = CMTimeGetSeconds(timeRange);
    if ([self.delegate respondsToSelector:@selector(player:cache:)]) {
        [self.delegate player:self cache:time];
    }
}
@end
