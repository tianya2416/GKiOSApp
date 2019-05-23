//
//  GKNewItemViewController.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/16.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKNewItemViewController.h"
#import "GKNewItemTableViewCell.h"
#import "GKNewItemAdCell.h"
#import "GKNewItemImageCell.h"
#import "GKNewItemTraCell.h"
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
    GKNewsModel *model = self.listData[indexPath.row];
    return model.cellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GKNewsModel *model = self.listData[indexPath.row];
    switch (model.states) {
        case GKNewsImgexType:
        {
            GKNewItemImageCell *cell =  [GKNewItemImageCell cellForTableView:tableView indexPath:indexPath];
            cell.model = self.listData[indexPath.row];
            return cell;
        }break;
        case GKNewsAdvertise:
        {
            GKNewItemAdCell *cell =  [GKNewItemAdCell cellForTableView:tableView indexPath:indexPath];
            cell.model = self.listData[indexPath.row];
            return cell;
        }break;
        case GKNewsImgextra:
        {
            GKNewItemTraCell *cell =  [GKNewItemTraCell cellForTableView:tableView indexPath:indexPath];
            cell.model = self.listData[indexPath.row];
            return cell;
        }break;
        default:
        {
            GKNewItemTableViewCell *cell =  [GKNewItemTableViewCell cellForTableView:tableView indexPath:indexPath];
            cell.model = self.listData[indexPath.row];
            return cell;
        }break;
    }
    UITableViewCell *cell =  [UITableViewCell cellForTableView:tableView indexPath:indexPath];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GKNewsModel *model = self.listData[indexPath.row];
    NSLog(@"%@ %@",model.title,model.digest);
}
@end
