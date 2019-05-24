//
//  HelpVC.m
//  YiCong
//
//  Created by wangws1990 on 2018/7/19. 
//  Copyright © 2018年 wangws1990. All rights reserved.
//

#import "GKWebController.h"

@interface GKWebController ()


@end

@implementation GKWebController
+ (instancetype)vcWithLoadUrl:(NSString *)loadUrl
{
    GKWebController *vc = [[[self class] alloc] init];
    [vc loadURLString:loadUrl];
    vc.hidesBottomBarWhenPushed = YES;
    return vc;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLargeTitleDisplayModeNever];
}
- (void)loadData
{

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
