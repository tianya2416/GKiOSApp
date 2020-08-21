//
//  GKBaseHomeController.m
//  GKiOSApp
//
//  Created by wangws1990 on 2017/5/10.
//  Copyright © 2017 wangws1990. All rights reserved.
//

#import "GKBaseHomeController.h"
#import "GKWallDetailController.h"
#import "GKWallHotController.h"
#import "GKWallClassController.h"
#import "GKWallCommenController.h"
#import "GKWallSearchController.h"
#import "GKHomeHotCollectionViewCell.h"
#import "GKWallCommenModel.h"
@interface GKBaseHomeController ()<VTMagicViewDataSource,VTMagicViewDelegate>
@property (strong, nonatomic) VTMagicController * magicController;

@property (strong, nonatomic) NSArray *listTitles;
@property (strong, nonatomic) NSArray *listControllers;
@end

@implementation GKBaseHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.listTitles = @[@"推荐",@"分类",@"最热"];
    GKWallCommenController *vcRecom = [[GKWallCommenController alloc] init];
    GKWallClassController *vcClass = [[GKWallClassController alloc] init];
    GKWallHotController *vcHot = [[GKWallHotController alloc] init];
    self.listControllers = @[vcRecom,vcClass,vcHot];
    
    [self addChildViewController:self.magicController];
    [self.view addSubview:_magicController.view];
    [self.view setNeedsUpdateConstraints];
    [self.magicController.magicView reloadData];
    [self integrateComponents];
    // Do any additional setup after loading the view.
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
- (void)integrateComponents {
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setImage:[UIImage imageNamed:@"search_white"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    searchButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    if (iPhone_Bang) {
        searchButton.frame = CGRectMake(0,0,50,64);
        [searchButton setImageEdgeInsets:UIEdgeInsetsMake(10, 0, -10, 0)];
    }else{
        searchButton.frame = CGRectMake(0,0,50,44);
    }
    self.magicController.magicView.rightNavigatoinItem = searchButton;
//    [self.magicController.magicView setRightNavigatoinItem:searchButton];
}
- (void)searchAction{
    GKWallSearchController *vc = [[GKWallSearchController alloc] init];
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
    
    static NSString *itemIdentifier = @"com.wall.btn.itemIdentifier";
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
        _magicController.view.translatesAutoresizingMaskIntoConstraints = NO;
        _magicController.magicView.switchStyle = VTSwitchStyleDefault;
        _magicController.magicView.layoutStyle = VTLayoutStyleDefault;
        
        _magicController.magicView.backgroundColor = [UIColor whiteColor];
        _magicController.magicView.navigationInset = UIEdgeInsetsMake(0,10, 0,10);
        _magicController.magicView.navigationColor = AppColor;
        
        _magicController.magicView.sliderExtension = 2;
        _magicController.magicView.bubbleRadius = 2;
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
    CGFloat height = width * 1.4;
    return CGSizeMake(width, height);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GKHomeHotCollectionViewCell *cell = [GKHomeHotCollectionViewCell cellForCollectionView:collectionView indexPath:indexPath];
    GKWallCommenModel *model = self.listData[indexPath.row];
    if ([model isKindOfClass:GKWallCommenModel.class]) {
        cell.titleLab.text = @"";
        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:model.coverImgUrl] placeholderImage:placeholders];
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
    GKWallCommenModel *model = self.listData[indexPath.row];
    GKWallDetailController *vc = [GKWallDetailController vcWithGid:model.gId];
    vc.hidesBottomBarWhenPushed = YES;
    [vc showNavTitle:model.gName];
    [self.navigationController pushViewController:vc animated:YES];
}
- (NSMutableArray *)listData{
    if (!_listData) {
        _listData = [[NSMutableArray alloc] init];
    }
    return _listData;
}
@end
