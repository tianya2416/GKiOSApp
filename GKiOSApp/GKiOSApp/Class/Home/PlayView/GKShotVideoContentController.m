//
//  GKShotVideoContentController.m
//  GKiOSApp
//
//  Created by wangws1990 on 2021/5/8.
//  Copyright © 2021 wangws1990. All rights reserved.
//

#import "GKShotVideoContentController.h"
#import "GKVideoPlayController.h"
#import "GKVideoModel.h"
#import "YNPageScrollMenuView.h"
#import "YNPageConfigration.h"
@interface GKShotVideoContentController ()<VTMagicViewDataSource,VTMagicViewDelegate,YNPageScrollMenuViewDelegate>
@property (strong, nonatomic) NSMutableArray *listTitles;
@property (strong, nonatomic) NSArray *listData;
@property (strong, nonatomic) NSMutableArray *listController;
@property (strong, nonatomic) VTMagicController * magicController;

@property (strong, nonatomic) YNPageScrollMenuView *menuView;
@end

@implementation GKShotVideoContentController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self loadUI];
}
- (void)loadUI{
    if (iPhone_X) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }else{
        [self setEdgesForExtendedLayout:UIRectEdgeAll];
    }
    self.fd_prefersNavigationBarHidden = YES;
    [self addChildViewController:self.magicController];
    [self.view addSubview:self.magicController.view];
    [self.view setNeedsUpdateConstraints];
    UIView * magicView = self.magicController.view;
    [magicView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(magicView.superview);
        make.top.equalTo(magicView.superview).offset(0);//.offset(-(STATUS_BAR_HIGHT + 40));
    }];
    self.magicController.view.hidden = true;
    [self setupEmpty:self.tableView];
    [self setupRefresh:self.tableView option:ATRefreshNone];
}
- (void)refreshData:(NSInteger)page{
    self.listTitles = @[].mutableCopy;
    self.listController = @[].mutableCopy;
    [GKHomeNetManager videoHome:1 success:^(id  _Nonnull object) {
        self.listData = [NSArray modelArrayWithClass:GKVideoTopModel.class json:object[@"videoSidList"]];
        [self reloadUI];
        [self.tableView reloadData];
        [self endRefresh:false];
        self.tableView.hidden = YES;
    } failure:^(NSString * _Nonnull error) {
        [self endRefreshFailure];
    }];
}
- (void)reloadUI{
    self.magicController.view.hidden = NO;
    [self.listTitles removeAllObjects];
    [self.listController removeAllObjects];
    [self.listData enumerateObjectsUsingBlock:^(GKVideoTopModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.listTitles addObject:obj.title ?:@""];
        GKVideoPlayController *vc = [GKVideoPlayController vcWithSid:obj.sid];
        [self.listController addObject:vc];
    }];

    YNPageConfigration *thirdConfigStyle = [YNPageConfigration defaultConfig];

    thirdConfigStyle.showBottomLine = NO;
    thirdConfigStyle.scrollMenu = NO;
    thirdConfigStyle.aligmentModeCenter = YES;
    thirdConfigStyle.lineBottomMargin = 6;
    thirdConfigStyle.lineLeftAndRightMargin = 5;
    thirdConfigStyle.lineColor = [UIColor whiteColor];
    thirdConfigStyle.bottomLineHeight = 2;
    thirdConfigStyle.itemFont = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    thirdConfigStyle.selectedItemFont = [UIFont systemFontOfSize:17 weight:UIFontWeightBold];
    thirdConfigStyle.selectedItemColor = [UIColor whiteColor];
    thirdConfigStyle.normalItemColor = Appx999999;
    
    YNPageScrollMenuView *menuView = [YNPageScrollMenuView pagescrollMenuViewWithFrame:CGRectMake(0,STATUS_BAR_HIGHT, SCREEN_WIDTH, 40) titles:self.listTitles configration:thirdConfigStyle delegate:self currentIndex:0];
    menuView.backgroundColor = [UIColor clearColor];
    self.menuView = menuView;
    
    [self.magicController.magicView reloadData];
    [self.view addSubview:menuView];
}
#pragma mark VTMagicViewDataSource,VTMagicViewDelegate
/**
 *  获取所有菜单名，数组中存放字符串类型对象
 *
 *  @param magicView self
 *
 *  @return header数组
 */
- (NSArray<__kindof NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView{
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
- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex{
    
    static NSString *itemIdentifier = @"com.video.btn.itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    [menuItem setTitle:self.listTitles[itemIndex] forState:UIControlStateNormal];
    [menuItem setTitleColor:Appx999999 forState:UIControlStateNormal];
    [menuItem setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    menuItem.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
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
- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex{
    return  self.listController[pageIndex];
}
- (void)magicView:(VTMagicView *)magicView viewDidAppear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex{
    [self.menuView selectedItemIndex:pageIndex animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
#pragma mark YNPageScrollMenuViewDelegate
- (void)pagescrollMenuViewItemOnClick:(UIButton *)button index:(NSInteger)index{
    if (self.listData.count > index) {
        [self.magicController.magicView switchToPage:index animated:YES];
    }
}
-(VTMagicController *)magicController {
    
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.magicView.separatorHeight = 0.0f;
        _magicController.magicView.backgroundColor = [UIColor clearColor];
        _magicController.magicView.navigationColor = [UIColor blackColor];
        _magicController.magicView.switchStyle = VTSwitchStyleDefault;
        _magicController.magicView.sliderColor = [UIColor colorWithRGB:0xffffff];
        _magicController.magicView.layoutStyle = VTLayoutStyleCenter;
        _magicController.magicView.sliderHeight = 2;
        _magicController.magicView.sliderOffset = -5;
        _magicController.magicView.itemSpacing = 20;
        _magicController.magicView.sliderExtension = -4;
        _magicController.magicView.bubbleRadius = 1;
        _magicController.magicView.navigationHeight = 0;
        _magicController.magicView.againstStatusBar = false;
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
        _magicController.magicView.separatorColor = [UIColor clearColor];
        _magicController.magicView.needPreloading = true;
        _magicController.magicView.bounces = false;
        
    }
    return _magicController;
}

@end
