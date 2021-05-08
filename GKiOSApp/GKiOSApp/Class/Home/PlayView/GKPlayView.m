//
//  GKPlayView.m
//  GKiOSApp
//
//  Created by wangws1990 on 2021/5/7.
//  Copyright © 2021 wangws1990. All rights reserved.
//

#import "GKPlayView.h"
#import "GKPlayControlView.h"
#import "QNPlayer.h"
#import "GKDYPanGestureRecognizer.h"
#import "GKVideoModel.h"
#import "GKBallLoadingView.h"
#import "GKEmptyView.h"
@interface GKPlayView ()<playerDeleagte,UIScrollViewDelegate,UIGestureRecognizerDelegate,GKPlayControlDelegate>
@property (strong, nonatomic) GKPlayControlView *topView;
@property (strong, nonatomic) GKPlayControlView *ctrView;
@property (strong, nonatomic) GKPlayControlView *btmView;

@property (nonatomic, strong) GKDYPanGestureRecognizer  *panGesture;
@property (strong, nonatomic) QNPlayer *player;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *videos;

// 开始移动时的位置
@property (nonatomic, assign) CGFloat                   startLocationY;
@property (nonatomic, assign) CGPoint                   startLocation;
// 当前播放内容的视图
@property (nonatomic, strong) GKPlayControlView        *currentPlayView;
// 当前播放内容的索引
@property (nonatomic, assign) NSInteger                 currentPlayIndex;

@property (nonatomic, assign) NSInteger                 index;

@property (nonatomic, copy)NSString *playUrl;

@property (nonatomic, assign) BOOL userPause;

@property (nonatomic, strong) UILabel *refreshLabel;
@property (nonatomic, strong) UIView  *refreshView;
@property (nonatomic, strong) GKBallLoadingView *loadView;
@property (nonatomic ,strong) GKEmptyView *emptyView;
@end

@implementation GKPlayView
- (void)dealloc{
    self.player.delegate = nil;
}
- (void)startRefresh{
    [self.emptyView.loadView startLoading];
    self.emptyView.hidden = false;
    self.emptyView.imageV.hidden = true;
    self.emptyView.titleLab.hidden = true;
}
- (void)finishRefresh{
    [self.loadView stopLoading];
    [self.emptyView.loadView stopLoading];
    self.emptyView.hidden = self.videos.count > 0;
    self.emptyView.imageV.hidden = self.emptyView.hidden;
    self.emptyView.titleLab.hidden = self.emptyView.hidden;
}
- (void)setModels:(NSArray *)models index:(NSInteger)index {
    
    [self.videos removeAllObjects];
    [self.videos addObjectsFromArray:models];
    [self finishRefresh];
    self.index = index;
    self.currentPlayIndex = index;
    if (models.count == 0){
        self.topView.hidden = YES;
        self.ctrView.hidden = YES;
        self.btmView.hidden = YES;
    } 
    else if (models.count == 1) {
        self.topView.hidden = NO;
        self.ctrView.hidden = YES;
        self.btmView.hidden = YES;
        
        self.scrollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT);
        self.topView.model = self.videos.firstObject;
        self.scrollView.contentOffset = CGPointZero;
        [self playVideoFrom:self.topView];
    }else if (models.count == 2) {
        self.topView.hidden = NO;
        self.ctrView.hidden = NO;
        self.btmView.hidden = YES;
        self.scrollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 2);
        self.topView.model  = self.videos.firstObject;
        self.ctrView.model  = self.videos.lastObject;
        if (index == 1) {
            self.scrollView.contentOffset = CGPointMake(0, SCREEN_HEIGHT);
            [self playVideoFrom:self.ctrView];
        }else {
            self.scrollView.contentOffset = CGPointZero;
            [self playVideoFrom:self.topView];
        }
    }else {
        self.topView.hidden = NO;
        self.ctrView.hidden = NO;
        self.btmView.hidden = NO;
        self.scrollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 3);
        if (index == 0) {   // 如果是第一个，则显示上视图，且预加载中下视图
            self.topView.model = self.videos[index];
            self.ctrView.model = self.videos[index + 1];
            self.btmView.model = self.videos[index + 2];
            self.scrollView.contentOffset = CGPointZero;
            [self playVideoFrom:self.topView];
        }else if (index == models.count - 1) { // 如果是最后一个，则显示最后视图，且预加载前两个
            self.btmView.model = self.videos[index];
            self.ctrView.model = self.videos[index - 1];
            self.topView.model = self.videos[index - 2];
            self.scrollView.contentOffset = CGPointMake(0, SCREEN_HEIGHT * 2);
            [self playVideoFrom:self.btmView];
        }else { // 显示中间，播放中间，预加载上下
            self.ctrView.model = self.videos[index];
            self.topView.model = self.videos[index - 1];
            self.btmView.model = self.videos[index + 1];
            self.scrollView.contentOffset = CGPointMake(0, SCREEN_HEIGHT);
            [self playVideoFrom:self.ctrView];
        }
    }
}
- (void)playVideoFrom:(GKPlayControlView *)currentView{
    self.currentPlayView.delegate = nil;
    [self destoryPlayer];
    self.currentPlayView = currentView;
    self.currentPlayView.delegate = self;
    self.playUrl = currentView.model.mp4_url;
    self.currentPlayIndex = [self indexOfModel:currentView.model];
    [self.player playUrl:currentView.model.mp4_url playView:currentView];
}
- (NSInteger)indexOfModel:(GKVideoModel *)model {
    __block NSInteger index = 0;
    [self.videos enumerateObjectsUsingBlock:^(GKVideoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([model.mp4_url isEqualToString:obj.mp4_url]) {
            index = idx;
            *stop = YES;
        }
    }];
    return index;
}
- (void)setMoreDatas:(NSArray *)models{
    NSRange range = NSMakeRange(0, 10);
    if (self.videos.count > 100) {
        [self.videos removeObjectsInRange:range];
    }
    [self.videos addObjectsFromArray:models];
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self loadUI];
    }
    return self;
}
- (instancetype) initWithCoder:(NSCoder *)coder{
    if (self = [super initWithCoder:coder]) {
        [self loadUI];
    }
    return self;
}
- (void)loadUI{
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView.superview);
    }];
    [self addSubview:self.refreshView];
    [self.refreshView addSubview:self.loadView];
    [self.loadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.loadView.superview);
    }];
    
    [self addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(200);
        make.center.equalTo(self.emptyView.superview);
    }];
    [self.scrollView addGestureRecognizer:self.panGesture];
    [self startRefresh];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = self.scrollView.frame.size.width;
    CGFloat height = self.scrollView.frame.size.height;
    [self.topView setFrame:CGRectMake(0, 0, width, height)];
    [self.ctrView setFrame:CGRectMake(0, height, width, height)];
    [self.btmView setFrame:CGRectMake(0, height * 2, width, height)];
}
- (void)viewDidAppear{
    [self resume];
}
- (void)viewDidDisappear{
    [self pause];
}
- (void)pause{
    [self.player pause];
}
- (void)resume{
    if (self.userPause  == NO){
        [self.player resume];
    }
}
- (void)destoryPlayer{
    [self.player releasePlayer];
}
- (GKPlayControlView *)topView{
    if (!_topView) {
        _topView = [GKPlayControlView instanceView];
        _topView.hidden = true;
    }
    return  _topView;
}
- (GKPlayControlView *)ctrView{
    if (!_ctrView) {
        _ctrView = [GKPlayControlView instanceView];
        _ctrView.hidden = true;
    }
    return  _ctrView;
}
- (GKPlayControlView *)btmView{
    if (!_btmView) {
        _btmView = [GKPlayControlView instanceView];
        _btmView.hidden = true;
    }
    return  _btmView;
}
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        [_scrollView setScrollsToTop:NO];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        [_scrollView addSubview:self.topView];
        [_scrollView addSubview:self.ctrView];
        [_scrollView addSubview:self.btmView];
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
    return _scrollView;
}
- (NSMutableArray *)videos{
    if (!_videos) {
        _videos = [[NSMutableArray alloc] init];
    }
    return _videos;
}
- (QNPlayer *)player{
    if (!_player) {
        _player = [[QNPlayer alloc] init];
        _player.delegate = self;
    }
    return  _player;
}
- (GKDYPanGestureRecognizer *)panGesture {
    if (!_panGesture) {
        _panGesture = [[GKDYPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        _panGesture.delegate = self;
        _panGesture.direction = GKDYPanGestureRecognizerDirectionVertical;
    }
    return _panGesture;
}
- (UIView *)refreshView{
    if (!_refreshView) {
        _refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HIGHT, SCREEN_WIDTH, 30)];
        _refreshView.backgroundColor = [UIColor clearColor];
        _refreshView.alpha = 0;
    }
    return _refreshView;
}
- (UILabel *)refreshLabel{
    if (!_refreshLabel) {
        _refreshLabel = [[UILabel alloc] init];
        _refreshLabel.textColor = [UIColor whiteColor];
        _refreshLabel.font = [UIFont systemFontOfSize:16];
        _refreshLabel.text = @"下拉刷新内容";
        _refreshLabel.textAlignment = NSTextAlignmentCenter;
        _refreshLabel.numberOfLines = 0;
        _refreshLabel.alpha = 0;
        [self.refreshView addSubview:self.refreshLabel];
        [self.refreshLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.refreshLabel.superview);
        }];
    }
    return _refreshLabel;
}
- (GKBallLoadingView *)loadView{
    if (!_loadView) {
        _loadView = [[GKBallLoadingView alloc] init];
    }
    return _loadView;
}
- (GKEmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[GKEmptyView alloc] init];
        _emptyView.hidden = YES;
    }
    return  _emptyView;;
}
#pragma mark playerDeleagte
- (void)player:(nonnull QNPlayer *)player cache:(NSTimeInterval)cache {
    
}

- (void)player:(nonnull QNPlayer *)player firstRender:(BOOL)firstRender {
    [self.currentPlayView duration:player.duration];
    [self.currentPlayView hiddenLoading];
    self.currentPlayView.imageV.hidden = YES;
}

- (void)player:(nonnull QNPlayer *)player progress:(NSTimeInterval)progress {
    [self.currentPlayView current:progress];
}

- (void)player:(nonnull QNPlayer *)player status:(PLPlayerStatus)status {
    switch (status) {
        case PLPlayerStatusPreparing:
            [self.currentPlayView showLoading];
            self.currentPlayView.showPause = NO;
            break;
        case PLPlayerStatusPaused:
            self.currentPlayView.showPause = true;
            break;;
        case PLPlayerStatusPlaying:
            self.currentPlayView.showPause = NO;
            break;;
        default:
            break;
    }
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.currentPlayIndex == 0 && scrollView.contentOffset.y < 0) {
        self.scrollView.contentOffset = CGPointZero;
    }

    // 小于等于三个，不用处理
    if (self.videos.count <= 3){
        return;
    }
    if (scrollView.contentOffset.y == SCREEN_HEIGHT) {
        if (self.index == 0) {
            self.index = self.index + 1;
        }else if (self.index == 1) {
            self.index = self.index - 1;
        }
        return;
    }
    // 上滑到第一个
    if (self.index == 0 && scrollView.contentOffset.y <= SCREEN_HEIGHT) {
        return;
    }
    // 下滑到最后一个
    if (self.index > 0 && self.index == self.videos.count - 1 && scrollView.contentOffset.y > SCREEN_HEIGHT) {
        return;
    }
    // 判断是从中间视图上滑还是下滑
    if (scrollView.contentOffset.y >= 2 * SCREEN_HEIGHT) {  // 上滑
        [self destoryPlayer];
        if (self.index == 0) {
            self.index += 2;
            scrollView.contentOffset = CGPointMake(0, SCREEN_HEIGHT);
            
            self.topView.model = self.ctrView.model;
            self.ctrView.model = self.btmView.model;
            
        }else {
            self.index += 1;
            
            if (self.index == self.videos.count - 1) {
                self.ctrView.model = self.videos[self.index - 1];
            }else {
                scrollView.contentOffset = CGPointMake(0, SCREEN_HEIGHT);
                
                self.topView.model = self.ctrView.model;
                self.ctrView.model = self.btmView.model;
            }
        }
        if (self.index < self.videos.count - 1 && self.videos.count >= 3) {
            self.btmView.model = self.videos[self.index + 1];
        }
    }else if (scrollView.contentOffset.y <= 0) { // 下滑
        [self destoryPlayer];  // 在这里移除播放，解决闪动的bug
        if (self.index == 1) {
            self.topView.model = self.videos[self.index - 1];
            self.ctrView.model = self.videos[self.index];
            self.btmView.model = self.videos[self.index + 1];
            self.index -= 1;
        }else {
            if (self.index == self.videos.count - 1) {
                self.index -=2;
            }else {
                self.index -=1;
            }
            scrollView.contentOffset = CGPointMake(0, SCREEN_HEIGHT);
            
            self.btmView.model = self.ctrView.model;
            self.ctrView.model = self.topView.model;
            
            if (self.index > 0) {
                self.topView.model = self.videos[self.index - 1];
            }
        }
    }
    // 自动刷新，如果想要去掉自动刷新功能，去掉下面代码即可
    if (scrollView.contentOffset.y == SCREEN_HEIGHT) {
        // 播放到倒数第二个时，请求更多内容
        if (self.currentPlayIndex == self.videos.count - 3) {
            [self refreshMore:2];
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"currentIndex : %@ %@",@(self.currentPlayIndex),@(self.index));
    if (scrollView.contentOffset.y == 0) {
        if (self.playUrl == self.topView.model.mp4_url) return;
        [self playVideoFrom:self.topView];
        if (self.index > 0 && self.videos.count > self.index + 1) {
            self.ctrView.model = self.videos[self.index + 1];
        }
        if (self.index > 0 && self.videos.count > self.index + 2) {
            self.btmView.model = self.videos[self.index + 2];
        }
    }else if (scrollView.contentOffset.y == SCREEN_HEIGHT) {
        if (self.playUrl == self.ctrView.model.mp4_url) return;
        [self playVideoFrom:self.ctrView];
        if (self.index > 0 && self.videos.count > self.index) {
            self.topView.model = self.videos[self.index - 1];
        }
        if (self.index > 0 && self.videos.count > self.index + 1) {
            self.btmView.model = self.videos[self.index + 1];
        }
    }else if (scrollView.contentOffset.y == 2 * SCREEN_HEIGHT) {
        if (self.playUrl == self.btmView.model.mp4_url) return;
        [self playVideoFrom:self.btmView];
        if (self.index > 0 && self.videos.count > self.index - 1) {
            self.ctrView.model = self.videos[self.index - 1];
        }
        if (self.index > 0 && self.videos.count > self.index - 2) {
            self.topView.model = self.videos[self.index - 2];
        }
    }
}
#pragma mark - Gesture
- (void)handlePanGesture:(GKDYPanGestureRecognizer *)panGesture {
    if (self.currentPlayIndex == 0) {
        CGPoint location = [panGesture locationInView:panGesture.view];
        switch (panGesture.state) {
            case UIGestureRecognizerStateBegan: {
                self.startLocationY = location.y;
            }break;
            case UIGestureRecognizerStateChanged: {
                if (panGesture.direction == GKDYPanGestureRecognizerDirectionVertical) {
                    // 这里取整是解决上滑时可能出现的distance > 0的情况
                    CGFloat distance = ceil(location.y) - ceil(self.startLocationY);
                    if (distance > 0) { // 只要distance>0且没松手 就认为是下滑
                        self.scrollView.panGestureRecognizer.enabled = NO;
                    }
                    if (self.scrollView.panGestureRecognizer.enabled == NO) {
                        [self playView:self finish:NO];
                    }
                }
            }break;
            case UIGestureRecognizerStateFailed:
            case UIGestureRecognizerStateCancelled:
            case UIGestureRecognizerStateEnded: {
                if (self.scrollView.panGestureRecognizer.enabled == NO) {
                    [self playView:self finish:YES];
                    self.scrollView.panGestureRecognizer.enabled = YES;
                }
            }break;
            default:
                break;
        }
        [panGesture setTranslation:CGPointZero inView:panGesture.view];
    }
}
// 允许多个手势响应
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
#pragma mark GKPlayControlDelegate
- (void)controlView:(GKPlayControlView *)controlView pause:(BOOL)pause{
    self.userPause = NO;
    if (self.player.duration == 0) {
        [self.player play];
    }else{
        if (self.player.playing) {
            self.userPause = YES;
            [self.player pause];
        }else{
            [self.player resume];
        }
    }
}
//开始加载数据
- (void)playView:(GKPlayView *)playView finish:(BOOL)finish{
    if (finish) {
        [UIView animateWithDuration:0.25
                         animations:^{
                    self.refreshLabel.alpha  = 0;
                } completion:^(BOOL finished) {
                    if (finish){
                        self.videos.count == 0 ? [self startRefresh] : [self.loadView startLoading];
                        [self refreshMore:1];
                    }
                }];
    }else{
        self.refreshLabel.alpha = 1;
        self.refreshView.alpha = 1;
    }
}
- (void)refreshMore:(NSInteger)page{
    if ([self.delegate respondsToSelector:@selector(playView:page:)]) {
        [self.delegate playView:self page:page];
    }
}
@end
