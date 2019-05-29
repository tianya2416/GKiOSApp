//
//  GKWallCommenController.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/13.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKWallCommenController.h"
#import "GKHomeHotCollectionViewCell.h"
#import "GKWallCommenModel.h"
#import "GKHomeCollectionReusableView.h"
#import "SDCycleScrollView.h"
@interface GKWallCommenController()<SDCycleScrollViewDelegate>
@property (strong, nonatomic) GKWallCommenInfo *hotModel;
@property (strong, nonatomic) SDCycleScrollView *carouselView;
@end
@implementation GKWallCommenController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setupEmpty:self.collectionView];
    [self setupRefresh:self.collectionView option:ATRefreshDefault];
    [GKUserManager needLogin:^(BOOL success) {
        if (success) {
            NSLog(@"登录成功,做你想做");
        }
    }];
}
- (void)refreshData:(NSInteger)page{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"start"] = @(1+(page-1)*30);
    params[@"end"] = @(30);
    CGRect rect = [UIScreen mainScreen].bounds;
    NSInteger width = (int) (rect.size.width * 2);
    NSInteger height = (int) (rect.size.height * 2);
    params[@"imgSize"] = [NSString stringWithFormat:@"%lix%li",(long)width,(long)height];
    [GKHomeNetManager wallHot:params success:^(id  _Nonnull object) {
        if (page == 1) {
            [self.listData removeAllObjects];
        }
        self.hotModel = [GKWallCommenInfo modelWithJSON:object];
        [self.listData addObjectsFromArray:self.hotModel.groupList];
        self.carouselView.imageURLStringsGroup = self.hotModel.banner;
        [self.collectionView reloadData];
        [self endRefresh:self.hotModel.groupList.count >=30];
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
#pragma mark DZNEmptyDataSetSource
//- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
//    return SCALEW(180)/2;
//}
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
