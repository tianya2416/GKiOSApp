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
    return @{@"groupList" : GKBabyModel.class };
}
- (NSArray *)banner{
    GKBabyModel *model = self.groupList.firstObject;
    GKBabyModel *model1 = self.groupList.lastObject;
    GKBabyModel *model2 = self.groupList[1];
    return @[model.coverImgUrl,model1.coverImgUrl,model2.coverImgUrl];
}
@end
@implementation GKBabyModel

@end
