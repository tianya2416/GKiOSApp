//
//  BaseConnectionController.h
//  MyCountDownDay
//
//  Created by wangws1990 on 2017/1/21.
//  Copyright © 2017 wangws1990. All rights reserved.
//

#import "BaseRefreshController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseConnectionController : BaseRefreshController<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic)UICollectionView * collectionView;
@end

NS_ASSUME_NONNULL_END
