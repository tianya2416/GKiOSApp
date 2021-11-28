//
//  GKPlayControlView.h
//  GKiOSApp
//
//  Created by wangws1990 on 2021/5/7.
//  Copyright © 2021 wangws1990. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKVideoModel.h"
@class  GKPlayControlView;

@protocol GKPlayControlDelegate <NSObject>

- (void)controlView:(GKPlayControlView *)controlView pause:(BOOL)pause;

@end
@interface GKPlayControlView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIImageView *imagePause;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLab;
@property (weak, nonatomic) IBOutlet UIImageView *imageIcon;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (assign, nonatomic) id <GKPlayControlDelegate>delegate;
@property (strong, nonatomic) GKVideoModel *model;
@property (assign, nonatomic) BOOL showPause;
- (void)showLoading;
- (void)hiddenLoading;

- (void)current:(NSTimeInterval )current;
- (void)duration:(NSTimeInterval )duration;
@end

