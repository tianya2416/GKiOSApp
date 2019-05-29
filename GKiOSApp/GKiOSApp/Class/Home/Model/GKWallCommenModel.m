//
//  GKHomeHotModel.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/13.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKWallCommenModel.h"

@implementation GKWallCommenInfo
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"groupList" : GKWallCommenModel.class };
}
- (NSArray *)banner{
    GKWallCommenModel *model = self.groupList.firstObject;
    GKWallCommenModel *model1 = self.groupList.lastObject;
    GKWallCommenModel *model2 = self.groupList[1];
    return @[model.coverImgUrl,model1.coverImgUrl,model2.coverImgUrl];
}
@end
@implementation GKWallCommenModel

@end
