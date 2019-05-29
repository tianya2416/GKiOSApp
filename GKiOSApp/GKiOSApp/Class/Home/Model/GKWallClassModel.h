//
//  GKHomeCategoryModel.h
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/13.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseModel.h"
#import "GKWallCommenModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GKWallClassModel : BaseModel
@property (copy, nonatomic) NSString *cateId;
@property (copy, nonatomic) NSString *cateName;
@property (copy, nonatomic) NSString *cateEnglish;
@property (copy, nonatomic) NSString *cateShortName;
@property (copy, nonatomic) NSString *coverImgUrl;
@property (copy, nonatomic) NSString *fatherId;
@property (copy, nonatomic) NSString *keyword;
@property (copy, nonatomic) NSString *level;
@end

@interface GKWallClassItemModel : GKWallCommenModel

@property (copy, nonatomic) NSString *downNum;

@end


NS_ASSUME_NONNULL_END
