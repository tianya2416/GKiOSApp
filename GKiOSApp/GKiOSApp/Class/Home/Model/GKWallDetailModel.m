//
//  GKDetailModel.m
//  GKiOSApp
//
//  Created by wangws1990 on 2017/5/22.
//  Copyright © 2017 wangws1990. All rights reserved.
//

#import "GKWallDetailModel.h"

@implementation GKWallDetailModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"title" : @[@"title",@"gName"],
             @"url":@[@"url",@"imgUrl"]};
}
@end
