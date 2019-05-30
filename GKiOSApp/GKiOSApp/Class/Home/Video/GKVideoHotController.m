//
//  GKVideoHotController.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/30.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKVideoHotController.h"
#import "GKVideoModel.h"
#import "GKNewItemAdCell.h"

#import <ZFPlayer.h>
#import <ZFPlayerController.h>
//#import <<#header#>>
//#import <ZFPlayer/ZFPlayer.h>
//#import <ZFPlayer/ZFAVPlayerManager.h>
//#import <ZFPlayer/ZFIJKPlayerManager.h>
//#import <ZFPlayer/KSMediaPlayerManager.h>

@interface GKVideoHotController ()
@property (strong, nonatomic) NSArray *listData;

//@property (nonatomic, strong) ZFPlayerController *player;
//@property (nonatomic, strong) ZFPlayerControlView *controlView;
@end

@implementation GKVideoHotController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupEmpty:self.tableView];
    [self setupRefresh:self.tableView option:ATHeaderRefresh|ATHeaderAutoRefresh];
}
- (void)refreshData:(NSInteger)page{
    [GKHomeNetManager videoHot:page success:^(id  _Nonnull object) {
        self.listData = [NSArray modelArrayWithClass:GKVideoHotModel.class json:object[@"itemList"]];
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
    return UITableViewAutomaticDimension;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GKNewItemAdCell *cell = [GKNewItemAdCell cellForTableView:tableView indexPath:indexPath];
    cell.model = self.listData[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
