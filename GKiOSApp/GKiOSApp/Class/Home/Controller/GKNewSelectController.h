//
//  GKNewSelectController.h
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/27.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseConnectionController.h"
#import "GKNewsModel.h"
@class GKNewSelectController;
@protocol GKNewSelectDelegate<NSObject>
@optional
- (void)viewDidItem:(GKNewSelectController *)vc topModel:(GKNewsTopModel *)topModel;
- (void)viewDidLoad:(GKNewSelectController *)vc topModel:(GKNewsTopModel *)topModel;
@end
NS_ASSUME_NONNULL_BEGIN

@interface GKNewSelectController : BaseConnectionController
+ (instancetype)vcWithSelect:(GKNewsTopModel *)model delegate:(id<GKNewSelectDelegate>)delegate;
@end

NS_ASSUME_NONNULL_END
