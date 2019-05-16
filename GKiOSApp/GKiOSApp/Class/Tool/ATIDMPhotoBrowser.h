//
//  ATIDMPhotoBrowser.h
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/16.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDMPhotoBrowser.h"
NS_ASSUME_NONNULL_BEGIN

@interface ATIDMPhotoBrowser : NSObject


+ (instancetype)photoBrowsers:(NSArray *)arrayUrl
                  selectIndex:(NSInteger)selectIndex;
+ (instancetype)photoBrowsers:(NSArray<IDMPhoto *> *)photos
                 currentIndex:(NSInteger)currentIndex
                      dismiss:(void (^)(IDMPhotoBrowser *, NSUInteger))dismiss;

@end

NS_ASSUME_NONNULL_END
