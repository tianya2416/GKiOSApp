//
//  GKDetailViewController.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/22.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKWallDetailController.h"
#import "GKWallDetailModel.h"
#import "GKHomeHotCollectionViewCell.h"
@interface GKWallDetailController ()
@property (copy, nonatomic) NSString *gId;
@end

@implementation GKWallDetailController
+ (instancetype)vcWithGid:(NSString *)gId{
    GKWallDetailController *vc = [[[self class] alloc] init];
    vc.gId = gId;
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupEmpty:self.collectionView];
    [self setupRefresh:self.collectionView option:ATHeaderRefresh|ATHeaderAutoRefresh];
    // Do any additional setup after loading the view.
}
- (void)refreshData:(NSInteger)page{
    [GKHomeNetManager wallDetail:self.gId success:^(id  _Nonnull object) {
        self.listData = [NSArray modelArrayWithClass:GKWallDetailModel.class json:object[@"imageList"]].mutableCopy;
        [self.collectionView reloadData];
        [self endRefresh:NO];
    } failure:^(NSString * _Nonnull error) {
        [self endRefreshFailure];
    }];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GKHomeHotCollectionViewCell *cell = [GKHomeHotCollectionViewCell cellForCollectionView:collectionView indexPath:indexPath];
    GKWallDetailModel *model = self.listData[indexPath.row];
    if ([model isKindOfClass:GKWallDetailModel.class]) {
        cell.titleLab.text = @"";
        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:placeholders];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ATBrowserController *vc = [ATBrowserController vcWithDatas:self.listData selectIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
//    NSMutableArray *datas = [[NSMutableArray alloc] init];
//    [self.listData enumerateObjectsUsingBlock:^(GKWallDetailModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (obj.imgUrl) {
//            [datas addObject:obj.imgUrl];
//        }
//    }];
//    if (datas.count) {
//        [ATIDMPhotoBrowser photoBrowsers:datas selectIndex:indexPath.row];
//    }
}
@end
