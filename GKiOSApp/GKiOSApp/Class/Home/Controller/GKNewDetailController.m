//
//  GKNewsDetailController.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/24.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKNewDetailController.h"
#import "GKNewDetailModel.h"
@interface GKNewDetailController ()
@property (strong, nonatomic)GKNewsModel *model;
@property (strong, nonatomic)GKNewDetailModel *detailModel;
@end

@implementation GKNewDetailController
+ (instancetype)vcWithModel:(GKNewsModel *)model{
    GKNewDetailController *vc = [[[self class] alloc] init];
    vc.model = model;
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
    [self loadData];
    // Do any additional setup after loading the view.
}
- (void)loadUI{
    [self showNavTitle:self.model.title];
}
- (void)loadData{
    [GKHomeNetManager newsDetail:self.model.docid success:^(id  _Nonnull object) {
        self.detailModel = [GKNewDetailModel modelWithJSON:object[self.model.docid]];
        NSString* htmlstr = [[NSString alloc]initWithContentsOfURL:[NSURL fileURLWithPath:self.detailModel.baseURL] encoding:NSUTF8StringEncoding error:nil];
        [self loadHTMLString:htmlstr];
    } failure:^(NSString * _Nonnull error) {
        
    }];
}

@end
