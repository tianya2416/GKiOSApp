//
//  BaseNetModel.m
//  MDisney
//
//  Created by wangws1990 on 2018/7/19. 
//  Copyright © 2018年 wangws1990. All rights reserved.
//

#import "BaseNetModel.h"

@implementation BaseNetModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"msg" : @[@"msg", @"err"],@"resultset":@[@"resultset",@"res"]};
}
//数据是否正常
-(BOOL)isDataSuccess
{
    return self.code == 0;
    
}
- (BOOL)isNetError
{
    return self.code != 0;
}
+ (BaseNetModel *)successModel:(id)response urlString:(NSString *)urlString params:(NSDictionary *)params headParams:(NSDictionary *)headParams
{
    BaseNetModel * model = [[BaseNetModel alloc] init];
    [model modelSetWithJSON:response];
    model.allResultData = response;
    model.requestUrl = urlString;
    model.params = params;
    model.headParams = headParams;
    if(![model isDataSuccess])
    {
        NSLog(@"%@\n%@\n%@\n%@\n",urlString,params,headParams,model.allResultData);
    }
    return model;
}
+ (NSDictionary *)analysisData:(id)response{
    NSError * error = nil;
    NSDictionary * obj  = nil;
    if ([response isKindOfClass:[NSString class]])
    {
        obj = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];

    }else if ([response isKindOfClass:[NSData class]])
    {
        obj = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:&error];

    }
    else if ([response isKindOfClass:[NSDictionary class]])
    {
        obj = response;
    }
    return obj;
}
+ (BaseNetModel *)netErrorModel:(NSString *)error
{
    BaseNetModel * model = [[BaseNetModel alloc] init];
    model.msg = error;
    model.code = 404;
    model.resultset = nil;
    model.allResultData = nil;
    return model;
}
+ (NSString *)analysisError:(NSError *)error{
    NSString *info = @"";
    switch (error.code) {
        case NSURLErrorNotConnectedToInternet:
            info = @"无网络连接,请检查网络设置";
            break;
        case NSURLErrorTimedOut:
            info = @"服务器请求超时,请重试!";
            break;
        default:
            info = error.userInfo[@"NSLocalizedDescription"];
            break;
    }
    return info;
}
@end
