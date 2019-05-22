//
//  GKCategoryController.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/13.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKCategoryController.h"
#import "GKHomeCategoryModel.h"
#import "GKHomeHotCollectionViewCell.h"
#import "GKCategoryItemController.h"
@interface GKCategoryController()

@end
@implementation GKCategoryController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setupEmpty:self.collectionView];
    [self setupRefresh:self.collectionView option:ATHeaderRefresh|ATHeaderAutoRefresh];
}
- (void)refreshData:(NSInteger)page{
    [GKHomeNetManager homeCategory:@{} success:^(id  _Nonnull object) {
        self.listData = [NSArray modelArrayWithClass:GKHomeCategoryModel.class json:object[@"classificationlist"]].mutableCopy;
        [self.collectionView reloadData];
        [self endRefresh:NO];
    } failure:^(NSString * _Nonnull error) {
        [self endRefreshFailure];
    }];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = SCALEW(120);
    CGFloat height = SCALEW(90);
    return CGSizeMake(width, height);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GKHomeHotCollectionViewCell *cell = [GKHomeHotCollectionViewCell cellForCollectionView:collectionView indexPath:indexPath];
    GKHomeCategoryModel *model = self.listData[indexPath.row];
    cell.titleLab.text = model.cateName ?:@"";
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:model.coverImgUrl] placeholderImage:placeholders];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GKHomeCategoryModel *model = self.listData[indexPath.row];
    GKCategoryItemController *vc = [GKCategoryItemController vcWithCategoryId:model.cateId];
    [vc showNavTitle:model.cateName backItem:YES];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
