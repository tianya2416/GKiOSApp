//
//  GKNewsModel.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/16.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKNewModel.h"

@interface GKNewModel()
@property (assign, nonatomic) GKNewsStates states;
@end

@implementation GKNewModel
- (NSString *)replyCount{
    CGFloat count = _replyCount.integerValue;
    return count > 10000 ? [NSString stringWithFormat:@"%.1f万帖", count/10000.f] :  [NSString stringWithFormat:@"%.0f帖", count];
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
        return @{@"ads" : GKNewAdsModel.class};
}
- (GKNewsStates )states{
    GKNewsStates state = GKNewsDefault;
    if (self.photosetID.length > 0) {
        state = GKNewsAdvertise;
    }else if (self.imgextra.count == 2) {
        state = GKNewsImgextra;
    } else if (self.imgType) {
        state = GKNewsImgexType;
    }
    return state;
}
- (CGFloat)cellHeight{
    CGFloat height = 0.01;
    switch (self.states) {
        case GKNewsAdvertise://banner
            height = UITableViewAutomaticDimension;
            break;
        case GKNewsImgextra://三张图 标题
            height = UITableViewAutomaticDimension;
            break;
        case GKNewsImgexType://一张图 标题
            height = UITableViewAutomaticDimension;
            break;
        default:
            height = SCALEW(105);
            break;
    }
    return height;
}
@end
@implementation GKNewTopModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
     return @{@"userId": @[@"userId",@"tid"]};
}
- (BOOL)editor{
    return self.select &&([self.userId isEqualToString:@"T1348647853363"] || [self.userId isEqualToString:@"T1370583240249"]);
}
@end


@implementation GKNewAdsModel

@end

