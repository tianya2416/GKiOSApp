//
//  GKLaunchModel.h
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/24.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@class GKLaunchActionModel;
@interface GKLaunchModel : BaseModel

@property (strong, nonnull) NSArray *res_url;//图片地址
@property (strong, nonnull) NSArray *link_url;//跳转地址
@property (copy, nonnull) NSString *show_time;//显示时间
@property (copy, nonnull) NSString *show_num;
@property (copy, nonnull) NSString *sub_title;
@property (copy, nonnull) NSString *main_title;
@property (strong, nonatomic) GKLaunchActionModel *action_params;

@end
@interface GKLaunchActionModel : BaseModel
@property (copy, nonnull) NSString *closeOpener;
@property (copy, nonnull) NSString *fullscreen;
@property (copy, nonnull) NSString *link_url;
@end
NS_ASSUME_NONNULL_END
