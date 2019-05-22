//
//  GKSearchModel.h
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/15.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseModel.h"
#import "GKHomeHotModel.h"
#import "GKHomeCategoryModel.h"
NS_ASSUME_NONNULL_BEGIN
@class GKSearchItemsModel,GKSearchBaseModel;
@interface GKSearchModel : BaseModel
@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *searchKey;
+ (instancetype)vcWithUserId:(NSString *)userId searchKey:(NSString *)searchKey;
@end

@interface GKSearchResultModel : GKHomeCategoryItemModel

@end



NS_ASSUME_NONNULL_END
