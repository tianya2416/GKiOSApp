//
//  GKNewSearchResultController.h
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/29.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GKNewSearchResultController : BaseTableViewController
+ (instancetype)vcWithSearchText:(NSString *)searchText;
@end

NS_ASSUME_NONNULL_END
