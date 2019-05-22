//
//  GKNewViewController.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/10.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKNewViewController.h"
#import "GKNewItemViewController.h"
#import "GKNewsModel.h"
@interface GKNewViewController ()<VTMagicViewDataSource,VTMagicViewDelegate>
@property (strong, nonatomic) VTMagicController * magicController;
@property (strong, nonatomic) NSMutableArray *listTitles;
@property (strong, nonatomic) NSArray *listData;
@end

@implementation GKNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    [self addChildViewController:self.magicController];
    [self.view addSubview:self.magicController.view];
    [self.view setNeedsUpdateConstraints];
    UIView * magicView = self.magicController.view;
    [magicView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
//    self.listTitles = @[@"全部", @"头条",@"快讯", @"游戏", @"应用",@"业界", @"Jobs",@"库克",@"炫配",@"活动",@"ipone技巧", @"iPad技巧", @"Mac技巧",@"iTunes技巧"];
//    self.listCategorys = @[@"0", @"9999",@"1",@"11",@"1967",@"4",@"43",@"2634",@"3",@"8", @"6", @"5", @"230", @"12"];
    [self loadData];
}
- (void)loadData{
    self.listTitles = @[].mutableCopy;
    NSError *error = nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"topic_news" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (!error) {
        self.listData = [NSArray modelArrayWithClass:GKNewsTopModel.class json:rootDict[@"tList"]];
        [self.listData  enumerateObjectsUsingBlock:^(GKNewsTopModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.listTitles addObject:obj.tname];
            if (self.listTitles.count > 9) {
                *stop = YES;
            }
        }];
    }
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
    
    static NSString *itemIdentifier = @"com.fd.itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    [menuItem setTitle:self.listTitles[itemIndex] forState:UIControlStateNormal];
    [menuItem setTitleColor:[UIColor colorWithRGB:0xffffff] forState:UIControlStateNormal];
    [menuItem setTitleColor:[UIColor colorWithRGB:0xffffff] forState:UIControlStateSelected];
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
    viewCtrl.categoryId = model.tid;
    return viewCtrl;
}
-(VTMagicController *)magicController {
    
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.magicView.separatorHeight = 0.0f;
        _magicController.magicView.backgroundColor = [UIColor whiteColor];
        _magicController.magicView.navigationInset = UIEdgeInsetsMake(0, 12, 0, 12);
        _magicController.magicView.navigationColor = AppColor;
        _magicController.magicView.switchStyle = VTSwitchStyleDefault;
        
        _magicController.magicView.sliderColor = [UIColor colorWithRGB:0xffffff];
        _magicController.magicView.sliderExtension = 1;
        _magicController.magicView.bubbleRadius = 1;
        _magicController.magicView.sliderWidth = 30;
        
        _magicController.magicView.layoutStyle = VTLayoutStyleDefault;
        _magicController.magicView.navigationHeight = 44.0;
        _magicController.magicView.sliderHeight = 2.0;
        _magicController.magicView.itemSpacing = 15;
        
        _magicController.magicView.againstStatusBar = YES;
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
        _magicController.magicView.separatorColor = [UIColor colorWithRGB:0xffffff];
        _magicController.magicView.needPreloading = true;
        _magicController.magicView.bounces = false;
        
    }
    return _magicController;
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
