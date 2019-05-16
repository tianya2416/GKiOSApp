//
//  GKSearchModel.h
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/15.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseModel.h"
#import "GKHomeHotModel.h"
NS_ASSUME_NONNULL_BEGIN
@class GKSearchItemsModel;
@interface GKSearchModel : BaseModel
@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *searchKey;
+ (instancetype)vcWithUserId:(NSString *)userId searchKey:(NSString *)searchKey;
@end

@interface GKSearchResultModel : BaseModel
@property (assign, nonatomic) NSInteger type;
@property (strong, nonatomic) NSArray <GKSearchItemsModel *>*search;
@end

@interface GKSearchItemsModel : BaseModel
@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic) NSInteger total;
@property (assign, nonatomic) NSInteger type;
@property (strong, nonatomic) NSArray <GKHomeHotPaperModel *>*items;
@end




NS_ASSUME_NONNULL_END
