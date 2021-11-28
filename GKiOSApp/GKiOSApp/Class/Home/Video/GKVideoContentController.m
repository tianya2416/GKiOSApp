//
//  GKVideoContentController.m
//  GKiOSApp
//
//  Created by wangws1990 on 2017/5/20.
//  Copyright © 2017 wangws1990. All rights reserved.
//

#import "GKVideoContentController.h"
#import "GKVideoItemController.h"
@interface GKVideoContentController ()<VTMagicViewDataSource,VTMagicViewDelegate>
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSArray <GKVideoModel *>*listDatas;
@property (strong, nonatomic) VTMagicController * magicController;

@property (strong, nonatomic) NSMutableArray *listTitles;
@property (strong, nonatomic) UIButton *backBtn;
@end

@implementation GKVideoContentController
+ (instancetype)vcWithListDatas:(NSArray <GKVideoModel *>*)listData index:(NSInteger)index{
    GKVideoContentController *vc = [[[self class] alloc] init];
    vc.index = index;
    vc.listDatas = listData;
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
    [self loadData];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)loadUI{
    self.fd_prefersNavigationBarHidden = YES;
    [self addChildViewController:self.magicController];
    [self.view addSubview:self.magicController.view];
    [self.view setNeedsUpdateConstraints];
    UIView * magicView = self.magicController.view;
    [magicView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self.view addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.equalTo(self.backBtn.superview).offset(STATUS_BAR_HIGHT);
        make.width.height.offset(44);
    }];
}
- (void)loadData{
    self.listTitles = @[].mutableCopy;
    [self.listDatas enumerateObjectsUsingBlock:^(GKVideoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.listTitles addObject:obj.title];
    }];
    [self.magicController.magicView reloadDataToPage:self.index];
}
#pragma mark VTMagicViewDataSource,VTMagicViewDelegate
/**
 *  获取所有菜单名，数组中存放字符串类型对象
 *
 *  @param magicView self
 *
 *  @return header数组
 */
- (NSArray<__kindof NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView
{
    return self.listTitles;
}
/**
 *  根据itemIndex加载对应的menuItem
 *
 *  @param magicView self
 *  @param itemIndex 需要加载的菜单索引
 *
 *  @return 当前索引对应的菜单按钮
 */
- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex
{
    
    static NSString *itemIdentifier = @"com.video.btn.itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return menuItem;
}
/**
 *  根据pageIndex加载对应的页面控制器
 *
 *  @param magicView self
 *  @param pageIndex 需要加载的页面索引
 *
 *  @return 页面控制器
 */
- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex
{
    static NSString *itemIdentifier = @"com.video.item.itemIdentifier";
    GKVideoItemController *vc = [magicView dequeueReusablePageWithIdentifier:itemIdentifier];
    if (!vc) {
        vc = [[GKVideoItemController alloc] init];
    }
    vc.model = self.listDatas[pageIndex];
    return vc;
}
- (void)magicView:(VTMagicView *)magicView viewDidAppear:(__kindof GKVideoItemController *)viewController atPage:(NSUInteger)pageIndex{
    [viewController play];
}
- (void)magicView:(VTMagicView *)magicView viewDidDisappear:(__kindof GKVideoItemController *)viewController atPage:(NSUInteger)pageIndex{
    [viewController stop];
}
-(VTMagicController *)magicController {
    
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.magicView.separatorHeight = 0.0f;
        _magicController.magicView.backgroundColor = [UIColor whiteColor];
        _magicController.magicView.navigationInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _magicController.magicView.navigationColor = AppColor;
        _magicController.magicView.switchStyle = VTSwitchStyleDefault;
        
        _magicController.magicView.sliderColor = [UIColor colorWithRGB:0xffffff];
        
        _magicController.magicView.layoutStyle = VTLayoutStyleDefault;
        _magicController.magicView.navigationHeight = 0.0f;
        
        _magicController.magicView.againstStatusBar = NO;
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
        _magicController.magicView.separatorColor = [UIColor colorWithRGB:0xffffff];
        _magicController.magicView.needPreloading = true;
        _magicController.magicView.bounces = false;
        
    }
    return _magicController;
}
- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"player_back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

@end
