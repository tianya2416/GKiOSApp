//
//  GKHomeNetManager.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/13.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKHomeNetManager.h"

@implementation GKHomeNetManager
+ (NSURLSessionDataTask *)homeHot:(NSDictionary *)params
                          success:(void(^)(id object))success
                          failure:(void(^)(NSString *error))failure{
    return [GKHomeNetManager method:HttpMethodGet urlString:kFirsterUrl(@"/v2/homepage") params:params success:success failure:failure];
}
+ (NSURLSessionDataTask *)homeCategory:(NSDictionary *)params
                               success:(void(^)(id object))success
                               failure:(void(^)(NSString *error))failure{
    return [GKHomeNetManager method:HttpMethodGet urlString:kFirsterUrl(@"/v1/wallpaper/category") params:params success:success failure:failure];
}
+ (NSURLSessionDataTask *)homeNews:(NSDictionary *)params
                           success:(void(^)(id object))success
                           failure:(void(^)(NSString *error))failure{
    return [GKHomeNetManager method:HttpMethodGet urlString:kFirsterUrl(@"/v1/wallpaper/wallpaper") params:params success:success failure:failure];
}
@end
