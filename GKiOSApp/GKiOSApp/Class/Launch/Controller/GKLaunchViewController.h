//
//  GKLaunchViewController.h
//  GKiOSApp
//
//  Created by wangws1990 on 2017/5/24.
//  Copyright © 2017 wangws1990. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GKLaunchViewController : BaseViewController
+ (instancetype)vcWithCompletion:(void(^)(void))completion;
@end

NS_ASSUME_NONNULL_END
