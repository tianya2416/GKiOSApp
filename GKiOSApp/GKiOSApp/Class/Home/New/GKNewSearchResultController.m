//
//  GKNewSearchResultController.m
//  GKiOSApp
//
//  Created by wangws1990 on 2017/5/29.
//  Copyright © 2017 wangws1990. All rights reserved.
//

#import "GKNewSearchResultController.h"
#import "GKNewDetailController.h"
#import "GKNewItemTableViewCell.h"
#import "GKNewSearch.h"
@interface GKNewSearchResultController ()
@property (copy, nonatomic) NSString *keyWord;
@property (strong, nonatomic) NSMutableArray *listData;
@end

@implementation GKNewSearchResultController
+ (instancetype)vcWithSearchText:(NSString *)searchText{
    GKNewSearchResultController *vc = [[[self class] alloc] init];
    vc.keyWord = searchText;
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
}
- (void)loadUI{
    [self showNavTitle:self.keyWord];
    self.listData = @[].mutableCopy;
    [self setupEmpty:self.tableView];
    [self setupRefresh:self.tableView option:ATHeaderRefresh|ATHeaderAutoRefresh];
}
- (void)refreshData:(NSInteger)page{
    [GKHomeNetManager newSearch:self.keyWord success:^(id  _Nonnull object) {
        self.listData = [NSArray modelArrayWithClass:GKNewSearchResult.class json:object[@"doc"][@"result"]].mutableCopy;
        [self.tableView reloadData];
        [self endRefresh:NO];
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
    return SCALEW(105);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GKNewItemTableViewCell *cell = [GKNewItemTableViewCell cellForTableView:tableView indexPath:indexPath];
    GKNewSearchResult *model = self.listData[indexPath.row];
    cell.timeLab.text = model.ptime ?:@"";
    [cell.watchBtn setTitle:[NSString stringWithFormat:@"%@跟帖",model.replyCount?:@""] forState:UIControlStateNormal];
    cell.titleLab.text = model.title ?:@"";
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:placeholdersmall];
    cell.subTitleLab.hidden = YES;
    cell.titleLab.numberOfLines = 3;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GKNewSearchResult *model = self.listData[indexPath.row];
    NSLog(@"%@",model.docid);
    GKNewModel *new = [GKNewModel modelWithJSON:[model modelToJSONObject]];
    GKNewDetailController *vc = [GKNewDetailController vcWithModel:new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
