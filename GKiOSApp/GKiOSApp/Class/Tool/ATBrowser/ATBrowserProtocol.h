//
//  BrowserProtocol.h
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/23.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ATBrowserProtocol <NSObject>

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *desc;
@property (copy, nonatomic) NSString *url;
@property (strong, nonatomic) UIImage *image;

@end

NS_ASSUME_NONNULL_END
