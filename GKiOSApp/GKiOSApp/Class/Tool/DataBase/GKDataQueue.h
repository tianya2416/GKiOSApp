//
//  GKDataQueue.h
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/15.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseDataQueue.h"
#import "GKSearchModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GKDataQueue : NSObject
+ (void)insertDataToDataBase:(GKSearchModel *)model completion:(void(^)(BOOL success))completion;

+ (void)updateDataToDataBase:(GKSearchModel *)model completion:(void(^)(BOOL success))completion;
/**
 *  @brief 删除数据
 */
+ (void)deleteDataToDataBase:(NSString *)userId completion:(void(^)(BOOL success))completion;
/**
 *  @brief 使用事务来处理批量插入数据问题 效率比较高
 */
+ (void)insertDatasDataBase:(NSArray <GKSearchModel *>*)listData completion:(void(^)(BOOL success))completion;
/**
 *  @brief 获取数据
 */
+ (void)getDatasFromDataBase:(void(^)(NSArray <GKSearchModel *>*listData))completion;
+ (void)getDatasFromDataBase:(NSString *)userId completion:(void(^)(GKSearchModel *model))completion;
/**
 *  @brief 删除表
 */
+ (void)dropTheTableGroupDataBase:(void (^)(BOOL))completion;
@end

NS_ASSUME_NONNULL_END
