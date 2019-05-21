//
//  GKSearchViewController.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/14.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKSearchViewController.h"
#import "GKSearchResultController.h"
#import "GKSearchViewCell.h"
@interface GKSearchViewController ()<UISearchBarDelegate>
@property (copy, nonatomic) NSArray *listData;
@end

@implementation GKSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
    // Do any additional setup after loading the view.
}
- (void)loadUI {
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 100, 32)];
    titleView.layer.masksToBounds = YES;
    titleView.layer.cornerRadius = 16;
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:titleView.bounds];
    searchBar.delegate = self;
    searchBar.tintColor = AppColor;
    searchBar.placeholder = @"请输入关键字...";
    searchBar.layer.masksToBounds = YES;
    searchBar.layer.cornerRadius = 16;
    [titleView addSubview:searchBar];
    self.navigationItem.titleView = titleView;
    [self.navigationItem.titleView sizeToFit];
    
    [self setupEmpty:self.tableView];
    [self setupRefresh:self.tableView option:ATHeaderRefresh|ATHeaderAutoRefresh];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (searchBar.text.length == 0) {
        return;
    }
    NSString *content = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    GKSearchModel *model = [GKSearchModel vcWithUserId:[NSString stringWithFormat:@"%ld",(long)time] searchKey:content];
    [GKDataQueue insertDataToDataBase:model completion:^(BOOL success) {
        if (success) {
            [self refreshData:1];
        }
    }];
    [self searchText:content];
    
}
- (void)refreshData:(NSInteger)page{
    [GKDataQueue getDatasFromDataBase:^(NSArray<GKSearchModel *> * _Nonnull listData) {
        self.listData = listData;
        [self.tableView reloadData];
        if (self.listData.count == 0) {
            [self endRefreshFailure];
        }else{
            [self endRefresh:NO];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:@"NotificationSet" object:@{@"count":@(self.listData.count)}];
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GKSearchViewCell *cell = [GKSearchViewCell cellForTableView:tableView indexPath:indexPath];
    GKSearchModel *model = self.listData[indexPath.row];
    cell.titleLab.text = model.searchKey ?:@"";
    cell.subTitleLab.text = [self timeStampTurnToTimesType:model.userId];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GKSearchModel *model = self.listData[indexPath.row];
    [self searchText:model.searchKey];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteAction:self.listData[indexPath.row]];
    }
}
- (void)deleteAction:(GKSearchModel *)model{
    [GKDataQueue deleteDataToDataBase:model.userId completion:^(BOOL success) {
        if (success) {
            [self refreshData:1];
        }
    }];
}
- (void)searchText:(NSString *)searchText{
    GKSearchResultController *vc = [GKSearchResultController vcWithSearchText:searchText];
    [self.navigationController pushViewController:vc animated:YES];
}
- (NSString *)timeStampTurnToTimesType:(NSString *)timesTamp
{
    NSTimeInterval interval    = [timesTamp doubleValue];
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
    NSString *dateString       = [formatter stringFromDate: date];
    if ([dateString hasSuffix:@"00:00"]) {
        NSArray *listData = [dateString componentsSeparatedByString:@" "];
        dateString = listData.firstObject;
    }
    return dateString;
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
