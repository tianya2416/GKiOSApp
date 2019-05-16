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
@property (copy, nonatomic) NSString *desc;
@property (copy, nonatomic) NSString *link;
@property (copy, nonatomic) NSString *litpic;
@property (copy, nonatomic) NSString *litpic_2;
@property (copy, nonatomic) NSString *news_id;
@property (copy, nonatomic) NSString *pubDate;
@property (copy, nonatomic) NSString *tags;
@property (copy, nonatomic) NSString *views;
@property (copy, nonatomic) NSString *writer;


@end

NS_ASSUME_NONNULL_END
