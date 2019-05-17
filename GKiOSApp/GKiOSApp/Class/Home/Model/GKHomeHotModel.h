//
//  GKHomeHotModel.h
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/13.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseNetModel.h"

NS_ASSUME_NONNULL_BEGIN
@class GKHomeHotPaperModel,GKHomeHotBannerModel;
@interface GKHomeHotModel : BaseModel
@property (strong, nonatomic) NSArray<GKHomeHotBannerModel *>*banner;
@property (strong, nonatomic) NSArray<GKHomeHotPaperModel *>*wallpaper;
@end

@interface GKHomeHotBannerModel : BaseModel
@property (copy, nonatomic) NSString *thumb;
@end

@interface GKHomeHotPaperModel : BaseModel
@property (nonatomic, assign) NSInteger atime;
@property (nonatomic, strong) NSArray * cid;
@property (nonatomic, assign) BOOL cr;
@property (nonatomic, strong) NSString * Id;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic, assign) NSInteger favs;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * img;
@property (nonatomic, assign) NSInteger ncos;
@property (nonatomic, strong) NSString * preview;
@property (nonatomic, assign) NSInteger rank;
@property (nonatomic, strong) NSString * rule;
@property (nonatomic, strong) NSString * ruleNew;
@property (nonatomic, strong) NSString * sourceType;
@property (nonatomic, strong) NSString * store;
@property (nonatomic, strong) NSArray * tag;
@property (nonatomic, strong) NSString * thumb;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSArray * url;
@property (nonatomic, assign) NSInteger views;
@property (nonatomic, strong) NSString * wp;
@property (nonatomic, assign) BOOL xr;
@property (nonatomic, assign) BOOL isStar;

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * ename;
@property (nonatomic, copy) NSString * cover;
@property (nonatomic, copy) NSString * rname;
@property (nonatomic, copy) NSString * icover;
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, copy) NSString * coverTemp;
@property (nonatomic, copy) NSString * picassoCover;

@end
NS_ASSUME_NONNULL_END
