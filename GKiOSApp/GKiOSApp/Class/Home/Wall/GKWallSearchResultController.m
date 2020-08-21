//
//  GKSearchResultController.m
//  GKiOSApp
//
//  Created by wangws1990 on 2017/5/16.
//  Copyright © 2017 wangws1990. All rights reserved.
//

#import "GKWallSearchResultController.h"
#import "GKHomeHotCollectionViewCell.h"
#import "GKSearchModel.h"
@interface GKWallSearchResultController ()
@property (copy, nonatomic) NSString *keyWord;
@property (strong, nonatomic)GKSearchResultModel *model;
@end

@implementation GKWallSearchResultController
+ (instancetype)vcWithSearchText:(NSString *)searchText{
    GKWallSearchResultController *vc = [[[self class] alloc] init];
    vc.keyWord = searchText;
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
}
- (void)loadUI {
    [self showNavTitle:self.keyWord backItem:YES];
    [self setupEmpty:self.collectionView];
    [self setupRefresh:self.collectionView option:ATHeaderRefresh|ATHeaderAutoRefresh];

}
- (void)refreshData:(NSInteger)page{
    NSDictionary *params = @{
                             @"wd": self.keyWord ?:@"",
                             @"start": @(1+(page-1)*RefreshPageSize),
                             @"end" : @(RefreshPageSize),
                             };
    [GKHomeNetManager wallSearch:self.keyWord params:params success:^(id  _Nonnull object) {
        if (page == 1) {
            [self.listData removeAllObjects];
        }
        NSArray *listData = [NSArray modelArrayWithClass:GKSearchResultModel.class json:object[@"groupList"]];
        listData ? [self.listData addObjectsFromArray:listData] : nil;
        [self.collectionView reloadData];
        [self endRefresh:listData.count >= RefreshPageSize];
    } failure:^(NSString * _Nonnull error) {
        [self endRefreshFailure];
    }];
}
@end
