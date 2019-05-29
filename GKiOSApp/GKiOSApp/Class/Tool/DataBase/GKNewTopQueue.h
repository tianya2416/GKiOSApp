//
//  GKNewTopQueue.h
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/28.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GKNewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GKNewTopQueue : NSObject
/**
 *  @brief 插入数据
 */
+ (void)insertDataToDataBase:(GKNewTopModel *)model completion:(void(^)(BOOL success))completion;
/**
 *  @brief 更新数据
 */
+ (void)updateDataToDataBase:(GKNewTopModel *)model completion:(void(^)(BOOL success))completion;
/**
 *  @brief 删除数据
 */
+ (void)deleteDataToDataBase:(NSString *)userId completion:(void(^)(BOOL success))completion;
/**
 *  @brief 使用事务来处理批量插入数据问题 效率比较高
 */
+ (void)insertDatasDataBase:(NSArray <GKNewTopModel *>*)listData completion:(void(^)(BOOL success))completion;
/**
 *  @brief 获取数据
 */
+ (void)getDatasFromDataBase:(void(^)(NSArray <GKNewTopModel *>*listData))completion;
+ (void)getDatasFromDataBase:(NSString *)userId completion:(void(^)(GKNewTopModel *model))completion;
/**
 *  @brief 删除表
 */
+ (void)dropTheTableGroupDataBase:(void (^)(BOOL))completion;
@end

NS_ASSUME_NONNULL_END
