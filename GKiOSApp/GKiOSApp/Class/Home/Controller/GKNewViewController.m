//
//  GKNewViewController.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/10.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKNewViewController.h"
#import "GKNewSelectController.h"
#import "GKNewItemViewController.h"
#import "GKSearchViewController.h"
#import "GKNewNavBarView.h"
#import "GKNewsModel.h"
@interface GKNewViewController ()<VTMagicViewDataSource,VTMagicViewDelegate,GKNewSelectDelegate>
@property (strong, nonatomic) VTMagicController * magicController;
@property (strong, nonatomic) NSMutableArray <NSString *>*listTitles;
@property (strong, nonatomic) NSMutableArray <GKNewsTopModel *>*listData;

@property (strong, nonatomic) GKNewNavBarView *navBarView;
@end

@implementation GKNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.listTitles = @[].mutableCopy;
    self.listData = @[].mutableCopy;
    [self loadUI];
    [self loadData];
}
- (void)loadUI{
    [self.view addSubview:self.navBarView];
    [self.navBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.navBarView.superview);
        make.height.offset(NAVI_BAR_HIGHT);
    }];
    [self addChildViewController:self.magicController];
    [self.view addSubview:self.magicController.view];
    [self.view setNeedsUpdateConstraints];
    UIView * magicView = self.magicController.view;
    [magicView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(magicView.superview);
        make.top.equalTo(self.navBarView.mas_bottom);
    }];
    [self setNavRightItemWithImage:[UIImage imageNamed:@"search_white"] action:@selector(searchAction)];
    self.navigationItem.leftBarButtonItem = [self navItemWithImage:[UIImage imageNamed:@"top_navigation_menuicon"] action:@selector(addAction)];
}
- (void)loadData{
    [GKNewTopQueue getDatasFromDataBase:^(NSArray<GKNewsTopModel *> * _Nonnull listData) {
        listData.count == 0 ? [self getJSONData] :[self reloadUI:listData];
    }];

}
- (void)getJSONData{
    NSError *error = nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"topic_news" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (!error) {
        NSArray *datas = [NSArray modelArrayWithClass:GKNewsTopModel.class json:rootDict[@"tList"]];
        [datas enumerateObjectsUsingBlock:^(GKNewsTopModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.sort = idx;;
            if (idx < 10) {
                obj.select = YES;
            }
        }];
        [self reloadUI:datas];
        [GKNewTopQueue insertDatasDataBase:datas completion:^(BOOL success) {
            NSLog(@"insert Data %@",@(success));
        }];
    }
}
- (void)reloadUI:(NSArray <GKNewsTopModel *>*)datas
{
    [self.listTitles removeAllObjects];
    [self.listData removeAllObjects];
    [datas  enumerateObjectsUsingBlock:^(GKNewsTopModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.select) {
            [self.listTitles addObject:obj.tname] ;
            [self.listData addObject:obj] ;
        }
    }];
    [self.magicController.magicView reloadData];

}
- (void)addAction{
    GKNewsTopModel *model = self.listData[self.magicController.currentPage];
    GKNewSelectController *vc = [GKNewSelectController vcWithSelect:model delegate:self];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)searchAction{
    GKSearchViewController *vc = [GKSearchViewController vcWithSearchState:GKSearchNew];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:NO];
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
    
    static NSString *itemIdentifier = @"com.fd.itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    [menuItem setTitle:self.listTitles[itemIndex] forState:UIControlStateNormal];
    [menuItem setTitleColor:Appx333333 forState:UIControlStateNormal];
    [menuItem setTitleColor:AppColor forState:UIControlStateSelected];
    menuItem.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
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
    static NSString * itemViewCtrlId = @"magicView.identifier";
    GKNewItemViewController * viewCtrl = [magicView dequeueReusablePageWithIdentifier:itemViewCtrlId];
    if (!viewCtrl)
    {
        viewCtrl = [[GKNewItemViewController alloc] init];
    }
    GKNewsTopModel *model = self.listData[pageIndex];
    viewCtrl.categoryId = model.userId;
    return viewCtrl;
}
#pragma mark GKNewSelectDelegate
- (void)viewDidItem:(GKNewSelectController *)vc topModel:(GKNewsTopModel *)topModel{
    if (!topModel.userId) {
        return;
    }
    [self.listData enumerateObjectsUsingBlock:^(GKNewsTopModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.userId isEqualToString:topModel.userId]) {
            [self.magicController.magicView reloadDataToPage:idx];
            *stop = YES;
        }
    }];
}
- (void)viewDidLoad:(GKNewSelectController *)vc topModel:(GKNewsTopModel *)topModel{
    [self loadData];
}
#pragma mark get
-(VTMagicController *)magicController {
    
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.magicView.separatorHeight = 0.50f;
        _magicController.magicView.separatorColor = [UIColor colorWithRGB:0xdddddd];
        _magicController.magicView.backgroundColor = [UIColor whiteColor];
        _magicController.magicView.navigationInset = UIEdgeInsetsMake(0, 12, 0, 12);
        _magicController.magicView.navigationColor = [UIColor whiteColor];
        _magicController.magicView.switchStyle = VTSwitchStyleDefault;
        
        _magicController.magicView.sliderColor = [UIColor colorWithRGB:0xffffff];
        _magicController.magicView.sliderExtension = 1;
        _magicController.magicView.bubbleRadius = 1;
        _magicController.magicView.sliderWidth = 00;
        
        _magicController.magicView.layoutStyle = VTLayoutStyleDefault;
        _magicController.magicView.navigationHeight = 35.0;
        _magicController.magicView.sliderHeight = 0.0;
        _magicController.magicView.itemSpacing = 15;
        
        _magicController.magicView.againstStatusBar = NO;
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
        _magicController.magicView.itemScale = 1.2f;
        _magicController.magicView.needPreloading = true;
        _magicController.magicView.bounces = false;
        
    }
    return _magicController;
}
- (GKNewNavBarView *)navBarView{
    if (!_navBarView) {
        _navBarView = [GKNewNavBarView instanceView];
        _navBarView.backgroundColor = AppColor;
        [_navBarView.searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
        [_navBarView.moreBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navBarView;
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
