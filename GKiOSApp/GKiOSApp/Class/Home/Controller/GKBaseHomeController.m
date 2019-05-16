//
//  GKBaseHomeController.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/10.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKBaseHomeController.h"
#import "GKNewsController.h"
#import "GKCategoryController.h"
#import "GKRecommendController.h"
#import "GKSearchViewController.h"
#import "GKHomeHotCollectionViewCell.h"
#import "GKHomeHotModel.h"
@interface GKBaseHomeController ()<VTMagicViewDataSource,VTMagicViewDelegate>
@property (strong, nonatomic) VTMagicController * magicController;

@property (strong, nonatomic) NSArray *listTitles;
@property (strong, nonatomic) NSArray *listControllers;
@end

@implementation GKBaseHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.listTitles = @[@"推荐",@"分类",@"最新"];
    GKRecommendController *vcRecom = [[GKRecommendController alloc] init];
    GKCategoryController *vcCategory = [[GKCategoryController alloc] init];
    GKNewsController *vcNews = [[GKNewsController alloc] init];
    self.listControllers = @[vcRecom,vcCategory,vcNews];
    
    [self addChildViewController:self.magicController];
    [self.view addSubview:self.magicController.view];
    [self.view setNeedsUpdateConstraints];
    UIView * magicView = self.magicController.view;
    [magicView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self.magicController.magicView reloadData];
    [self integrateComponents];
    // Do any additional setup after loading the view.
}
- (void)integrateComponents {
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setImage:[UIImage imageNamed:@"search_white"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    searchButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    searchButton.frame = CGRectMake(0, 0,60, 40);
    [self.magicController.magicView setRightNavigatoinItem:searchButton];
}
- (void)searchAction{
    GKSearchViewController *vc = [[GKSearchViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    [vc showNavTitle:@"" backItem:YES];
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
    return self.listControllers[pageIndex];
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
        _magicController.magicView.sliderExtension = 2;
        _magicController.magicView.bubbleRadius = 2;
        _magicController.magicView.sliderWidth = 35;
        
        _magicController.magicView.layoutStyle = VTLayoutStyleDefault;
        _magicController.magicView.navigationHeight = 44.0;
        _magicController.magicView.sliderHeight = 4.0;
        _magicController.magicView.itemSpacing = 20;
        
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
@end

@implementation GKBaseHotController

- (void)viewDidLoad{
    [super viewDidLoad];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.listData.count;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1,1,1,1);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (SCREEN_WIDTH - 3*1)/2.0;
    CGFloat height = width * 1.35;
    return CGSizeMake(width, height);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GKHomeHotCollectionViewCell *cell = [GKHomeHotCollectionViewCell cellForCollectionView:collectionView indexPath:indexPath];
    GKHomeHotPaperModel *model = self.listData[indexPath.row];
    if ([model isKindOfClass:GKHomeHotPaperModel.class]) {
        cell.titleLab.text = @"";
        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:placeholders];
    }
    return cell;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *datas = [[NSMutableArray alloc] init];
    [self.listData enumerateObjectsUsingBlock:^(GKHomeHotPaperModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.thumb) {
            [datas addObject:obj.thumb];
        }
    }];
    [ATIDMPhotoBrowser photoBrowsers:datas selectIndex:indexPath.row];
}
@end
