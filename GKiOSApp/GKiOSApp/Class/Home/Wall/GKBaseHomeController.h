//
//  GKBaseHomeController.h
//  GKiOSApp
//
//  Created by wangws1990 on 2017/5/10.
//  Copyright © 2017 wangws1990. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GKBaseHomeController : BaseViewController

@end

@interface GKBaseHotController : BaseConnectionController

@property (strong, nonatomic) NSMutableArray *listData;

@end

NS_ASSUME_NONNULL_END
