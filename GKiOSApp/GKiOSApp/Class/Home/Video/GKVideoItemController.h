//
//  GKVideoItemController.h
//  GKiOSApp
//
//  Created by wangws1990 on 2017/5/20.
//  Copyright © 2017 wangws1990. All rights reserved.
//

#import "BaseViewController.h"
#import "GKVideoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GKVideoItemController : BaseViewController

@property (strong, nonatomic)GKVideoModel * model;

- (void)play;
- (void)stop;

@end
NS_ASSUME_NONNULL_END
