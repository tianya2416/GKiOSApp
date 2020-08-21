//
//  GKTabViewController.m
//  GKiOSApp
//
//  Created by wangws1990 on 2017/5/10.
//  Copyright © 2017 wangws1990. All rights reserved.
//

#import "GKTabViewController.h"
#import "GKBaseHomeController.h"
#import "GKSetViewController.h"
#import "GKNewContentController.h"
#import "GKVideoHomeController.h"
#import "GKVideoBaseController.h"

#import "GKVideoHotController.h"
@interface GKTabViewController ()<UITabBarControllerDelegate>

@end

@implementation GKTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
    [self loadNotification];
    // Do any additional setup after loading the view.
}
- (void)loadUI{
    GKBaseHomeController *vcHome = [[GKBaseHomeController alloc]init];
    GKNewContentController * vcMy = [[GKNewContentController alloc]init];
    GKVideoBaseController *video = [[GKVideoBaseController alloc] init];
    GKSetViewController * vcInfo = [[GKSetViewController alloc]init];
    NSArray *titles = @[@"新闻",@"视频",@"图片",@"设置"];
    NSArray *listNormal = @[@"item-02-normal",@"item-03-normal",@"item-01-normal",@"item-04-normal"];
    NSArray *listHi = @[@"item-02-select",@"item-03-select",@"item-01-select",@"item-04-select"];
    NSArray *listVc =@[vcMy,video,vcHome,vcInfo];
    
    
    NSMutableArray *listNV = [[NSMutableArray alloc] init];
    [listVc enumerateObjectsUsingBlock:^(UIViewController*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BaseNavigationController* nv = [[BaseNavigationController alloc]initWithRootViewController:obj];
        obj.title = titles[idx];
        nv.tabBarItem.image = [[UIImage imageNamed:listNormal[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nv.tabBarItem.selectedImage = [[UIImage imageNamed:listHi[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [nv.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:Appx999999} forState:UIControlStateNormal];
        [nv.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:AppColor} forState:UIControlStateSelected];
        [listNV addObject:nv];
    }];
    self.viewControllers = listNV;
    self.tabBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
    self.tabBar.tintColor = AppColor;
    if (@available(iOS 10.0, *)) {
        self.tabBar.unselectedItemTintColor = Appx999999;
    } else {

    }
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    NSInteger selectedIndex = [tabBarController.viewControllers indexOfObject:viewController];
    if (selectedIndex == 3) {
        [self notificationAction:nil];
    }
}
- (void)loadNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:@"NotificationSet" object:nil];
}
- (void)notificationAction:(NSNotification *)notification{
    NSDictionary *userInfo = notification.object;
    NSInteger count = [userInfo[@"count"] integerValue];
    UIViewController *vc = self.viewControllers.lastObject;
    vc.tabBarItem.badgeValue = count > 0 ? [NSString stringWithFormat:@"%@",@(count)] : nil;
}

////是否自动旋转,返回YES可以自动旋转
- (BOOL)shouldAutorotate {
    return [self.selectedViewController shouldAutorotate];
}
//返回支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.selectedViewController supportedInterfaceOrientations];
}
//这个是返回优先方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}
- (BOOL)prefersStatusBarHidden {
    return [self.selectedViewController prefersStatusBarHidden];
}
@end
