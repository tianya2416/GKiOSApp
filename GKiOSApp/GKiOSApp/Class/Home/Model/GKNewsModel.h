//
//  GKNewsModel.h
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/16.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GKNewsModel : BaseModel

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *digest;
@property (copy, nonatomic) NSString *imgsrc;

@property (copy, nonatomic) NSString *mtime;
@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *url_3w;
@property (copy, nonatomic) NSString *votecount;
//@property (copy, nonatomic) NSString *tags;
//@property (copy, nonatomic) NSString *views;
//@property (copy, nonatomic) NSString *writer;


@end

@interface GKNewsTopModel : BaseModel
@property (copy, nonatomic) NSString *tname;
@property (copy, nonatomic) NSString *tid;
@end


NS_ASSUME_NONNULL_END
