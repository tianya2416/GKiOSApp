//
//  GKCategoryController.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/13.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKCategoryController.h"
#import "GKHomeCategoryModel.h"
#import "GKNewItemTableViewCell.h"
#import "GKCategoryItemController.h"
@interface GKCategoryController()

@property (strong, nonatomic) NSArray *listData;
@end
@implementation GKCategoryController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setupEmpty:self.tableView];
    [self setupRefresh:self.tableView option:ATHeaderRefresh|ATHeaderAutoRefresh];
}
- (void)refreshData:(NSInteger)page{
    [GKHomeNetManager homeCategory:@{} success:^(id  _Nonnull object) {
        self.listData = [NSArray modelArrayWithClass:GKHomeCategoryModel.class json:object[@"classificationlist"]];
        [self.tableView reloadData];
        [self endRefresh:NO];
    } failure:^(NSString * _Nonnull error) {
        [self endRefreshFailure];
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCALEW(100);;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GKNewItemTableViewCell *cell = [GKNewItemTableViewCell cellForTableView:tableView indexPath:indexPath];
    GKHomeCategoryModel *model = self.listData[indexPath.row];
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:model.coverImgUrl]];
    cell.titleLab.text = model.cateName ?:@"";
    cell.subTitleLab.text = model.keyword ?:@"";
    [cell.watchBtn setTitle:model.cateEnglish forState:UIControlStateNormal];
    cell.timeLab.text = model.level ?:@"";
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GKHomeCategoryModel *model = self.listData[indexPath.row];
    GKCategoryItemController *vc = [GKCategoryItemController vcWithCategoryId:model.cateId];
    [vc showNavTitle:model.cateName backItem:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
