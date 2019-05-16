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
+ (NSURLSessionDataTask *)homeHot:(NSDictionary *)params
                          success:(void(^)(id object))success
                          failure:(void(^)(NSString *error))failure;
+ (NSURLSessionDataTask *)homeCategory:(NSDictionary *)params
                               success:(void(^)(id object))success
                               failure:(void(^)(NSString *error))failure;
+ (NSURLSessionDataTask *)homeNews:(NSDictionary *)params
                           success:(void(^)(id object))success
                           failure:(void(^)(NSString *error))failure;

+ (NSURLSessionDataTask *)homeSearch:(NSString *)searchText
                              params:(NSDictionary *)params
                             success:(void(^)(id object))success
                             failure:(void(^)(NSString *error))failure;
+ (NSURLSessionDataTask *)newHot:(NSString *)categoryId
                            page:(NSInteger)page
                         success:(void(^)(id object))success
                         failure:(void(^)(NSString *error))failure;
@end

NS_ASSUME_NONNULL_END
