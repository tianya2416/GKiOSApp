//
//  GKNewTopQueue.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/28.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKNewTopQueue.h"
static NSString *topTableName = @"NewTopTable";
static NSString *primaryId1 = @"userId";
@implementation GKNewTopQueue
+ (void)insertDataToDataBase:(GKNewsTopModel *)model completion:(void(^)(BOOL success))completion{
    NSDictionary *userInfo = [model modelToJSONObject];
    [BaseDataQueue insertDataToDataBase:topTableName primaryId:primaryId1 userInfo:userInfo completion:completion];
}
+ (void)updateDataToDataBase:(GKNewsTopModel *)model completion:(void(^)(BOOL success))completion{
    NSDictionary *userInfo = [model modelToJSONObject];
    [BaseDataQueue updateDataToDataBase:topTableName primaryId:primaryId1 userInfo:userInfo completion:completion];
}
/**
 *  @brief 删除数据
 */
+ (void)deleteDataToDataBase:(NSString *)userId completion:(void(^)(BOOL success))completion{
    [BaseDataQueue deleteDataToDataBase:topTableName primaryId:primaryId1 primaryValue:userId completion:completion];
}
/**
 *  @brief 使用事务来处理批量插入数据问题 效率比较高
 */
+ (void)insertDatasDataBase:(NSArray <GKNewsTopModel *>*)listData completion:(void(^)(BOOL success))completion{
    NSMutableArray *arrayData = [[NSMutableArray alloc] init];
    [listData enumerateObjectsUsingBlock:^(GKNewsTopModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arrayData addObject:[obj modelToJSONObject]];
    }];
    [BaseDataQueue insertDatasDataBase:topTableName primaryId:primaryId1 listData:arrayData completion:completion];
}

/**
 *  @brief 获取数据
 */
+ (void)getDatasFromDataBase:(void(^)(NSArray <GKNewsTopModel *>*listData))completion{
    [BaseDataQueue getDatasFromDataBase:topTableName primaryId:primaryId1 completion:^(NSArray<NSDictionary *> * _Nonnull listData) {
        NSArray *datas = [NSArray modelArrayWithClass:GKNewsTopModel.class json:listData];
        !completion ?: completion([GKNewTopQueue sortedArrayUsingComparator:datas key:nil ascending:YES]);
    }];
}
+ (void)getDatasFromDataBase:(NSString *)userId completion:(void(^)(GKNewsTopModel *model))completion{
    [BaseDataQueue getDatasFromDataBase:topTableName primaryId:primaryId1 primaryValue:userId completion:^(NSDictionary * _Nonnull dictionary) {
        GKNewsTopModel *info = [GKNewsTopModel modelWithJSON:dictionary];
        !completion ?: completion(info);
    }];
}
/**
 *  @brief 删除表
 */
+ (void)dropTheTableGroupDataBase:(void (^)(BOOL))completion{
    [BaseDataQueue dropTableDataBase:topTableName completion:completion];
}
+ (NSArray *)sortedArrayUsingComparator:(NSArray <GKNewsTopModel *>*)listData key:(NSString *)key ascending:(BOOL)ascending
{
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:key?:@"sort" ascending:ascending];
    return [listData sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
}
@end
