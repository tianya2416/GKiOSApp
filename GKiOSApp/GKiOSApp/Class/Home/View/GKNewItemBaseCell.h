//
//  GKNewItemBaseCell.h
//  GKiOSApp
//
//  Created by wangws1990 on 2017/5/23.
//  Copyright © 2017 wangws1990. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKNewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GKNewItemBaseCell : UITableViewCell
@property (strong, nonatomic) UIView *lineView;

@property (strong, nonatomic) GKNewModel *model;
@end

NS_ASSUME_NONNULL_END
