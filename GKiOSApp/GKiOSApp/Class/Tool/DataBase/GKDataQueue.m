//
//  GKDataQueue.m
//  GKiOSApp
//
//  Created by wangws1990 on 2017/5/15.
//  Copyright © 2017 wangws1990. All rights reserved.
//

#import "GKDataQueue.h"
static NSString *tableName = @"SearchTable";
static NSString *primaryId1 = @"userId";
@implementation GKDataQueue
+ (void)insertDataToDataBase:(GKSearchModel *)model completion:(void(^)(BOOL success))completion{
    NSDictionary *userInfo = [model modelToJSONObject];
    [BaseDataQueue insertDataToDataBase:tableName primaryId:primaryId1 userInfo:userInfo completion:completion];
}
/**
 *  @brief 使用事务来处理批量插入数据问题 效率比较高
 */
+ (void)insertDataToDataBases:(NSArray <GKSearchModel *>*)listData completion:(void(^)(BOOL success))completion{
    [BaseDataQueue insertDatasDataBase:tableName primaryId:primaryId1 listData:[listData modelToJSONObject] completion:completion];
}
+ (void)updateDataToDataBase:(GKSearchModel *)model completion:(void(^)(BOOL success))completion{
    NSDictionary *userInfo = [model modelToJSONObject];
    [BaseDataQueue updateDataToDataBase:tableName primaryId:primaryId1 userInfo:userInfo completion:completion];
}
/**
 *  @brief 删除数据
 */
+ (void)deleteDataToDataBase:(NSString *)userId completion:(void(^)(BOOL success))completion{
    [BaseDataQueue deleteDataToDataBase:tableName primaryId:primaryId1 primaryValue:userId completion:completion];
}
+ (void)deleteDataToDataBases:(NSArray <GKSearchModel *>*)listData completion:(void(^)(BOOL success))completion{
    [BaseDataQueue deleteDataToDataBase:tableName primaryId:primaryId1 listData:[listData modelToJSONObject] completion:completion];
}

/**
 *  @brief 获取数据
 */
+ (void)getDatasFromDataBases:(void(^)(NSArray <GKSearchModel *>*listData))completion{
    [BaseDataQueue getDatasFromDataBase:tableName primaryId:primaryId1 completion:^(NSArray<NSDictionary *> * _Nonnull listData) {
        NSArray *datas = [NSArray modelArrayWithClass:GKSearchModel.class json:listData];
        !completion ?: completion(datas);
    }];
}
+ (void)getDatasFromDataBase:(NSString *)userId completion:(void(^)(GKSearchModel *model))completion{
    [BaseDataQueue getDatasFromDataBase:tableName primaryId:primaryId1 primaryValue:userId completion:^(NSDictionary * _Nonnull dictionary) {
        GKSearchModel *info = [GKSearchModel modelWithJSON:dictionary];
        !completion ?: completion(info);
    }];
}
/**
 *  @brief 删除表
 */
+ (void)dropTheTableGroupDataBase:(void (^)(BOOL))completion{
    [BaseDataQueue dropTableDataBase:tableName completion:completion];
}
@end
