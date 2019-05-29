//
//  GKNewSearch.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/29.
//  Copyright © 2019 wangws1990. All rights reserved.
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
    //att addAttribute:<#(nonnull NSAttributedStringKey)#> value:<#(nonnull id)#> range:<#(NSRange)#>
    
    return att;
}
@end
