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
@class GKSearchItemsModel,GKSearchBaseModel;
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
@property (strong, nonatomic) NSArray <GKSearchBaseModel *>*items;

@end

@interface GKSearchBaseModel : GKHomeHotPaperModel

@end
//专题
@interface GKSearchPojectModel : GKSearchBaseModel

@end
//铃声
@interface GKSearchBellModel : GKSearchBaseModel


@end
//动态
@interface GKSearchDynamicModel : GKSearchBaseModel

@property (copy, nonatomic) NSString *comment;
@property (copy, nonatomic) NSString *imgid;
@property (copy, nonatomic) NSString *zip;


@end
//锁屏
@interface GKSearchLockModel : GKSearchBaseModel

@end

NS_ASSUME_NONNULL_END
