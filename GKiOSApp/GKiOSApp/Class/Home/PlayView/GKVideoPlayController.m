//
//  GKVideoPlayController.m
//  GKiOSApp
//
//  Created by wangws1990 on 2021/5/7.
//  Copyright © 2021 wangws1990. All rights reserved.
//

#import "GKVideoPlayController.h"
#import "GKPlayView.h"
#import "GKVideoModel.h"
@interface GKVideoPlayController ()<GKPlayDelegate>
@property (strong, nonatomic) GKPlayView *playView;
@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) BOOL haveNextPage;
@property (copy, nonatomic) NSString *sId;
@end

@implementation GKVideoPlayController
+ (instancetype)vcWithSid:(NSString *)sId{
    GKVideoPlayController *vc = [[[self class] alloc] init];
    vc.sId = sId;
    return vc;
}
- (void)dealloc{
    [self.playView destoryPlayer];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.playView];
    [self.playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.playView.superview);
    }];
    [self loadData];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.playView viewDidAppear];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.playView viewDidDisappear];
}
- (void)loadData{
    self.page = 1;
    [self playView:self.playView page:self.page];
}
- (GKPlayView *)playView{
    if (!_playView) {
        CGFloat height = iPhone_X ? (SCREEN_HEIGHT - 49 - TAB_BAR_ADDING) : SCREEN_HEIGHT;
        _playView = [[GKPlayView alloc] initWithHeight:height delegate:self];
    }
    return _playView;
}
- (void)playView:(GKPlayView *)playView page:(NSInteger)page{
    if (self.sId.length == 0) {
        return;
    }
    if (page > 1 && !self.haveNextPage) {
        return;
    }
    NSInteger size = 10;
    if (page == 1) {
        self.page = page;
    }
    [GKHomeNetManager videoList:self.sId page:self.page size:size success:^(id _Nonnull object) {
        NSArray *datas = [NSArray modelArrayWithClass:GKVideoModel.class json:object[self.sId]];
        self.haveNextPage = datas.count >= size;
        if (datas.count >= size) {
            self.page = self.page + 1;
        }
        if (page == 1) {
            [self.playView setModels:datas index:0];
        }else{
            [self.playView setMoreDatas:datas];
        }
    } failure:^(NSString * _Nonnull error) {
        [self.playView setModels:@[] index:0];
    }];
}
@end
