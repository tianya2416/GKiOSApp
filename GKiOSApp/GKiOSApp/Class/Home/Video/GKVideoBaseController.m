//
//  GKVideoBaseController.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/30.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKVideoBaseController.h"
#import "GKVideoHomeController.h"
#import "GKVideoHotController.h"
#import "GKVideoModel.h"
@interface GKVideoBaseController ()<VTMagicViewDataSource,VTMagicViewDelegate>
@property (strong, nonatomic) VTMagicController * magicController;
@property (strong, nonatomic) GKVideoHotController *hotController;
@property (strong, nonatomic) NSMutableArray *listTitles;
@property (strong, nonatomic) NSArray *listData;
@end

@implementation GKVideoBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
    [self loadData];
}
- (void)loadUI{
    self.fd_prefersNavigationBarHidden = YES;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    [self addChildViewController:self.magicController];
    [self.view addSubview:_magicController.view];
    [self.view setNeedsUpdateConstraints];
    [self.magicController.magicView reloadData];


}
- (void)updateViewConstraints {
    UIView *magicView = _magicController.view;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[magicView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(magicView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[magicView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(magicView)]];
    
    [super updateViewConstraints];
}
- (void)loadData{
    self.listTitles = @[].mutableCopy;
    [self reloadUI];
    [GKHomeNetManager videoHome:1 success:^(id  _Nonnull object) {
        self.listData = [NSArray modelArrayWithClass:GKVideoTopModel.class json:object[@"videoSidList"]];
        [self reloadUI];
    } failure:^(NSString * _Nonnull error) {
        
    }];
}
- (void)reloadUI{
    [self.listTitles removeAllObjects];
    [self.listTitles addObject:@"热门"];
    [self.listData enumerateObjectsUsingBlock:^(GKVideoTopModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.listTitles addObject:obj.title ?:@""];
    }];
    [self.magicController.magicView reloadData];
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
    
    static NSString *itemIdentifier = @"com.video.homebtn.itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    [menuItem setTitle:self.listTitles[itemIndex] forState:UIControlStateNormal];
    [menuItem setTitleColor:[UIColor colorWithRGB:0xffffff] forState:UIControlStateNormal];
    [menuItem setTitleColor:[UIColor colorWithRGB:0xffffff] forState:UIControlStateSelected];
    menuItem.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
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
    if (pageIndex == 0) {
        return self.hotController;
    }
    static NSString *itemIdentifier = @"com.video.home.itemIdentifier";
    GKVideoHomeController *vc = [magicView dequeueReusablePageWithIdentifier:itemIdentifier];
    if (!vc) {
        vc = [[GKVideoHomeController alloc] init];
    }
    GKVideoTopModel *model = self.listData[pageIndex-1];
    vc.sId = model.sid ?:@"";
    return vc;
}
-(VTMagicController *)magicController {
    
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.view.translatesAutoresizingMaskIntoConstraints = NO;
        _magicController.magicView.switchStyle = VTSwitchStyleDefault;
        _magicController.magicView.layoutStyle = VTLayoutStyleDefault;
        
        _magicController.magicView.backgroundColor = [UIColor whiteColor];
        _magicController.magicView.navigationInset = UIEdgeInsetsMake(0,10, 0,10);
        _magicController.magicView.navigationColor = AppColor;
        
        
//        _magicController.magicView.sliderColor = [UIColor colorWithRGB:0xffffff];
        _magicController.magicView.sliderExtension = 2;
        _magicController.magicView.sliderWidth = 35;
        _magicController.magicView.navigationHeight = 44;
        _magicController.magicView.headerHeight = 44;
        _magicController.magicView.sliderHeight = 4.0;
        _magicController.magicView.itemSpacing = 20;
        
        _magicController.magicView.againstStatusBar = YES;
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
        _magicController.magicView.needPreloading = true;
        
        _magicController.magicView.sliderStyle = VTSliderStyleBubble;
        _magicController.magicView.bubbleInset = UIEdgeInsetsMake(3,5,3, 5);
        UIView *sliderView= [[UIView alloc] init];
        sliderView.layer.masksToBounds = YES;
        sliderView.layer.cornerRadius = 13;
        sliderView.layer.borderWidth = 2;
        sliderView.layer.borderColor = [UIColor whiteColor].CGColor;
        [_magicController.magicView setSliderView:sliderView];
        
    }
    return _magicController;
}
- (GKVideoHotController *)hotController{
    if (!_hotController) {
        _hotController = [[GKVideoHotController alloc] init];
    }
    return _hotController;
}
- (BOOL)shouldAutorotate {
    return self.magicController.currentViewController.shouldAutorotate;
}
//返回支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.magicController.currentViewController.supportedInterfaceOrientations;
}
//这个是返回优先方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.magicController.currentViewController.preferredInterfaceOrientationForPresentation;
    
}
- (BOOL)prefersStatusBarHidden {
    return self.magicController.currentViewController.prefersStatusBarHidden;
}
@end
