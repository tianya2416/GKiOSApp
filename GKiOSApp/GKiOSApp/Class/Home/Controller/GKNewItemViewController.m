//
//  GKNewItemViewController.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/16.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKNewItemViewController.h"
#import "GKNewItemTableViewCell.h"
#import "GKNewsModel.h"
@interface GKNewItemViewController()
@property (strong, nonatomic) NSMutableArray *listData;
@end
@implementation GKNewItemViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.listData = @[].mutableCopy;
    [self setupEmpty:self.tableView];
    [self setupRefresh:self.tableView option:ATRefreshDefault];

}
- (void)setCategoryId:(NSString *)categoryId{
    _categoryId = categoryId;
    [self refreshData:1];
}
- (void)refreshData:(NSInteger)page{
    [GKHomeNetManager newHot:self.categoryId page:page success:^(id  _Nonnull object) {
        NSLog(@"====%@",object);
        if (page == 1) {
            [self.listData removeAllObjects];
        }
        NSArray *datas = [NSArray modelArrayWithClass:GKNewsModel.class json:object[self.categoryId]];
        [self.listData addObjectsFromArray:datas];
        [self.tableView reloadData];
        [self endRefresh:datas.count >=20];
    } failure:^(NSString * _Nonnull error) {
        [self endRefreshFailure];
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCALEW(100);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GKNewItemTableViewCell *cell =  [GKNewItemTableViewCell cellForTableView:tableView indexPath:indexPath];
    cell.model = self.listData[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
