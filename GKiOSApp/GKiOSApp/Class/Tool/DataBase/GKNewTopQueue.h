//
//  GKNewTopQueue.h
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/28.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GKNewsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GKNewTopQueue : NSObject
/**
 *  @brief 插入数据
 */
+ (void)insertDataToDataBase:(GKNewsTopModel *)model completion:(void(^)(BOOL success))completion;
/**
 *  @brief 更新数据
 */
+ (void)updateDataToDataBase:(GKNewsTopModel *)model completion:(void(^)(BOOL success))completion;
/**
 *  @brief 删除数据
 */
+ (void)deleteDataToDataBase:(NSString *)userId completion:(void(^)(BOOL success))completion;
/**
 *  @brief 使用事务来处理批量插入数据问题 效率比较高
 */
+ (void)insertDatasDataBase:(NSArray <GKNewsTopModel *>*)listData completion:(void(^)(BOOL success))completion;
/**
 *  @brief 获取数据
 */
+ (void)getDatasFromDataBase:(void(^)(NSArray <GKNewsTopModel *>*listData))completion;
+ (void)getDatasFromDataBase:(NSString *)userId completion:(void(^)(GKNewsTopModel *model))completion;
/**
 *  @brief 删除表
 */
+ (void)dropTheTableGroupDataBase:(void (^)(BOOL))completion;
@end

NS_ASSUME_NONNULL_END
