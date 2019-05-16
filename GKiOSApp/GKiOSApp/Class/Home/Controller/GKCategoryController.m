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
        self.listData = [NSArray modelArrayWithClass:GKHomeCategoryModel.class json:object[@"category"]].mutableCopy;
        [self.collectionView reloadData];
        [self endRefresh:NO];
    } failure:^(NSString * _Nonnull error) {
        [self endRefreshFailure];
    }];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GKHomeHotCollectionViewCell *cell = [GKHomeHotCollectionViewCell cellForCollectionView:collectionView indexPath:indexPath];
    GKHomeCategoryModel *model = self.listData[indexPath.row];
    cell.titleLab.text = model.rname ?:@"";
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:placeholders];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *datas = [[NSMutableArray alloc] init];
    [self.listData enumerateObjectsUsingBlock:^(GKHomeCategoryModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [datas addObject:obj.cover];
    }];
    [ATIDMPhotoBrowser photoBrowsers:datas selectIndex:indexPath.row];
}
@end
