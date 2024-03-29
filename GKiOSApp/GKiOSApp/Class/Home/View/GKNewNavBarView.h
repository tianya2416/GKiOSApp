//
//  GKNewNavBarView.h
//  GKiOSApp
//
//  Created by wangws1990 on 2017/5/28.
//  Copyright © 2017 wangws1990. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GKNewNavBarView : UIView
@property (weak, nonatomic) IBOutlet UIView *searchView;

@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@end

NS_ASSUME_NONNULL_END
