//
//  GKHomeNetManager.m
//  GKiOSApp
//
//  Created by wangws1990 on 2017/5/13.
//  Copyright © 2017 wangws1990. All rights reserved.
//

#import "GKHomeNetManager.h"

@implementation GKHomeNetManager
+ (NSURLSessionDataTask *)wallHot:(NSDictionary *)params
                          success:(void(^)(id object))success
                          failure:(void(^)(NSString *error))failure{
    //宝贝
    return [GKHomeNetManager method:HttpMethodPost urlString:kUrlWall(@"corp/bizhiClient/getGroupInfo.php?isAttion=1") params:params success:success failure:failure];
}
+ (NSURLSessionDataTask *)wallCategory:(NSDictionary *)params
                               success:(void(^)(id object))success
                               failure:(void(^)(NSString *error))failure{
     return [GKHomeNetManager method:HttpMethodPost urlString:kUrlWall(@"corp/bizhiClient/getCateInfo.php") params:params success:success failure:failure];
}
+ (NSURLSessionDataTask *)wallCategoryItem:(NSString *)categoryId
                                    params:(NSDictionary *)params
                                   success:(void(^)(id object))success
                                   failure:(void(^)(NSString *error))failure{
     return [GKHomeNetManager method:HttpMethodPost urlString:kUrlWall(@"corp/bizhiClient/getGroupInfo.php") params:params success:success failure:failure];
}
+ (NSURLSessionDataTask *)wallSearch:(NSString *)searchText
                              params:(NSDictionary *)params
                             success:(void(^)(id object))success
                             failure:(void(^)(NSString *error))failure{
    
    return [GKHomeNetManager method:HttpMethodPost urlString:kUrlWall(@"corp/bizhiClient/getSearchInfo.php") params:params success:success failure:failure];
}
+ (NSURLSessionDataTask *)wallDetail:(NSString *)gId
                             success:(void(^)(id object))success
                             failure:(void(^)(NSString *error))failure{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"gId"]= gId ?:@"";
    CGRect rect = [UIScreen mainScreen].bounds;
    NSInteger width = (int) (rect.size.width * 2);
    NSInteger height = (int) (rect.size.height * 2);
    width = height < 961 ? 320 : 480;
    height = height < 961 ? 480 : 854;
    params[@"picSize"] = [NSString stringWithFormat:@"%lix%li",(long)width,(long)height];
     return [GKHomeNetManager method:HttpMethodPost urlString:kUrlWall(@"corp/bizhiClient/getGroupPic.php") params:params success:success failure:failure];
}
+ (NSURLSessionDataTask *)newHot:(NSString *)categoryId
                            page:(NSInteger)page
                         success:(void(^)(id object))success
                         failure:(void(^)(NSString *error))failure{
    NSString *url = [NSString stringWithFormat:@"nc/article/headline/%@/%@-%@.html",categoryId,@((page - 1)*RefreshPageSize),@(RefreshPageSize)];
    return [GKHomeNetManager method:HttpMethodGet urlString:kUrl163New(url) params:nil success:success failure:failure];
}
+ (NSURLSessionDataTask *)newsDetail:(NSString *)docid
                             success:(void(^)(id object))success
                             failure:(void(^)(NSString *error))failure{
    NSString *url = [NSString stringWithFormat:@"nc/article/%@/full.html",docid];
    return [GKHomeNetManager method:HttpMethodGet urlString:kUrl163New(url) params:nil success:success failure:failure];
}
+ (NSURLSessionDataTask *)apiPhotoSet:(NSString *)photoSetId
                              success:(void(^)(id object))success
                              failure:(void(^)(NSString *error))failure{
    NSArray *list = nil;
    if (photoSetId.length > 4) {
        list = [[photoSetId substringFromIndex:4] componentsSeparatedByString:@"|"];
    }
    NSString *url = [NSString stringWithFormat:@"photo/api/set/%@/%@.json",list.firstObject,list.lastObject];
    return [GKHomeNetManager method:HttpMethodGet urlString:kUrl163New(url) params:nil success:success failure:failure];
}
+ (NSURLSessionDataTask *)newSearchHotWord:(void(^)(id object))success
                                   failure:(void(^)(NSString *error))failure{
    NSString *url = [NSString stringWithFormat:@"nc/search/hotWord.html"];
    return [GKHomeNetManager method:HttpMethodGet urlString:kUrlSearchNew(url) params:nil success:success failure:failure];
}
+ (NSURLSessionDataTask *)newSearch:(NSString *)keyWord
                            success:(void(^)(id object))success
                            failure:(void(^)(NSString *error))failure{
    NSString *url = [NSString stringWithFormat:@"search/comp/MA==/%@/%@.html",@(RefreshPageSize),[keyWord base64EncodedString]];
    return [GKHomeNetManager method:HttpMethodGet urlString:kUrlSearchNew(url) params:nil success:success failure:failure];
}
+ (NSURLSessionDataTask *)app_login:(NSString *)account
                           password:(NSString *)password
                            success:(void(^)(id object))success
                            failure:(void(^)(NSString *error))failure
{
    NSMutableDictionary * params = [@{} mutableCopy];
    params[@"db"] = App_DB;
    params[@"function"] = @"app_login";
    params[@"login_name"] = account?:@"";
    params[@"pwd"] = password ?: @"";
    return [GKHomeNetManager method:HttpMethodPost serializer:HttpSerializeJSON urlString:URL_Login params:params success:^(id object) {
        [GKHomeNetManager loginSuccessSaveData:object];
        !success ?: success(object);
    } failure:failure];
}
+ (void)loginSuccessSaveData:(id)resultset
{
    if ([resultset isKindOfClass:[NSDictionary class]]) {
        NSArray * array = resultset[@"resultset"];
        NSDictionary * dic = [array firstObject];
        GKUserModel * model = [GKUserModel modelWithDictionary:dic];
        if ([model.login_state isEqualToString:@"0"]) {
            BOOL res = [GKUserManager saveUserModel:model];
            if (res) {
                NSLog(@"写入成功");
            }
        }
    }
}
+ (NSURLSessionDataTask *)appLaunch:(NSTimeInterval )timeStamp
                            success:(void(^)(id object))success
                            failure:(void(^)(NSString *error))failure{
    NSMutableDictionary * params = [@{} mutableCopy];
    params[@"app"] = @"7A16FBB6";
    params[@"platform"] = @"ios";
    params[@"category"] = @"startup";
    params[@"location"] = @"1";
    params[@"timestamp"] =  [NSString stringWithFormat:@"%ld",(long)timeStamp];
   return [BaseNetManager method:HttpMethodGet serializer:HttpSerializeDefault urlString:URL_Launch params:params timeOut:2 success:success failure:failure];
}
+(NSURLSessionDataTask *)videoHome:(NSInteger)page success:(void (^)(id _Nonnull))success failure:(void (^)(NSString * _Nonnull))failure{
    NSString *url = [NSString stringWithFormat:@"nc/video/home/%@-10.html",@((page - 1)*10)];
    return [GKHomeNetManager method:HttpMethodGet urlString:kUrl163New(url) params:nil success:success failure:failure];
}
//10条才会有更多数据
+(NSURLSessionDataTask *)videoList:(NSString *)sId page:(NSInteger)page success:(void (^)(id _Nonnull))success failure:(void (^)(NSString * _Nonnull))failure{
    return  [self videoList:sId page:page size:10 success:success failure:failure];
}
//10条才会有更多数据
+(NSURLSessionDataTask *)videoList:(NSString *)sId page:(NSInteger)page size:(NSInteger)size success:(void (^)(id _Nonnull))success failure:(void (^)(NSString * _Nonnull))failure{
    NSString *url = [NSString stringWithFormat:@"nc/video/list/%@/y/%@-10.html",sId,@((page - 1)*size)];
    return [GKHomeNetManager method:HttpMethodGet urlString:kUrl163New(url) params:nil success:success failure:failure];
}
+(NSURLSessionDataTask *)videoHot:(NSInteger)page success:(void (^)(id _Nonnull))success failure:(void (^)(NSString * _Nonnull))failure{
    NSString *url = @"http://baobab.kaiyanapp.com/api/v3/ranklist?&strategy=historical";
    return [GKHomeNetManager method:HttpMethodGet urlString:url params:nil success:success failure:failure];
}
@end
