//
//  GKPlayView.h
//  GKiOSApp
//
//  Created by wangws1990 on 2021/5/7.
//  Copyright © 2021 wangws1990. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GKPlayView;
NS_ASSUME_NONNULL_BEGIN
@protocol GKPlayDelegate <NSObject>
//page = 1 刷新
//page > 1 加载更多
- (void)playView:(GKPlayView *)playView page:(NSInteger)page;
@end
@interface GKPlayView : UIView

- (instancetype)initWithHeight:(CGFloat)height delegate:(id<GKPlayDelegate>)delegate;

//下拉刷新或者首次加载时候使用
- (void)setModels:(NSArray *)models index:(NSInteger)index;
//加载更多时候数据赋值
- (void)setMoreDatas:(NSArray *)models;

- (void)viewDidAppear;
- (void)viewDidDisappear;
- (void)destoryPlayer;

@end

NS_ASSUME_NONNULL_END
