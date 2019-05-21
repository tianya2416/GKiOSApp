//
//  GKVideoModel.h
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/20.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GKVideoModel : BaseModel
@property (copy, nonatomic) NSString *agree_num;
@property (copy, nonatomic) NSString *create_time;
@property (copy, nonatomic) NSString *head;
@property (copy, nonatomic) NSString *nick_name;
@property (copy, nonatomic) NSString *origin_video_url;
@property (copy, nonatomic) NSString *thumbnail_url;

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *video_url;
@end

NS_ASSUME_NONNULL_END
