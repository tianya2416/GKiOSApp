//
//  BaseDataQueue.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/15.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseDataQueue.h"
#import <FMDB.h>

@interface BaseDataQueue()
@property (strong, nonatomic)FMDatabaseQueue *dataQueue;
@end
@implementation BaseDataQueue
+ (instancetype )shareInstance
{
    static BaseDataQueue * dataBase = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!dataBase) {
            dataBase = [[[self class] alloc] init];
        }
    });
    return dataBase;
}
- (instancetype) init
{
    if (self = [super init]) {
        [self createDateBaseQueueTable];
    }
    return self;
}
- (void)createDateBaseQueueTable
{
    [self.dataQueue inDatabase:^(FMDatabase * dataBase) {
        if ([dataBase open]) {
            //数据库建表
            NSString * sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS ContactsChangeFriend (data text,userId text PRIMARY KEY)"];
            [dataBase executeUpdate:sql];
            [dataBase close];
        }
        else
        {
            NSLog(@"dataBase open error");
        }
    }];
}
+ (void)insertDataToDataBase:(NSDictionary *)userInfo completion:(void(^)(BOOL success))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *userId = userInfo[@"userId"];
        if (userId) {
            FMDatabaseQueue *dataQueue = [BaseDataQueue shareInstance].dataQueue;
            [dataQueue inDatabase:^(FMDatabase * db) {
                if ([db open]) {
                    NSData * data = [BaseDataQueue archivedDataForData:userInfo];
                    NSString * v5TableSql = [NSString stringWithFormat:@"insert or replace into ContactsChangeFriend (data,userId) values (?,?)"];
                    BOOL res = [db executeUpdate:v5TableSql withArgumentsInArray:@[data,userId]];
                    [db close];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        !completion ?: completion(res);
                    });
                }
            }];
        }
    });
}
+ (void)updateDataToDataBase:(NSDictionary *)userInfo completion:(void(^)(BOOL success))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *userId = userInfo[@"userId"];
        if (userId) {
            FMDatabaseQueue *dataQueue = [BaseDataQueue shareInstance].dataQueue;
            [dataQueue inDatabase:^(FMDatabase * db) {
                if ([db open]) {
                    NSData * data = [BaseDataQueue archivedDataForData:userInfo];
                    NSString * v5TableSql = [NSString stringWithFormat:@"update ContactsChangeFriend set data = ? where userId = ?"];
                    BOOL res = [db executeUpdate:v5TableSql withArgumentsInArray:@[data,userId]];
                    [db close];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        !completion ?: completion(res);
                    });
                }
            }];
        }
    });
}
+ (void)deleteDataToDataBase:(NSString *)userId completion:(void(^)(BOOL success))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (userId) {
            FMDatabaseQueue *dataQueue = [BaseDataQueue shareInstance].dataQueue;
            [dataQueue inDatabase:^(FMDatabase *db) {
                if ([db open]) {
                    [db beginTransaction];
                    NSString * v5TableSql = [NSString stringWithFormat:@"delete from ContactsChangeFriend where userId = %@",userId];
                    BOOL res = [db executeUpdate:v5TableSql];
                    if (res) {
                        [db commit];
                        NSLog(@"success to delete db table data");
                    }else
                    {
                        NSLog(@"error when delete db table data");
                    }
                    [db close];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        !completion ?: completion(res);
                    });
                }
            }];
        }
    });
}
+ (void)insertDatasDataBase:(NSArray <NSDictionary *>*)listData completion:(void (^)(BOOL))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        FMDatabaseQueue *dataQueue = [BaseDataQueue shareInstance].dataQueue;
        [dataQueue inDatabase:^(FMDatabase * db) {
            if ([db open]) {
                [db beginTransaction];
                for (NSDictionary * userInfo in listData) {
                    NSString *userId = userInfo[@"userId"];
                    if (userId) {
                        NSData * data = [BaseDataQueue archivedDataForData:userInfo];
                        NSString * v5TableSql = [NSString stringWithFormat:@"insert or replace into ContactsChangeFriend (data,userId) values (?,?)"];
                        BOOL res = [db executeUpdate:v5TableSql withArgumentsInArray:@[data,userId]];
                        if (res) {
                            
                        }
                    }
                }
                BOOL success = [db commit];
                [db close];
                dispatch_async(dispatch_get_main_queue(), ^{
                    !completion ?: completion(success);
                });
            }
        }];
    });
    
}
+ (void)getDatasFromDataBase:(void(^)(NSArray <NSDictionary *>*listData))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        FMDatabaseQueue *dataQueue = [BaseDataQueue shareInstance].dataQueue;
        [dataQueue inDatabase:^(FMDatabase *db) {
            if ([db open]) {
                NSString * sql = [NSString stringWithFormat:
                                  @"select * from ContactsChangeFriend order by userId"];
                FMResultSet * rs = [db executeQuery:sql];
                NSData * data;
                NSMutableArray * array = [[NSMutableArray alloc]init];
                while ([rs next])
                {
                    data = [rs dataForColumn:@"data"];
                    [array addObject:[BaseDataQueue unarchiveForData:data]];
                }
                [db close];
                dispatch_async(dispatch_get_main_queue(), ^{
                    !completion ?:completion(array);
                });
            }
        }];
    });
}
+ (void)getDatasFromDataBase:(NSString *)userId completion:(void(^)(NSDictionary *dictionary))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        FMDatabaseQueue *dataQueue = [BaseDataQueue shareInstance].dataQueue;
        [dataQueue inDatabase:^(FMDatabase *db) {
            if ([db open]) {
                NSString * sql = [NSString stringWithFormat:
                                  @"select * from ContactsChangeFriend where userId = %@",userId ?:@""];
                FMResultSet * rs = [db executeQuery:sql];
                NSData * data;
                NSMutableArray * array = [[NSMutableArray alloc]init];
                while ([rs next])
                {
                    data = [rs dataForColumn:@"data"];
                    [array addObject:[BaseDataQueue unarchiveForData:data]];
                }
                [db close];
                dispatch_async(dispatch_get_main_queue(), ^{
                    !completion ?:completion(array.firstObject);
                });
            }
        }];
    });
}
+ (void)dropTheTableGroupDataBase:(void (^)(BOOL))completion
{
    FMDatabaseQueue *dataQueue = [BaseDataQueue shareInstance].dataQueue;
    [dataQueue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString * sqlstr = [NSString stringWithFormat:@"drop table ContactsChangeFriend"];
            BOOL res =  [db executeUpdate:sqlstr];
            if (res) {
                NSLog(@"drop table successful");
            }else
            {
                NSLog(@"drop table fail");
            }
            [db close];
            !completion ?: completion(res);
        }
    }];
}
+ (NSData *)archivedDataForData:(NSDictionary *)data
{
    NSData * resData = nil;
    @try {
        resData = [NSKeyedArchiver archivedDataWithRootObject:data];
    }
    @catch (NSException *exception) {
        NSLog(@"%s,%d,%@", __FUNCTION__, __LINE__, exception.description);
        resData = nil;
    }
    @finally {
        
    }
    return resData;
}
+ (id)unarchiveForData:(NSData*)data
{
    id resObj = nil;
    @try {
        resObj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    @catch (NSException *exception) {
        NSLog(@"%s,%d,%@", __FUNCTION__, __LINE__, exception.description);
        resObj = nil;
    }
    @finally {
        
    }
    return resObj;
}
#pragma mark 属性
- (FMDatabaseQueue *)dataQueue
{
    if (!_dataQueue) {
        NSString * stringPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/House"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:stringPath]) {
            BOOL res = [[NSFileManager defaultManager]createDirectoryAtPath:stringPath withIntermediateDirectories:YES attributes:nil error:nil];
            if (res) {
                NSLog(@"create successful");
            }
        }
        //        NSString *stringPath =[[ [NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.yzdmycd"] absoluteString];
        NSString * dbPatch = [stringPath stringByAppendingPathComponent:@"FDDataBase.sqlite"];
        _dataQueue = [FMDatabaseQueue databaseQueueWithPath:dbPatch];
    }
    return _dataQueue;
}
@end
