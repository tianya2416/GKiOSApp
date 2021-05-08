//
//  QNPlayer.h
//  GKiOSApp
//
//  Created by wangws1990 on 2021/5/7.
//  Copyright © 2021 wangws1990. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PLPlayerKit/PLPlayerKit.h>
#import <UIKit/UIKit.h>
#import "GKPlayControlView.h"

@class QNPlayer;

@protocol playerDeleagte <NSObject>
- (void)player:(QNPlayer *)player status:(PLPlayerStatus )status;
- (void)player:(QNPlayer *)player progress:(NSTimeInterval)progress;
- (void)player:(QNPlayer *)player cache:(NSTimeInterval )cache;
- (void)player:(QNPlayer *)player firstRender:(BOOL)firstRender;
@end
@interface QNPlayer : NSObject
@property (assign, nonatomic,readonly) PLPlayerStatus status;
@property (assign, nonatomic,readonly) NSTimeInterval duration;
@property (assign, nonatomic,readonly) NSTimeInterval current;
@property (assign, nonatomic,readonly) BOOL playing;
@property (assign, nonatomic)id <playerDeleagte>delegate;

- (void)play;
- (void)stop;
- (void)pause;
- (void)resume;
- (void)releasePlayer;

- (void)seek:(NSTimeInterval)seek;
- (void)playUrl:(NSString *)url playView:(GKPlayControlView *)playView;

@end


