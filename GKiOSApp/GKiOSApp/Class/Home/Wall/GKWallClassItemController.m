//
//  GKCategoryItemController.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/16.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKWallClassItemController.h"
#import "GKHomeHotCollectionViewCell.h"
#import "GKWallClassModel.h"
@interface GKWallClassItemController ()
@property (nonatomic, strong) NSString *categoryID;
@end

@implementation GKWallClassItemController
+ (instancetype)vcWithCategoryId:(NSString *)categoryId{
    GKWallClassItemController *vc = [[GKWallClassItemController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.categoryID = categoryId;
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupEmpty:self.collectionView];
    [self setupRefresh:self.collectionView option:ATRefreshDefault];
    // Do any additional setup after loading the view.
}
- (void)refreshData:(NSInteger)page{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"cateId"]   = self.categoryID ?:@"";
    params[@"isDown"]    = @"1";
    params[@"start"]    = @(1+(page-1)*RefreshPageSize);
    params[@"end"]      = @(RefreshPageSize);
    CGRect rect     = [UIScreen mainScreen].bounds;
    NSInteger width = (int) (rect.size.width * 2);
    NSInteger height   = (int) (rect.size.height * 2);
    params[@"imgSize"] = [NSString stringWithFormat:@"%lix%li",(long)width,(long)height];
    [GKHomeNetManager wallCategoryItem:self.categoryID params:params success:^(id  _Nonnull object) {
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
