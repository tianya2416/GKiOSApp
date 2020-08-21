//
//  GKDetailModel.h
//  GKiOSApp
//
//  Created by wangws1990 on 2017/5/22.
//  Copyright © 2017 wangws1990. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GKWallDetailModel : BaseModel<ATBrowserProtocol>

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *url;
@property (strong, nonatomic) UIImage *image;
@property (copy, nonatomic) NSString *desc;

@property (copy, nonatomic) NSString *gId;
@property (copy, nonatomic) NSString *pId;
@end

NS_ASSUME_NONNULL_END
