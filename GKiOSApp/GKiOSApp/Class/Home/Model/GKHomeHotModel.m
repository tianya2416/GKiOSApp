//
//  GKHomeHotModel.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/13.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKHomeHotModel.h"

@implementation GKHomeHotModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"banner" : GKHomeHotBannerModel.class,
             @"wallpaper" : GKHomeHotPaperModel.class };
}
@end
@implementation GKHomeHotBannerModel

@end
@implementation GKHomeHotPaperModel

@end
