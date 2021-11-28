//
//  GKHomeHotModel.h
//  GKiOSApp
//
//  Created by wangws1990 on 2017/5/13.
//  Copyright © 2017 wangws1990. All rights reserved.
//

#import "BaseNetModel.h"

NS_ASSUME_NONNULL_BEGIN
@class GKWallCommenModel;
@interface GKWallCommenInfo : BaseModel

@property (strong, nonatomic) NSArray<GKWallCommenModel *>*groupList;
@property (strong, nonatomic) NSArray *banner;

@end

@interface GKWallCommenModel : BaseModel

@property (nonatomic, copy) NSString * coverImgUrl;
@property (nonatomic, copy) NSString * gName;
@property (nonatomic, copy) NSString * cover;
@property (nonatomic, copy) NSString * editDate;
@property (nonatomic, copy) NSString * gId;
@property (nonatomic, assign) NSUInteger picNum;
@property (nonatomic, copy) NSString * subId;
@property (nonatomic, copy) NSString * voteGood;

@end

NS_ASSUME_NONNULL_END
