//
//  BaseMacro.h
//  YiCong
//
//  Created by wangws1990 on 2019/4/16.
//  Copyright © 2019 王炜圣. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AppColor                 [UIColor colorWithRGB:0xFF82AB]
#define Appxdddddd               [UIColor colorWithRGB:0xDDDDDD]
#define Appx000000               [UIColor colorWithRGB:0x000000]
#define Appx333333               [UIColor colorWithRGB:0x333333]
#define Appx666666               [UIColor colorWithRGB:0x666666]
#define Appx999999               [UIColor colorWithRGB:0x999999]
#define Appxf8f8f8               [UIColor colorWithRGB:0xf8f8f8]
#define AppRadius             4.0f

#define placeholders     [UIImage imageNamed:@"placeholder_big"]
#define placeholdersmall [UIImage imageNamed:@"placeholder_small"]

#pragma mark login
#define App_DB         @"ecom"
#define URL_Login      @"http://27.154.58.198:28099/restful/rpc"//登录
#define URL_Wall       @"http://sj.zol.com.cn/"//壁纸
#define URL_163New     @"http://c.m.163.com/"//新闻
#define URL_Launch     @"http://g1.163.com/madr"//开机启动
#define URL_SearchNew  @"http://c.3g.163.com/"//搜索
#define URL_Video      @"http://baobab.wandoujia.com/api/"//视频

#define kUrlWall(url)       [NSString stringWithFormat:@"%@%@", URL_Wall, url]
#define kUrl163New(url)     [NSString stringWithFormat:@"%@%@", URL_163New, url]
#define kUrlSearchNew(url)  [NSString stringWithFormat:@"%@%@", URL_SearchNew, url]
#define kUrlVideo(url)      [NSString stringWithFormat:@"%@%@", URL_Video, url]

#define RefreshPageStart (1)
#define RefreshPageSize (20)

#ifdef DEBUG
#ifndef NSLog
//#   define NSLog(...)
#endif
#endif
NS_ASSUME_NONNULL_BEGIN
@interface BaseMacro : NSObject

@end
NS_ASSUME_NONNULL_END
