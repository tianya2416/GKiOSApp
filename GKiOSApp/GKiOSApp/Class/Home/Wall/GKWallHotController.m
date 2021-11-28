//
//  GKNewsController.m
//  GKiOSApp
//
//  Created by wangws1990 on 2017/5/13.
//  Copyright © 2017 wangws1990. All rights reserved.
//

#import "GKWallHotController.h"
#import "GKWallClassModel.h"
#import "GKHomeHotCollectionViewCell.h"
@interface GKWallHotController()

@end
@implementation GKWallHotController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupEmpty:self.collectionView];
    [self setupRefresh:self.collectionView option:ATHeaderRefresh|ATHeaderAutoRefresh];
}
- (void)refreshData:(NSInteger)page{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"cateId"]   = @"1";
    params[@"isNow"]    = @"1";
    params[@"start"]    = @(1+(page-1)*RefreshPageSize);
    params[@"end"]      = @(RefreshPageSize);
    CGRect rect     = [UIScreen mainScreen].bounds;
    NSInteger width = (int) (rect.size.width * 2);
    NSInteger height   = (int) (rect.size.height * 2);
    params[@"imgSize"] = [NSString stringWithFormat:@"%lix%li",(long)width,(long)height];
    [GKHomeNetManager wallCategoryItem:@"" params:params success:^(id  _Nonnull object) {
        if (page == 1) {
            [self.listData removeAllObjects];
        }
        NSArray *listData= [NSArray modelArrayWithClass:GKWallClassItemModel.class json:object[@"groupList"]];
        listData ? [self.listData addObjectsFromArray:listData] : nil;
        [self.collectionView reloadData];
        [self endRefresh:listData.count >=RefreshPageSize];
    } failure:^(NSString * _Nonnull error) {
        [self endRefreshFailure];
    }];
}

@end
