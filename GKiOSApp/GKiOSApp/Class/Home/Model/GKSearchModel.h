//
//  GKSearchModel.h
//  GKiOSApp
//
//  Created by wangws1990 on 2017/5/15.
//  Copyright © 2017 wangws1990. All rights reserved.
//

#import "BaseModel.h"
#import "GKWallCommenModel.h"
#import "GKWallClassModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, GKSearchState) {
    GKSearchWall = 0,
    GKSearchNew  = 1
};
@interface GKSearchModel : BaseModel
@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *searchKey;
@property (assign, nonatomic) GKSearchState searchState;
+ (instancetype)vcWithUserId:(NSString *)userId searchKey:(NSString *)searchKey state:(GKSearchState)state;
@end

@interface GKSearchResultModel : GKWallCommenModel

@end



NS_ASSUME_NONNULL_END
