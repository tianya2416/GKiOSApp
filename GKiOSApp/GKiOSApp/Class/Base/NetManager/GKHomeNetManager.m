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
    return [GKHomeNetManager method:HttpMethodGet urlString:kUrlService(@"/v2/homepage") params:params success:success failure:failure];
}
+ (NSURLSessionDataTask *)homeCategory:(NSDictionary *)params
                               success:(void(^)(id object))success
                               failure:(void(^)(NSString *error))failure{
    return [GKHomeNetManager method:HttpMethodGet urlString:kUrlService(@"/v1/wallpaper/category") params:params success:success failure:failure];
}
+ (NSURLSessionDataTask *)homeNews:(NSDictionary *)params
                           success:(void(^)(id object))success
                           failure:(void(^)(NSString *error))failure{
    return [GKHomeNetManager method:HttpMethodGet urlString:kUrlService(@"/v1/wallpaper/wallpaper") params:params success:success failure:failure];
}
+ (NSURLSessionDataTask *)homeSearch:(NSString *)searchText
                              params:(NSDictionary *)params
                             success:(void(^)(id object))success
                             failure:(void(^)(NSString *error))failure{
    
    NSString *urlString = [NSString stringWithFormat:@"/v1/search/all/resource/%@?",searchText?:@""];
    return [GKHomeNetManager method:HttpMethodGet urlString:kUrlSo(urlString) params:params success:success failure:failure];
}

+ (NSURLSessionDataTask *)newHot:(NSString *)categoryId
                            page:(NSInteger)page
                         success:(void(^)(id object))success
                         failure:(void(^)(NSString *error))failure{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@category_ids=%@&max_id=0&count=%@", URL_News, categoryId?:@"",@(20)];
    return [GKHomeNetManager method:HttpMethodGet urlString:urlStr params:nil success:success failure:failure];
}
@end
