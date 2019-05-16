//
//  GKSearchResultController.h
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/16.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKBaseHomeController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GKSearchResultController : GKBaseHotController
+ (instancetype)vcWithSearchText:(NSString *)searchText;
@end

NS_ASSUME_NONNULL_END
