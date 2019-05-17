//
//  GKSearchModel.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/15.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKSearchModel.h"

@implementation GKSearchModel
+ (instancetype)vcWithUserId:(NSString *)userId searchKey:(NSString *)searchKey{
    GKSearchModel *vc = [[[self class] alloc] init];
    vc.userId = userId;
    vc.searchKey = searchKey;
    return vc;
}
@end

@implementation GKSearchResultModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"search" : GKSearchItemsModel.class};
}
@end

@implementation GKSearchItemsModel


+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"items" : GKSearchBaseModel.class};
}
@end

@implementation GKSearchBaseModel
+ (Class)modelCustomClassForDictionary:(NSDictionary*)dictionary {
    NSInteger type = [dictionary[@"type"] integerValue];
    Class class = nil;
    switch (type) {
        case 8:
            class =  GKSearchPojectModel.class;
            break;
        case 1:
            class = GKHomeHotPaperModel.class;
            break;
        case 4:
            class = GKSearchBellModel.class;
            break;
        case 2:
            class = GKSearchDynamicModel.class;
            break;
        case 3:
            class = GKSearchLockModel.class;
            break;
        default:
            class = GKHomeHotPaperModel.class;
            break;
    }
    return class;
}
@end
@implementation GKSearchPojectModel

@end


@implementation GKSearchBellModel

@end


@implementation GKSearchDynamicModel

@end

@implementation GKSearchLockModel

@end

