//
//  GKNewsModel.h
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/16.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseModel.h"
typedef NS_ENUM(NSInteger, GKNewsStates) {
    GKNewsDefault = 0,//左图右字
    GKNewsAdvertise,
    GKNewsImgextra,
    GKNewsImgexType,
};
NS_ASSUME_NONNULL_BEGIN
@class GKNewsAdsModel;

@interface GKNewsModel : BaseModel

@property (copy, nonatomic) NSString *docid;
@property (copy, nonatomic) NSString *title;//标题
@property (copy, nonatomic) NSString *digest;//摘要
@property (copy, nonatomic) NSString *imgsrc;//图片

@property (copy, nonatomic) NSString *replyCount;//跟贴数
@property (strong, nonatomic) NSArray *imgextra;//多图imgsrc
@property (assign, nonatomic) BOOL imgType;//大图

@property (copy, nonatomic) NSArray <GKNewsAdsModel*>*ads;//图片轮播的图
@property (copy, nonatomic) NSString *photosetID;

@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *url_3w;
@property (copy, nonatomic) NSString *votecount;
@property (copy, nonatomic) NSString *mtime;

@property (assign, nonatomic, readonly) GKNewsStates states;
@property (assign, nonatomic, readonly) CGFloat cellHeight;

@end

@interface GKNewsTopModel : BaseModel

@property (copy, nonatomic) NSString *tname;
@property (copy, nonatomic) NSString *userId;
@property (assign, nonatomic) NSInteger sort;

@property (assign, nonatomic) BOOL select;
@property (assign, nonatomic) BOOL editor;//select =yes 有值 不需要编辑
@end


@interface GKNewsAdsModel : BaseModel
@property (copy, nonatomic) NSString *imgsrc;
@property (copy, nonatomic) NSString *skipID;
@property (copy, nonatomic) NSString *skipType;
@property (copy, nonatomic) NSString *subtitle;
@property (copy, nonatomic) NSString *tag;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *url;
@end

NS_ASSUME_NONNULL_END
