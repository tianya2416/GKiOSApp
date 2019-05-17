//
//  GKCategoryItemController.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/16.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKCategoryItemController.h"
#import "GKHomeCategoryModel.h"
@interface GKCategoryItemController ()
@property (nonatomic, strong) NSString *categoryID;
@end

@implementation GKCategoryItemController
+ (instancetype)vcWithCategoryId:(NSString *)categoryId{
    GKCategoryItemController *vc = [[GKCategoryItemController alloc] init];
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
    NSDictionary *params = @{
                             @"order": @"new",
                             @"adult": @"false",
                             @"first": @(page),
                             @"limit": @(30)
                             };
    [GKHomeNetManager homeCategory:self.categoryID params:params success:^(id  _Nonnull object) {
        self.listData = [NSArray modelArrayWithClass:GKHomeCategoryModel.class json:object[@"wallpaper"]].mutableCopy;
        [self.collectionView reloadData];
        [self endRefresh:NO];
    } failure:^(NSString * _Nonnull error) {
        [self endRefreshFailure];
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
