//
//  GKNewSearchController.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/30.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKNewSearchController.h"
#import "GKNewSearchResultController.h"
#import "GKNewSearchHeadView.h"
#import "GKSearchTextView.h"
#import "GKNewSearchCell.h"
#import "GKNewSearch.h"

@interface GKNewSearchController ()<UITextFieldDelegate>
@property (strong, nonatomic) GKSearchTextView *searchView;
@property (strong, nonatomic) NSArray <GKNewHotWord *>*listHotWords;
@property (strong, nonatomic) NSMutableArray <GKSearchModel *>*listData;
@end

@implementation GKNewSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
    // Do any additional setup after loading the view.
}
- (void)loadUI{
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
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    [GKHomeNetManager newSearchHotWord:^(id  _Nonnull object) {
        self.listHotWords = [NSArray modelArrayWithClass:GKNewHotWord.class json:object[@"hotWordList"]];
        dispatch_group_leave(group);
        
    } failure:^(NSString * _Nonnull error) {
        dispatch_group_leave(group);
    }];
    dispatch_group_enter(group);
    [GKDataQueue getDatasFromDataBases:^(NSArray<GKSearchModel *> * _Nonnull listData) {
        [self.listData removeAllObjects];
        [listData enumerateObjectsUsingBlock:^(GKSearchModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            (obj.searchState == GKSearchNew) ? [self.listData addObject:obj] : nil;
        }];
        dispatch_group_leave(group);
    }];
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (self.listData.count || self.listHotWords.count) {
            [self endRefresh:NO];
            [self.tableView reloadData];
        }else{
            [self endRefreshFailure];
        }
    });
}
- (void)deleteAction{
    [ATAlertView showTitle:@"是否删除所有历史记录" message:@"" normalButtons:@[@"取消"] highlightButtons:@[@"确定"] completion:^(NSUInteger index, NSString *buttonTitle) {
        if (index > 0) {
            [GKDataQueue deleteDataToDataBases:self.listData completion:^(BOOL success) {
                if (success) {
                    [self.listData removeAllObjects];
                    [self.tableView reloadData];
                }
            }];
        }
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section ==0 ? self.listHotWords.count : self.listData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? (self.listHotWords.count ? 30 : 0.001) : (self.listData.count ? 30 : 0.001);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    GKNewSearchHeadView *headView = [[GKNewSearchHeadView alloc] init];
    headView.titleLab.text = section == 0 ? @"热门推荐":@"历史记录";
    headView.deleteBtn.hidden = section == 0;
    [headView.deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    headView.hidden = (section == 0) ? (self.listHotWords.count ? NO : YES) : (self.listData.count ? NO : YES);
    return headView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GKNewSearchCell *cell = [GKNewSearchCell cellForTableView:tableView indexPath:indexPath];
    id object = indexPath.section == 0 ? self.listHotWords[indexPath.row]  : self.listData[indexPath.row];
    cell.commenBtn.hidden = YES;
    if ([object isKindOfClass:GKNewHotWord.class]) {
        GKNewHotWord *hotModel = object;
        cell.titleLab.text = hotModel.hotWord ?:@"";
        cell.commenBtn.hidden = indexPath.row != 0;
    }else{
        GKSearchModel *model = object;
        cell.titleLab.text = model.searchKey ?:@"";
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *keyWord = indexPath.section == 0 ? self.listHotWords[indexPath.row].searchWord  : self.listData[indexPath.row].searchKey;
    GKNewSearchResultController *vc = [GKNewSearchResultController vcWithSearchText:keyWord];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.searchView.textField canResignFirstResponder]) {
        [self.searchView.textField resignFirstResponder];
    }
}
#pragma mark UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length == 0) {
        [textField resignFirstResponder];
        return NO;
    }
    NSString *content = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    GKSearchModel *model = [GKSearchModel vcWithUserId:[NSString stringWithFormat:@"%ld",(long)time] searchKey:content state:GKSearchNew];
    [GKDataQueue insertDataToDataBase:model completion:^(BOOL success) {
        if (success) {
            [self refreshData:1];
        }
    }];
    [self searchText:content];
    return YES;
}
- (void)searchText:(NSString *)searchText{
    UIViewController *vc  = [GKNewSearchResultController vcWithSearchText:searchText];
    [self.navigationController pushViewController:vc animated:YES];
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
