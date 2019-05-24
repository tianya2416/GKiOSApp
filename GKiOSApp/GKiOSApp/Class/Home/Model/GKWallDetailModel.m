//
//  GKDetailModel.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/22.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKWallDetailModel.h"

@implementation GKWallDetailModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"title" : @[@"title",@"gName"],
             @"url":@[@"url",@"imgUrl"]};
}
@end
