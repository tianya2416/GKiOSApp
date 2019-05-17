//
//  GKHomeCategoryModel.h
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/13.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseModel.h"
#import "GKHomeHotModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GKHomeCategoryModel : GKHomeHotPaperModel
@property (copy, nonatomic) NSString *categoryId;
@end

@interface GKHomeNewsModel : GKHomeHotPaperModel

@end

NS_ASSUME_NONNULL_END
