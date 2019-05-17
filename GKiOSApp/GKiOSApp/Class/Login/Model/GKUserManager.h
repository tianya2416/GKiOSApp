//
//  GKUserManager.h
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/17.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseModel.h"
#import "GKUserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GKUserManager : BaseModel

@property (strong, nonatomic,readonly) GKUserModel * userModel;

+ (BOOL)saveUserModel:(GKUserModel *)currentUser;

+ (BOOL)loginIn;//判断用户是否已经登录
+ (void)needLogin:(void (^)(BOOL success))completion;

+ (void)login;//选择登录
+ (void)loginOut;//登出
+ (void)loginSuccess;//登录成功
@end

NS_ASSUME_NONNULL_END
