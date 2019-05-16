//
//  GKSearchItemController.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/16.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKSearchItemController.h"

@interface GKSearchItemController ()

@end

@implementation GKSearchItemController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupEmpty:self.collectionView];
    [self setupRefresh:self.collectionView option:ATRefreshNone];
    [self headerRefreshing];
}
- (void)setItems:(NSArray *)items{
    _items = items;
    [self refreshData:1];
}
- (void)refreshData:(NSInteger)page{
    self.listData = self.items.mutableCopy;
    [self.collectionView reloadData];
    self.listData.count == 0 ? [self endRefreshFailure] : [self endRefresh:NO];
}
@end
