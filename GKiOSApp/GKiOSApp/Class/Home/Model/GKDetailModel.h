//
//  GKDetailModel.h
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/22.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GKDetailModel : BaseModel
@property (copy, nonatomic) NSString *gId;
@property (copy, nonatomic) NSString *gName;
@property (copy, nonatomic) NSString *imgUrl;
@property (copy, nonatomic) NSString *pId;
@end

NS_ASSUME_NONNULL_END
