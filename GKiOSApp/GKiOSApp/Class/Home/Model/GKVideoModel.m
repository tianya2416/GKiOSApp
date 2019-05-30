//
//  GKVideoModel.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/20.
//  Copyright © 2019 wangws1990. All rights reserved.
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
