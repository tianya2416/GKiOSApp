//
//  GKNewSelectController.h
//  GKiOSApp
//
//  Created by wangws1990 on 2017/5/27.
//  Copyright © 2017 wangws1990. All rights reserved.
//

#import "BaseConnectionController.h"
#import "GKNewModel.h"
@class GKNewSelectController;
@protocol GKNewSelectDelegate<NSObject>
@optional
- (void)viewDidItem:(GKNewSelectController *)vc topModel:(GKNewTopModel *)topModel;
- (void)viewDidLoad:(GKNewSelectController *)vc topModel:(GKNewTopModel *)topModel;
@end
NS_ASSUME_NONNULL_BEGIN

@interface GKNewSelectController : BaseConnectionController
+ (instancetype)vcWithSelect:(GKNewTopModel *)model delegate:(id<GKNewSelectDelegate>)delegate;
@end

NS_ASSUME_NONNULL_END
