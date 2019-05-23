//
//  GKNewItemBaseCell.h
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/23.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKNewsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GKNewItemBaseCell : UITableViewCell
@property (strong, nonatomic) UIView *lineView;

@property (strong, nonatomic) GKNewsModel *model;
@end

NS_ASSUME_NONNULL_END
