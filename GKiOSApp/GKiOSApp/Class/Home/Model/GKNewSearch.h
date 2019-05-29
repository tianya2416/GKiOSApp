//
//  GKNewSearch.h
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/29.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GKNewSearch : BaseModel

@end

@interface GKNewHotWord : BaseModel
@property (nonatomic, copy) NSString *hotWord;
@property (nonatomic, copy) NSString *searchWord;
@property (nonatomic, copy) NSString *exp;
@property (nonatomic, copy) NSString *trend;
@property (nonatomic, copy) NSString *tag;
@end

@interface GKNewSearchResult : BaseModel
@property(nonatomic,copy)NSString *dkeys;
@property(nonatomic,copy)NSString *docid;
@property(nonatomic,copy)NSString *imgurl;
@property(nonatomic,copy)NSString *postid;
@property(nonatomic,copy)NSString *program;
@property(nonatomic,copy)NSString *ptime;

@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *score;
@property(nonatomic,copy)NSString *skipID;
@property(nonatomic,copy)NSString *skipType;
@property(nonatomic,copy)NSString *replyCount;

- (NSAttributedString *)getTitleAtt;
@end
NS_ASSUME_NONNULL_END
