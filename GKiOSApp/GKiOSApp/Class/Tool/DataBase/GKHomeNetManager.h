//
//  GKHomeNetManager.h
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/13.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseNetManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface GKHomeNetManager : BaseNetManager
//壁纸
+ (NSURLSessionDataTask *)wallHot:(NSDictionary *)params
                          success:(void(^)(id object))success
                          failure:(void(^)(NSString *error))failure;
+ (NSURLSessionDataTask *)wallCategory:(NSDictionary *)params
                               success:(void(^)(id object))success
                               failure:(void(^)(NSString *error))failure;
+ (NSURLSessionDataTask *)wallCategoryItem:(NSString *)categoryId
                                    params:(NSDictionary *)params
                                   success:(void(^)(id object))success
                                   failure:(void(^)(NSString *error))failure;
+ (NSURLSessionDataTask *)wallSearch:(NSString *)searchText
                              params:(NSDictionary *)params
                             success:(void(^)(id object))success
                             failure:(void(^)(NSString *error))failure;
+ (NSURLSessionDataTask *)wallDetail:(NSString *)gId
                             success:(void(^)(id object))success
                             failure:(void(^)(NSString *error))failure;
//新闻
+ (NSURLSessionDataTask *)newHot:(NSString *)categoryId
                            page:(NSInteger)page
                         success:(void(^)(id object))success
                         failure:(void(^)(NSString *error))failure;
+ (NSURLSessionDataTask *)newsDetail:(NSString *)docid
                             success:(void(^)(id object))success
                             failure:(void(^)(NSString *error))failure;
+ (NSURLSessionDataTask *)apiPhotoSet:(NSString *)photoSetId
                              success:(void(^)(id object))success
                              failure:(void(^)(NSString *error))failure;
+ (NSURLSessionDataTask *)newSearchHotWord:(void(^)(id object))success
                                   failure:(void(^)(NSString *error))failure;
+ (NSURLSessionDataTask *)newSearch:(NSString *)keyWord
                            success:(void(^)(id object))success
                            failure:(void(^)(NSString *error))failure;
//视频

+(NSURLSessionDataTask *)videoHome:(NSInteger)page
                           success:(void (^)(id _Nonnull))success
                           failure:(void (^)(NSString * _Nonnull))failure;
+(NSURLSessionDataTask *)videoList:(NSString *)sId
                              page:(NSInteger)page
                           success:(void (^)(id _Nonnull))success failure:(void (^)(NSString * _Nonnull))failure;
+ (NSURLSessionDataTask *)videoHot:(NSInteger)page
                           success:(void(^)(id object))success
                           failure:(void(^)(NSString *error))failure;
//登录接口
+ (NSURLSessionDataTask *)app_login:(NSString *)account
                           password:(NSString *)password
                            success:(void(^)(id object))success
                            failure:(void(^)(NSString *error))failure;
//开机启动
+ (NSURLSessionDataTask *)appLaunch:(NSTimeInterval )timeStamp
                            success:(void(^)(id object))success
                            failure:(void(^)(NSString *error))failure;

@end

NS_ASSUME_NONNULL_END
