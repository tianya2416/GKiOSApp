//
//  GKNewsDetailController.h
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/24.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseWebController.h"
#import "GKNewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GKNewDetailController : BaseWebController
+ (instancetype)vcWithModel:(GKNewModel *)model;
@end

NS_ASSUME_NONNULL_END
