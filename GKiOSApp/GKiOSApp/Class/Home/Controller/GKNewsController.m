//
//  GKNewsController.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/13.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKNewsController.h"
#import "GKHomeCategoryModel.h"
#import "GKHomeHotCollectionViewCell.h"
@interface GKNewsController()

@end
@implementation GKNewsController
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
    params[@"start"]    = @(1+(page-1)*30);
    params[@"end"]      = @(30);
    CGRect rect     = [UIScreen mainScreen].bounds;
    NSInteger width = (int) (rect.size.width * 2);
    NSInteger height   = (int) (rect.size.height * 2);
    params[@"imgSize"] = [NSString stringWithFormat:@"%lix%li",(long)width,(long)height];
    [GKHomeNetManager homeCategory:@"" params:params success:^(id  _Nonnull object) {
        if (page == 1) {
            [self.listData removeAllObjects];
        }
        NSArray *listData= [NSArray modelArrayWithClass:GKHomeCategoryItemModel.class json:object[@"groupList"]];
        [self.listData addObjectsFromArray:listData];
        [self.collectionView reloadData];
        [self endRefresh:listData.count >=30];
    } failure:^(NSString * _Nonnull error) {
        [self endRefreshFailure];
    }];
}

@end
