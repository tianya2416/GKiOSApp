//
//  GKVideoModel.m
//  GKiOSApp
//
//  Created by wangws1990 on 2017/5/20.
//  Copyright © 2017 wangws1990. All rights reserved.
//

#import "GKVideoModel.h"

@implementation GKVideoTopModel
+ (instancetype)vcWithTitle:(NSString *)title sId:(NSString *)sId imgsrc:(NSString *)imgsrc{
    GKVideoTopModel *model = [[[self class] alloc] init];
    model.title = title;
    model.sid = sId ;
    model.imgsrc = imgsrc;
    return model;
}
@end

@implementation GKVideoModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"subTitle" : @[@"description",@"subTitle"]};
}
@end


@implementation GKVideoHotModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"title" :@"data.title",
             @"descriptionEditor" :@"data.descriptionEditor",
             @"playUrl" :@"data.playUrl",
             @"category" :@"data.category",
             @"detail" :@"data.cover.detail",
             };
}

@end
