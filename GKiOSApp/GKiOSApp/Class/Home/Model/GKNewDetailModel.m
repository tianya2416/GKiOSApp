//
//  GKNewDetailModel.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/24.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKNewDetailModel.h"

@implementation GKNewDetailModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
        return @{@"img" : GKNewImgModel.class };
}
@end

@implementation GKNewImgModel

@end
