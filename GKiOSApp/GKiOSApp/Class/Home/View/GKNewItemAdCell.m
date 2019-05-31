//
//  GKNewItemAdCell.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/23.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKNewItemAdCell.h"

@implementation GKNewItemAdCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mainView.layer.masksToBounds = YES;
    self.mainView.layer.cornerRadius = AppRadius;
    self.mainView.tag = 100;
//    self.playBtn.layer.masksToBounds = YES;
//    self.playBtn.layer.cornerRadius = 31;
//    self.playBtn.layer.borderWidth =1.0f;
//    self.playBtn.layer.borderColor = Appxdddddd.CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (SDCycleScrollView *)carouselView
{
    if (!_carouselView) {
//        CGFloat height = (SCREEN_WIDTH - 30)/16*9.0f;
        _carouselView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageWithColor:[UIColor colorWithRGB:0xf8f8f8]]];
        _carouselView.backgroundColor = [UIColor colorWithRGB:0xf8f8f8];
        _carouselView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _carouselView.autoScrollTimeInterval  = 5.0f;
        _carouselView.delegate = self;
        _carouselView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _carouselView.currentPageDotColor = [UIColor whiteColor];
    }
    return _carouselView;
}
- (void)setModel:(GKNewModel *)model{
    [super setModel:model];
    if ([model isKindOfClass:GKNewModel.class]) {
        self.playBtn.hidden = YES;
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.imgsrc] placeholderImage:placeholders];
        self.titleLab.text  = model.title ?:@"";
    }else if ( [model isKindOfClass:GKVideoHotModel.class]){
        GKVideoHotModel *hotModel = (GKVideoHotModel *)model;
         self.playBtn.hidden = NO;
        self.imageV.layer.masksToBounds = YES;
        self.imageV.layer.cornerRadius = AppRadius;
        self.titleLab.text =hotModel.title ?:@"";
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:hotModel.detail] placeholderImage:placeholders];
    }
//    NSMutableArray *listData = @[].mutableCopy;
//    NSMutableArray *listTitles = @[].mutableCopy;
//    [model.ads enumerateObjectsUsingBlock:^(GKNewAdsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [listData addObject:model.imgsrc ?:@""];
//        //obj.url 这边图片无法使用
//        [listTitles addObject:obj.title ?:@""];
//    }];
//    self.carouselView.imageURLStringsGroup = listData.copy;
//    self.carouselView.titlesGroup = listTitles.copy;
}
@end
@implementation GKVideoHotCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.imageV.layer.masksToBounds = YES;
        self.imageV.layer.cornerRadius = AppRadius;
        
    }
    return self;
}
- (void)setHotModel:(GKVideoHotModel *)hotModel{
    if (_hotModel!= hotModel) {
        _hotModel = hotModel;
        self.titleLab.text = hotModel.title ?:@"";
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:hotModel.detail] placeholderImage:placeholders];
    }
}
@end
