//
//  GKTestViewController.m
//  GKiOSApp
//
//  Created by wangws1990 on 2020/12/11.
//  Copyright © 2020 wangws1990. All rights reserved.
//

#import "GKTestViewController.h"
#import "GKNewItemTableViewCell.h"
@interface GKTestViewController ()

@end

@implementation GKTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupEmpty:self.tableView];
    [self setupRefresh:self.tableView option:ATRefreshNone];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;//UITableViewAutomaticDimension;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

//    GKNewItemTableViewCell *cell =  [GKNewItemTableViewCell cellForTableView:tableView indexPath:indexPath];
//    return cell;
    UITableViewCell *cell =  [UITableViewCell cellForTableView:tableView indexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"UITableViewCell : %@",@(indexPath.row + 1)];
    return cell;
}
@end
