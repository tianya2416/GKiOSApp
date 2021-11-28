//
//  GKEmptyView.h
//  GKiOSApp
//
//  Created by wangws1990 on 2021/5/7.
//  Copyright © 2021 wangws1990. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKBallLoadingView.h"
NS_ASSUME_NONNULL_BEGIN

@interface GKEmptyView : UIView
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UIImageView *imageV;
@property (strong, nonatomic) GKBallLoadingView *loadView;
@end

NS_ASSUME_NONNULL_END
