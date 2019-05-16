//
//  GKNewItemTableViewCell.h
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/16.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKNewsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GKNewItemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLab;
@property (weak, nonatomic) IBOutlet UIButton *watchBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (strong, nonatomic) GKNewsModel *model;
@end

NS_ASSUME_NONNULL_END
