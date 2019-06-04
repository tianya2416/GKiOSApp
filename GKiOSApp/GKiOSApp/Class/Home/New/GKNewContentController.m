//
//  GKNewViewController.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/10.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKNewContentController.h"
#import "GKNewSelectController.h"
#import "GKNewItemViewController.h"
#import "GKNewSearchController.h"
#import "KLRecycleScrollView.h"
#import "GKNewNavBarView.h"
#import "GKNewModel.h"
#import "GKNewSearch.h"
@interface GKNewContentController ()<VTMagicViewDataSource,VTMagicViewDelegate,GKNewSelectDelegate,KLRecycleScrollViewDelegate>

@property (strong, nonatomic) VTMagicController * magicController;
@property (strong, nonatomic) NSMutableArray <NSString *>*listTitles;
@property (strong, nonatomic) NSMutableArray <GKNewTopModel *>*listData;
@property (strong, nonatomic) NSArray *listHotWords;
@property (strong, nonatomic) GKNewNavBarView *navBarView;
@property (nonatomic, strong) KLRecycleScrollView *vmessage;
@end

@implementation GKNewContentController

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
    [self.navBarView.mainView addSubview:self.vmessage];
    
}
- (void)loadData{
    [GKNewTopQueue getDatasFromDataBases:^(NSArray<GKNewTopModel *> * _Nonnull listData) {
        listData.count == 0 ? [self getJSONData] :[self reloadUI:listData];
    }];
    self.listHotWords = @[@"瑞幸纳斯达克上市",@"阿里回港上市",@"百度在BAT中已经掉队",@"韩国队公开道歉",@"应届月薪不足六千"];
    [self.vmessage reloadData:self.listHotWords.count];
    [GKHomeNetManager newSearchHotWord:^(id  _Nonnull object) {
        self.listHotWords = [NSArray modelArrayWithClass:GKNewHotWord.class json:object[@"RollhotWordList"]];
        [self.vmessage reloadData:self.listHotWords.count];
    } failure:^(NSString * _Nonnull error) {
        
    }];
}
- (void)getJSONData{
    NSError *error = nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"new" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (!error) {
        NSArray <GKNewTopModel *>*datas = [NSArray modelArrayWithClass:GKNewTopModel.class json:rootDict[@"tList"]];
        [datas enumerateObjectsUsingBlock:^(GKNewTopModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.sort = idx;;
            if (idx < 10) {
                obj.select = YES;
            }
        }];
        [self reloadUI:datas];
        [GKNewTopQueue insertDataToDataBases:datas completion:^(BOOL success) {
            NSLog(@"insert Data %@",@(success));
        }];
    }
}
- (void)reloadUI:(NSArray <GKNewTopModel *>*)datas
{
    [self.listTitles removeAllObjects];
    [self.listData removeAllObjects];
    [datas  enumerateObjectsUsingBlock:^(GKNewTopModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.select) {
            [self.listTitles addObject:obj.tname] ;
            [self.listData addObject:obj] ;
        }
    }];
    [self.magicController.magicView reloadData];

}
- (void)addAction{
    GKNewTopModel *model = self.listData[self.magicController.currentPage];
    GKNewSelectController *vc = [GKNewSelectController vcWithSelect:model delegate:self];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)searchAction{
    GKNewSearchController *vc = [[GKNewSearchController alloc] init];
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
    
    static NSString *itemIdentifier = @"com.new.btn.itemIdentifier";
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
    static NSString * itemViewCtrlId = @"com.new.magicView.identifier";
    GKNewItemViewController * viewCtrl = [magicView dequeueReusablePageWithIdentifier:itemViewCtrlId];
    if (!viewCtrl)
    {
        viewCtrl = [[GKNewItemViewController alloc] init];
    }
    GKNewTopModel *model = self.listData[pageIndex];
    viewCtrl.categoryId = model.userId;
    return viewCtrl;
}
- (void)magicView:(VTMagicView *)magicView viewDidAppear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex{
    
}
#pragma mark GKNewSelectDelegate
- (void)viewDidItem:(GKNewSelectController *)vc topModel:(GKNewTopModel *)topModel{
    if (!topModel.userId) {
        return;
    }
    [self.listData enumerateObjectsUsingBlock:^(GKNewTopModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.userId isEqualToString:topModel.userId]) {
            [self.magicController.magicView reloadDataToPage:idx];
            *stop = YES;
        }
    }];
}
- (void)viewDidLoad:(GKNewSelectController *)vc topModel:(GKNewTopModel *)topModel{
    [self loadData];
}
#pragma mark KLRecycleScrollViewDelegate
- (UIView *)recycleScrollView:(KLRecycleScrollView *)recycleScrollView viewForItemAtIndex:(NSInteger)index {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = Appx333333;
    GKNewHotWord *model = self.listHotWords[index];
    if ([model isKindOfClass:GKNewHotWord.class]) {
        label.text = model.hotWord;
    }else if ([model isKindOfClass:NSString.class]){
        label.text =(NSString *)model;
    }
    
    label.textAlignment = NSTextAlignmentLeft;
    return label;
}
- (void)recycleScrollView:(KLRecycleScrollView *)recycleScrollView didSelectView:(UIView *)view forItemAtIndex:(NSInteger)index{
    [self searchAction];
}
#pragma mark get
-(VTMagicController *)magicController {
    
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.magicView.separatorHeight = 0.50f;
        _magicController.magicView.separatorColor = [UIColor colorWithRGB:0xdddddd];
        _magicController.magicView.backgroundColor = [UIColor whiteColor];
        _magicController.magicView.navigationInset = UIEdgeInsetsMake(0,2, 0,2);
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
        _magicController.magicView.itemScale = 1.15f;
        _magicController.magicView.needPreloading = true;
        _magicController.magicView.bounces = false;
        
    }
    return _magicController;
}
- (GKNewNavBarView *)navBarView{
    if (!_navBarView) {
        _navBarView = [GKNewNavBarView instanceView];
        _navBarView.backgroundColor = AppColor;
       // [_navBarView.searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
        [_navBarView.moreBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navBarView;
}
- (KLRecycleScrollView *)vmessage{
    if (!_vmessage) {
        _vmessage = [[KLRecycleScrollView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH - 100, 35)];
        _vmessage.delegate = self;
        _vmessage.direction = KLRecycleScrollViewDirectionTop;
        _vmessage.pagingEnabled = YES;
        _vmessage.timerEnabled = YES;
        _vmessage.scrollInterval = 5;
        _vmessage.backgroundColor = [UIColor whiteColor];
    }
    return _vmessage;
}

@end
