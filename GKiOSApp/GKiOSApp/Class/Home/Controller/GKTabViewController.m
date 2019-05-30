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
#import "GKNewContentController.h"
#import "GKVideoHomeController.h"
#import "GKVideoBaseController.h"
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
    NSArray *titles = @[@"首页",@"新闻",@"视频",@"设置"];
    NSArray *listNormal = @[@"item-01-normal",@"item-02-normal",@"item-03-normal",@"item-04-normal"];
    NSArray *listHi = @[@"item-01-select",@"item-02-select",@"item-03-select",@"item-04-select"];
    NSArray *listVc =@[vcHome,vcMy,video,vcInfo];
    
    
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
    self.delegate = self;
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
@end
