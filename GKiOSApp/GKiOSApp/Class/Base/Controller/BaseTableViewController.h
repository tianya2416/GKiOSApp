//
//  BaseTableViewController.h
//  MyCountDownDay
//
//  Created by wangws1990 on 2017/1/21.
//  Copyright © 2017 wangws1990. All rights reserved.
//

#import "BaseRefreshController.h"
NS_ASSUME_NONNULL_BEGIN

@interface BaseTableViewController : BaseRefreshController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@end
@interface BaseEmptyTableController : BaseTableViewController

@end
NS_ASSUME_NONNULL_END
