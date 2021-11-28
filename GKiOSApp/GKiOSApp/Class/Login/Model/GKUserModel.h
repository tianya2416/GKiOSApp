//
//  GKUserModel.h
//  GKiOSApp
//
//  Created by wangws1990 on 2017/5/17.
//  Copyright © 2017 wangws1990. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GKUserModel : BaseModel

#pragma mark 用户相关
@property (copy, nonatomic) NSString *name;
//角色id
@property (copy, nonatomic) NSString *role_id;
//登录id
@property (copy, nonatomic) NSString *login_id;
//登录状态
@property (copy, nonatomic) NSString *login_state;
//名称
@property (copy, nonatomic) NSString *role_name;
@property (copy, nonatomic) NSString *sex;
@property (copy, nonatomic) NSString *shangchang;
@property (copy, nonatomic) NSString *tel;
//诊金
@property (copy, nonatomic) NSString *zhenjin;

#pragma mark 诊所相关
@property (copy, nonatomic) NSString *admin_name;
@property (copy, nonatomic) NSString *fendian_id;
@property (copy, nonatomic) NSString *fendian_jianjie;
@property (copy, nonatomic) NSString *fendian_name;
@property (copy, nonatomic) NSString *fendian_yuyue_tel;
@property (copy, nonatomic) NSString *fendian_address;
@property (copy, nonatomic) NSString *fendian_address2;
@property (copy, nonatomic) NSString *fendian_mail;
@property (copy, nonatomic) NSString *jianjie;

#pragma mark 图片相关
@property (copy, nonatomic) NSString *pic_0;
@property (copy, nonatomic) NSString *pic_1;
@property (copy, nonatomic) NSString *pic_2;
@property (copy, nonatomic) NSString *pic_3;
@property (copy, nonatomic) NSString *pic_head;
@property (copy, nonatomic) NSString *pic_weixin;
@property (copy, nonatomic) NSString *pic_zhifubao;

#pragma mark
@property (copy, nonatomic) NSString *fee_month_sum;
@property (copy, nonatomic) NSString *fee_month_sum_self;
@property (copy, nonatomic) NSString *fee_sum;
@property (copy, nonatomic) NSString *fee_sum_self;
@property (copy, nonatomic) NSString *fee_today_sum;
@property (copy, nonatomic) NSString *fee_today_sum_self;

#pragma mark 时间相关
@property (copy, nonatomic) NSString *reg_datetime;//注册时间
@property (copy, nonatomic) NSString *dead_datetime;//到期时间
//在线预约
@property (copy, nonatomic) NSString *yuyue_url;//到期时间

@end

NS_ASSUME_NONNULL_END
