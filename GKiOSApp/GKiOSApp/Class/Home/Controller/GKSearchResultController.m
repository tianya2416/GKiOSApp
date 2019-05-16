//
//  GKSearchResultController.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/16.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKSearchResultController.h"
#import "GKSearchItemController.h"
#import "GKSearchModel.h"
@interface GKSearchResultController ()<VTMagicViewDataSource,VTMagicViewDelegate>
@property (copy, nonatomic) NSString *keyWorld;
@property (strong, nonatomic) VTMagicController * magicController;

@property (strong, nonatomic) NSMutableArray *listTitles;

@property (strong, nonatomic)GKSearchResultModel *model;
@end

@implementation GKSearchResultController
+ (instancetype)vcWithSearchText:(NSString *)searchText{
    GKSearchResultController *vc = [[[self class] alloc] init];
    vc.keyWorld = searchText;
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
    // Do any additional setup after loading the view.
}
- (void)loadUI {
    [self showNavTitle:self.keyWorld backItem:YES];
    [self setupEmpty:self.collectionView];
    [self setupRefresh:self.collectionView option:ATHeaderRefresh|ATHeaderAutoRefresh];
    self.listTitles = @[].mutableCopy;
    [self addChildViewController:self.magicController];
    [self.view addSubview:self.magicController.view];
    UIView * magicView = self.magicController.view;
    [magicView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}
- (void)refreshData:(NSInteger)page{
    NSDictionary *params = @{
                             @"adult": @"false",
                             @"version": @"148",
                             @"channel": @"UCshangdian",
                             };
    [GKHomeNetManager homeSearch:self.keyWorld params:params success:^(id  _Nonnull object) {
        self.listData = @[].mutableCopy;
        self.model = [GKSearchResultModel modelWithJSON:object];
        [self.model.search enumerateObjectsUsingBlock:^(GKSearchItemsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.listTitles addObject:obj.title];
        }];
        [self.magicController.magicView reloadData];
        [self endRefresh:NO];
    } failure:^(NSString * _Nonnull error) {
        [self endRefreshFailure];
    }];
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
    GKSearchItemsModel *item = self.model.search[itemIndex];
    [menuItem setTitle:item.title?:@"" forState:UIControlStateNormal];
    [menuItem setTitleColor:AppColor forState:UIControlStateNormal];
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
    static NSString * itemViewCtrlId = @"MyCountDownDay.identifier";
    GKSearchItemController * viewCtrl = [magicView dequeueReusablePageWithIdentifier:itemViewCtrlId];
    if (!viewCtrl)
    {
        viewCtrl = [[GKSearchItemController alloc] init];
    }
    GKSearchItemsModel *item = self.model.search[pageIndex];
    viewCtrl.items = item.items;
    return viewCtrl;
}
-(VTMagicController *)magicController {
    
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.magicView.separatorHeight = 0.0f;
        _magicController.magicView.backgroundColor = [UIColor whiteColor];
        _magicController.magicView.navigationColor = [UIColor whiteColor];
        _magicController.magicView.switchStyle = VTSwitchStyleDefault;
        
        _magicController.magicView.sliderColor = AppColor;
        _magicController.magicView.sliderExtension = 2;
        _magicController.magicView.bubbleRadius = 2;
        _magicController.magicView.sliderWidth = 30;
        
        _magicController.magicView.layoutStyle = VTLayoutStyleDefault;
        _magicController.magicView.navigationHeight = 36;
        _magicController.magicView.sliderHeight = 4.0;
        _magicController.magicView.itemSpacing = 20;
        
        _magicController.magicView.againstStatusBar = NO;
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
        _magicController.magicView.separatorColor = AppColor;
        _magicController.magicView.needPreloading = true;
        _magicController.magicView.bounces = false;
        
    }
    return _magicController;
}
@end
