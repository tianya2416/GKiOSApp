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
    NSDictionary *params = @{
                             @"order": @"new",
                             @"adult": @"false",
                             @"first": @(page),
                             @"limit": @(30)
                             };
    [GKHomeNetManager homeNews:params success:^(id  _Nonnull object) {
        self.listData = [NSArray modelArrayWithClass:GKHomeNewsModel.class json:object[@"wallpaper"]].mutableCopy;
        [self.collectionView reloadData];
        [self endRefresh:NO];
    } failure:^(NSString * _Nonnull error) {
        [self endRefreshFailure];
    }];
}

@end
