//
//  GKNewPhotoModel.h
//  GKiOSApp
//
//  Created by wangws1990 on 2017/5/23.
//  Copyright © 2017 wangws1990. All rights reserved.
//

#import "BaseModel.h"
#import "ATBrowserProtocol.h"
NS_ASSUME_NONNULL_BEGIN
@class GKNewPhotoItem;

@interface GKNewPhotoModel : BaseModel
@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *setname;
@property (copy, nonatomic) NSString *desc;
@property (strong, nonatomic) NSArray <GKNewPhotoItem *>*photos;
@end

@interface GKNewPhotoItem : BaseModel<ATBrowserProtocol>

@property (strong, nonatomic) UIImage *image;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *desc;
@property (copy, nonatomic) NSString *url;

@property (copy, nonatomic) NSString *cimgurl;
@property (copy, nonatomic) NSString *newsurl;
@property (copy, nonatomic) NSString *photohtml;
@property (copy, nonatomic) NSString *photoid;
@property (copy, nonatomic) NSString *simgurl;
@property (copy, nonatomic) NSString *squareimgurl;
@property (copy, nonatomic) NSString *timgurl;
@end
NS_ASSUME_NONNULL_END
