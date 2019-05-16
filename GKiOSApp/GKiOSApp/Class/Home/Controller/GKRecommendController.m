//
//  GKRecommendController.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/13.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKRecommendController.h"
#import "GKHomeHotCollectionViewCell.h"
#import "GKHomeHotModel.h"
#import "GKHomeCollectionReusableView.h"
#import "SDCycleScrollView.h"
@interface GKRecommendController()<SDCycleScrollViewDelegate>
@property (strong, nonatomic) GKHomeHotModel *hotModel;
@property (strong, nonatomic) SDCycleScrollView *carouselView;
@end
@implementation GKRecommendController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setupEmpty:self.collectionView];
    [self setupRefresh:self.collectionView option:ATHeaderRefresh|ATHeaderAutoRefresh];
}
- (void)refreshData:(NSInteger)page{
    NSDictionary *params = @{
                             @"order": @"hot",
                             @"adult": @"false",
                             @"first": @(page),
                             @"limit": @"60"
                             };
    [GKHomeNetManager homeHot:params success:^(id  _Nonnull object) {
        self.hotModel = [GKHomeHotModel modelWithJSON:object];
        NSMutableArray *listData = @[].mutableCopy;
        [self.hotModel.banner enumerateObjectsUsingBlock:^(GKHomeHotBannerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [listData addObject:obj.thumb];
        }];
        self.listData = self.hotModel.wallpaper.mutableCopy;
        self.carouselView.imageURLStringsGroup = listData.copy;
        [self.collectionView reloadData];
        [self endRefresh:YES];
    } failure:^(NSString * _Nonnull error) {
        [self endRefreshFailure];
    }];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH,SCALEW(self.hotModel.banner ? 180 : 0.0f));
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        GKHomeCollectionReusableView *reusableView = [GKHomeCollectionReusableView viewForCollectionView:collectionView elementKind:UICollectionElementKindSectionHeader indexPath:indexPath];
        if (![reusableView viewWithTag:100]) {
            [reusableView addSubview:self.carouselView];
            [self.carouselView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.carouselView.superview);
            }];
        }
        return reusableView;
    }
    return [UICollectionReusableView new];
}
#pragma mark SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    [ATIDMPhotoBrowser photoBrowsers:self.carouselView.imageURLStringsGroup selectIndex:index];
}
- (SDCycleScrollView *)carouselView
{
    if (!_carouselView) {
        CGFloat height = SCALEW(180);
        _carouselView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0, SCREEN_WIDTH, height) delegate:self placeholderImage:[UIImage imageWithColor:[UIColor colorWithRGB:0xf8f8f8]]];
        _carouselView.backgroundColor = [UIColor colorWithRGB:0xf8f8f8];
        _carouselView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _carouselView.autoScrollTimeInterval  = 5.0f;
        _carouselView.delegate = self;
        _carouselView.tag = 100;
    }
    return _carouselView;
}
@end
