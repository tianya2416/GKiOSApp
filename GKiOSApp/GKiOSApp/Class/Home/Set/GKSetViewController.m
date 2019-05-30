//
//  GKSetViewController.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/10.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKSetViewController.h"
#import "GKSetTableViewCell.h"
#import "GKLoginViewController.h"

#define kEveryDay @"http://baobab.wandoujia.com/api/v1/feed?num=%d&date=%@&vc=67&u=011f2924aa2cf27aa5dc8066c041fe08116a9a0c&v=4.1.0&f=iphone"


static NSString *about = @"关于我们";
static NSString *video =  @"视频介绍";
static NSString *info =  @"版权信息";
static NSString *tenec = @"清除缓存";
static NSString *loginOut = @"退出登录";
@interface GKSetViewController ()
@property (strong, nonatomic) NSArray *listData;
@property (strong, nonatomic) NSArray *listValue;
@end

@implementation GKSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupEmpty:self.tableView];
    [self setupRefresh:self.tableView option:ATRefreshNone];
    [self headerRefreshing];
    // Do any additional setup after loading the view.
}
- (void)refreshData:(NSInteger)page{
    self.listData = @[about,video,info,tenec,loginOut];
    [self.tableView reloadData];
    [self endRefresh:NO];

    
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
    GKSetTableViewCell *cell = [GKSetTableViewCell cellForTableView:tableView indexPath:indexPath];
    cell.titleLab.text = self.listData[indexPath.row];
    cell.subTitleLab.text = @"";
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *title = self.listData[indexPath.row];
    if ([title isEqualToString:loginOut]) {
        [GKUserManager loginOut];
    }
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
