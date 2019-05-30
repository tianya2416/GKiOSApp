//
//  GKWallSearchController.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/14.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKWallSearchController.h"
#import "GKWallSearchResultController.h"
#import "GKNewSearchResultController.h"
#import "GKSearchViewCell.h"
#import "GKSearchTextView.h"
@interface GKWallSearchController ()<UITextFieldDelegate>
@property (strong, nonatomic) NSMutableArray *listData;
@property (assign, nonatomic) GKSearchState state;
@property (strong, nonatomic) GKSearchTextView *searchView;
@end

@implementation GKWallSearchController
+ (instancetype)vcWithSearchState:(GKSearchState)state{
    GKWallSearchController *vc = [[[self class] alloc] init];
    vc.state = state;
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
    // Do any additional setup after loading the view.
}
- (void)loadUI {
    self.fd_prefersNavigationBarHidden = YES;
    if ([self.searchView.textField canBecomeFirstResponder]) {
        [self.searchView.textField becomeFirstResponder];
    }
    [self.view addSubview:self.searchView];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.searchView.superview);
        make.height.offset(NAVI_BAR_HIGHT);
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.tableView.superview);
        make.top.equalTo(self.searchView.mas_bottom);
    }];
    self.listData = @[].mutableCopy;
    [self setupEmpty:self.tableView];
    [self setupRefresh:self.tableView option:ATHeaderRefresh|ATHeaderAutoRefresh];
}
- (void)refreshData:(NSInteger)page{
    
    [GKDataQueue getDatasFromDataBases:^(NSArray<GKSearchModel *> * _Nonnull listData) {
        [self.listData removeAllObjects];
        [listData enumerateObjectsUsingBlock:^(GKSearchModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            (obj.searchState == self.state) ? [self.listData addObject:obj] : nil;
        }];
        self.listData.count ==0 ? [self endRefreshFailure] : [self endRefresh:NO];
        [self.tableView reloadData];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"NotificationSet" object:@{@"count":@(self.listData.count)}];
    }];
}
- (void)goBack:(BOOL)animated{
    [super goBack:NO];
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
    UIViewController *vc = nil;
    vc = self.state == GKSearchWall ? [GKWallSearchResultController vcWithSearchText:searchText] : [GKNewSearchResultController vcWithSearchText:searchText];
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
#pragma mark UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length == 0) {
        return NO;
    }
    NSString *content = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    GKSearchModel *model = [GKSearchModel vcWithUserId:[NSString stringWithFormat:@"%ld",(long)time] searchKey:content state:self.state];
    [GKDataQueue insertDataToDataBase:model completion:^(BOOL success) {
        if (success) {
            [self refreshData:1];
        }
    }];
    [self searchText:content];
    return YES;
}
#pragma mark get
- (GKSearchTextView *)searchView{
    if (!_searchView) {
        _searchView = [GKSearchTextView instanceView];
        _searchView.textField.delegate = self;
        _searchView.backgroundColor = AppColor;
        [_searchView.cancleBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchView;
}
//- (UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}

@end
