//
//  GKVideoHotController.m
//  GKiOSApp
//
//  Created by wangws1990 on 2017/5/30.
//  Copyright © 2017 wangws1990. All rights reserved.
//

#import "GKVideoHotController.h"
#import "GKVideoModel.h"
#import "GKNewItemAdCell.h"

#import <ZFPlayer.h>
#import <ZFPlayerController.h>
#import <ZFPlayerControlView.h>
#import <ZFAVPlayerManager.h>
//#import <ZFPlayer/ZFPlayer.h>
//#import <ZFPlayer/ZFAVPlayerManager.h>
//#import <ZFPlayer/ZFIJKPlayerManager.h>
//#import <ZFPlayer/KSMediaPlayerManager.h>

@interface GKVideoHotController ()
@property (strong, nonatomic) NSArray *listData;

@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@end

@implementation GKVideoHotController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupEmpty:self.tableView];
    [self setupRefresh:self.tableView option:ATHeaderRefresh|ATHeaderAutoRefresh];
    [self loadUI];
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat y = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    CGFloat h = CGRectGetMaxY(self.view.frame)-y;
    self.tableView.frame = CGRectMake(0, y, self.view.frame.size.width, h);
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    if (!parent) {
        self.tableView.delegate = nil;
        [self.player stopCurrentPlayingCell];
    }
}
- (void)loadUI{
    /// playerManager
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    /// player的tag值必须在cell里设置
    self.player = [ZFPlayerController playerWithScrollView:self.tableView playerManager:playerManager containerViewTag:100];
    self.player.controlView = self.controlView;
    self.player.shouldAutoPlay = NO;
    /// 1.0是完全消失的时候
    self.player.playerDisapperaPercent = 1.0;
    self.player.stopWhileNotVisible = YES;
    @weakify(self)
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        [self setNeedsStatusBarAppearanceUpdate];
        [UIViewController attemptRotationToDeviceOrientation];
        self.tableView.scrollsToTop = !isFullScreen;
    };
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        [self.player stopCurrentPlayingCell];
    };
    
    CGFloat margin = 15;
    CGFloat w = SCREEN_WIDTH/2;
    CGFloat h = w * 9/16;
    CGFloat x = SCREEN_WIDTH - w - margin;
    CGFloat y = SCREEN_HEIGHT - h - margin - TAB_BAR_ADDING - 49;
    self.player.smallFloatView.frame = CGRectMake(x, y, w, h);
    self.tableView.zf_scrollViewDidStopScrollCallback = ^(NSIndexPath * _Nonnull indexPath) {
        @strongify(self)
        if (!self.player.playingIndexPath) {
            [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
        }
    };
}
- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath scrollToTop:(BOOL)scrollToTop {
    [self.player playTheIndexPath:indexPath scrollToTop:scrollToTop];
    GKVideoHotModel *model = self.listData[indexPath.row];
    [self.controlView showTitle:model.title coverURLString:model.detail fullScreenMode:ZFFullScreenModeLandscape];
}
- (void)refreshData:(NSInteger)page{
    NSMutableArray *urls = @[].mutableCopy;
    [GKHomeNetManager videoHot:page success:^(id  _Nonnull object) {
        self.listData = [NSArray modelArrayWithClass:GKVideoHotModel.class json:object[@"itemList"]];
        [self.listData enumerateObjectsUsingBlock:^(GKVideoHotModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *URLString = [obj.playUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
             [urls addObject:[NSURL URLWithString:URLString]];
         }];
        self.player.assetURLs = urls;
        [self.tableView reloadData];
        [self endRefresh:NO];
        @weakify(self)
        [self.tableView zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
            @strongify(self)
            [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
        }];
    } failure:^(NSString * _Nonnull error) {
        [self endRefreshFailure];
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GKNewItemAdCell *cell = [GKNewItemAdCell cellForTableView:tableView indexPath:indexPath];
    cell.model = self.listData[indexPath.row];
    @weakify(self)
    [cell.playBtn setBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self)
        if (self.player.playingIndexPath != indexPath) {
            [self.player stopCurrentPlayingCell];
        }
        /// 如果没有播放，则点击进详情页会自动播放
        if (!self.player.currentPlayerManager.isPlaying) {
            [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
        }
    }];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.player.playingIndexPath != indexPath) {
        [self.player stopCurrentPlayingCell];
    }
    /// 如果没有播放，则点击进详情页会自动播放
    if (!self.player.currentPlayerManager.isPlaying) {
        [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
    }
}
#pragma mark - UIScrollViewDelegate 列表播放必须实现

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidEndDecelerating];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [scrollView zf_scrollViewDidEndDraggingWillDecelerate:decelerate];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScrollToTop];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScroll];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewWillBeginDragging];
}
- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.fastViewAnimated = YES;
        _controlView.prepareShowLoading = YES;
    }
    return _controlView;
}
- (BOOL)shouldAutorotate {
    /// 如果只是支持iOS9+ 那直接return NO即可，这里为了适配iOS8
    return self.player.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.player.isFullScreen && self.player.orientationObserver.fullScreenMode == ZFFullScreenModeLandscape) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.player.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return self.player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}
@end
