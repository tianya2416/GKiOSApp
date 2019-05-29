//
//  GKVideoHomeController.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/20.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKVideoHomeController.h"
#import "GKVideoContentController.h"
#import "GKHomeHotCollectionViewCell.h"
#import "GKVideoModel.h"
@interface GKVideoHomeController ()

@end

@implementation GKVideoHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupEmpty:self.collectionView];
    [self setupRefresh:self.collectionView option:ATHeaderRefresh|ATHeaderAutoRefresh];
    [self headerRefreshing];
    
}
- (void)loadUI{
    
}
- (void)refreshData:(NSInteger)page{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    self.listData = [NSArray modelArrayWithClass:GKVideoModel.class json:rootDict[@"list"]].mutableCopy;
    [self.collectionView reloadData];
   //有分页设置yes
    self.listData.count ?([self endRefresh:NO]) : [self endRefreshFailure];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GKHomeHotCollectionViewCell *cell = [GKHomeHotCollectionViewCell cellForCollectionView:collectionView indexPath:indexPath];
    GKVideoModel *model = self.listData[indexPath.row];
    if ([model isKindOfClass:GKVideoModel.class]) {
        cell.titleLab.text = model.title ?:@"";
        cell.titleLab.font = [UIFont systemFontOfSize:13];
        cell.titleLab.textColor = [UIColor whiteColor];
        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:model.thumbnail_url] placeholderImage:placeholders];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GKVideoContentController *vc = [GKVideoContentController vcWithListDatas:self.listData index:indexPath.row];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
