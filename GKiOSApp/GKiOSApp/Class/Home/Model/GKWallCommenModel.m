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
    NSInteger index = arc4random() % (self.groupList.count - 3);
    NSArray *listData = self.groupList.count >= 3 ? [self.groupList subarrayWithRange:NSMakeRange(index, 3)] : self.groupList.copy;
    NSMutableArray *datas = [[NSMutableArray alloc] init];
    [listData enumerateObjectsUsingBlock:^(GKWallCommenModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [datas addObject:obj.coverImgUrl?:@""];
    }];
    return datas.copy;
}
@end
@implementation GKWallCommenModel

@end
