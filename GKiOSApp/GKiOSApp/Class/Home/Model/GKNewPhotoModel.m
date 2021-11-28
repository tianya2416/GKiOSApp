//
//  GKNewPhotoModel.m
//  GKiOSApp
//
//  Created by wangws1990 on 2017/5/23.
//  Copyright © 2017 wangws1990. All rights reserved.
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

