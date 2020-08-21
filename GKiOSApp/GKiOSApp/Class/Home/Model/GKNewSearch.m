//
//  GKNewSearch.m
//  GKiOSApp
//
//  Created by wangws1990 on 2017/5/29.
//  Copyright © 2017 wangws1990. All rights reserved.
//

#import "GKNewSearch.h"

@implementation GKNewSearch

@end

@implementation GKNewHotWord

@end
@implementation GKNewSearchResult
- (NSString *)title{
    NSMutableString *mstring = _title.mutableCopy;
    NSRange range = [mstring rangeOfString:mstring];
    [mstring replaceOccurrencesOfString:@"<em>" withString:@"<" options:NSCaseInsensitiveSearch range:range];
    range = [mstring rangeOfString:mstring];
    [mstring replaceOccurrencesOfString:@"</em>" withString:@">" options:NSCaseInsensitiveSearch range:range];
    return mstring;
}
- (NSAttributedString *)getTitleAtt{
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:self.title];
    return att;
}
- (NSString *)docid{
    return [self.skipType isEqualToString:@"doc"] ? _docid : self.postid;
}
@end
