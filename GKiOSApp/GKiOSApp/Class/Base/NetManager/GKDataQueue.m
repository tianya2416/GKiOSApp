//
//  GKDataQueue.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/15.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKDataQueue.h"

@implementation GKDataQueue
+ (void)insertDataToDataBase:(GKSearchModel *)model completion:(void(^)(BOOL success))completion{
    NSDictionary *userInfo = [model modelToJSONObject];
    [BaseDataQueue insertDataToDataBase:userInfo completion:completion];
}
+ (void)updateDataToDataBase:(GKSearchModel *)model completion:(void(^)(BOOL success))completion{
    NSDictionary *userInfo = [model modelToJSONObject];
    [BaseDataQueue updateDataToDataBase:userInfo completion:completion];
}
/**
 *  @brief 删除数据
 */
+ (void)deleteDataToDataBase:(NSString *)userId completion:(void(^)(BOOL success))completion{
    [BaseDataQueue deleteDataToDataBase:userId completion:completion];
}
/**
 *  @brief 使用事务来处理批量插入数据问题 效率比较高
 */
+ (void)insertDatasDataBase:(NSArray <GKSearchModel *>*)listData completion:(void(^)(BOOL success))completion{
    NSMutableArray *arrayData = [[NSMutableArray alloc] init];
    [listData enumerateObjectsUsingBlock:^(GKSearchModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arrayData addObject:[obj modelToJSONObject]];
    }];
    [BaseDataQueue insertDatasDataBase:arrayData completion:completion];
}

/**
 *  @brief 获取数据
 */
+ (void)getDatasFromDataBase:(void(^)(NSArray <GKSearchModel *>*listData))completion{
    [BaseDataQueue getDatasFromDataBase:^(NSArray<NSDictionary *> * _Nonnull listData) {
        NSArray *datas = [NSArray modelArrayWithClass:GKSearchModel.class json:listData];
        !completion ?: completion(datas);
    }];
}
+ (void)getDatasFromDataBase:(NSString *)userId completion:(void(^)(GKSearchModel *model))completion{
    [BaseDataQueue getDatasFromDataBase:userId completion:^(NSDictionary * _Nonnull dictionary) {
        GKSearchModel *info = [GKSearchModel modelWithJSON:dictionary];
        !completion ?: completion(info);
    }];
}
/**
 *  @brief 删除表
 */
+ (void)dropTheTableGroupDataBase:(void (^)(BOOL))completion{
    [BaseDataQueue dropTheTableGroupDataBase:completion];
}
@end
