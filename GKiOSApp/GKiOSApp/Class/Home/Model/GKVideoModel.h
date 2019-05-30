//
//  GKVideoModel.h
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/20.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@interface GKVideoTopModel : BaseModel
@property (copy, nonatomic) NSString *imgsrc;
@property (copy, nonatomic) NSString *sid;
@property (copy, nonatomic) NSString *title;
+ (instancetype)vcWithTitle:(NSString *)title sId:(NSString *)sId imgsrc:(NSString *)imgsrc;
@end

@interface GKVideoModel : BaseModel
@property (copy, nonatomic) NSString *cover;
@property (copy, nonatomic) NSString *length;
@property (copy, nonatomic) NSString *m3u8_url;
@property (copy, nonatomic) NSString *mp4_url;
@property (copy, nonatomic) NSString *playCount;

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subTitle;
@property (copy, nonatomic) NSString *votecount;
@end

NS_ASSUME_NONNULL_END
