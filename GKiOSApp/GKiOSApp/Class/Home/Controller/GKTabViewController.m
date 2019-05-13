//
//  GKTabViewController.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/10.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKTabViewController.h"
#import "GKBaseHomeController.h"
#import "GKSetViewController.h"
#import "GKNewViewController.h"
@interface GKTabViewController ()

@end

@implementation GKTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
    // Do any additional setup after loading the view.
}
- (void)loadUI{
    GKBaseHomeController *vcHome = [[GKBaseHomeController alloc]init];
    GKNewViewController * vcMy = [[GKNewViewController alloc]init];
    GKSetViewController * vcInfo = [[GKSetViewController alloc]init];
    NSArray *titles = @[@"首页",@"新闻",@"设置"];
    NSArray *listNormal = @[@"item-01-normal",@"item-02-normal",@"item-04-normal"];
    NSArray *listHi = @[@"item-01-select",@"item-02-select",@"item-04-select"];
    NSArray *listVc =@[vcHome,vcMy,vcInfo];
    
    
    NSMutableArray *listNV = [[NSMutableArray alloc] init];
    [listVc enumerateObjectsUsingBlock:^(UIViewController*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BaseNavigationController* nv = [[BaseNavigationController alloc]initWithRootViewController:obj];
        obj.title = titles[idx];
        nv.tabBarItem.image = [[UIImage imageNamed:listNormal[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        nv.tabBarItem.selectedImage = [[UIImage imageNamed:listHi[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [nv.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:AppColor} forState:UIControlStateSelected];
        [listNV addObject:nv];
    }];
    self.viewControllers = listNV;
    self.tabBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
