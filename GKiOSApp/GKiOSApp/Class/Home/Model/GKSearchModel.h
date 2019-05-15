//
//  GKSearchModel.h
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/15.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GKSearchModel : BaseModel
@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *searchKey;
+ (instancetype)vcWithUserId:(NSString *)userId searchKey:(NSString *)searchKey;
@end

NS_ASSUME_NONNULL_END
