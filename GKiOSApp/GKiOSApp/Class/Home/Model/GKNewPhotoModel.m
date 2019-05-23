//
//  GKNewPhotoModel.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/23.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKNewPhotoModel.h"

@implementation GKNewPhotoModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
        return @{@"photos" : GKNewPhotoItem.class };
}
@end

@implementation GKNewPhotoItem
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"url" : @[@"url",@"imgurl"],
             @"desc":@[@"desc",@"note"]};
}
@end

