//
//  GKNewItemAdCell.h
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/23.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKNewItemBaseCell.h"
#import "SDCycleScrollView.h"
NS_ASSUME_NONNULL_BEGIN

@interface GKNewItemAdCell : GKNewItemBaseCell<SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (strong, nonatomic) SDCycleScrollView *carouselView;
@end

NS_ASSUME_NONNULL_END
