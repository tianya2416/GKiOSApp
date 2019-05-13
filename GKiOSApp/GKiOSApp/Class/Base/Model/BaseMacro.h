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
#define CornerRadius             5.0f


#ifdef DEBUG
#ifndef NSLog
#   define NSLog(...)
#endif
#endif
NS_ASSUME_NONNULL_BEGIN
@interface BaseMacro : NSObject

@end
NS_ASSUME_NONNULL_END
