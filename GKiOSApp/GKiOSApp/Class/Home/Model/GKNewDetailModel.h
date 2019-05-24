//
//  GKNewDetailModel.h
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/24.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@class GKNewImgModel;
@interface GKNewDetailModel : BaseModel
/** 新闻标题 */
@property (nonatomic, copy) NSString *title;
/** 新闻发布时间 */
@property (nonatomic, copy) NSString *ptime;
/** 新闻内容 */
@property (nonatomic, copy) NSString *body;

@property (nonatomic, strong) NSArray <GKNewImgModel *>*img;
@end

@interface GKNewImgModel : BaseModel

@property (nonatomic, copy) NSString *pixel;
@property (nonatomic, copy) NSString *ref;
@property (nonatomic, copy) NSString *src;

@end

NS_ASSUME_NONNULL_END
