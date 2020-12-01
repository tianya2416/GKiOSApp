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
@property (strong, nonatomic) NSMutableArray *listData;
@end

@implementation GKTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
    [self loadNotification];
    // Do any additional setup after loading the view.
}
- (void)loadUI{
    self.listData = @[].mutableCopy;
    
    GKNewContentController * vcHome = [[GKNewContentController alloc]init];
    [self createController:vcHome title:@"新闻" normal:@"item-02-normal" select:@"item-02-select"];
    GKVideoBaseController *video = [[GKVideoBaseController alloc] init];
    [self createController:video title:@"视频" normal:@"item-03-normal" select:@"item-03-select"];
    
    GKBaseHomeController *vcPic = [[GKBaseHomeController alloc]init];
    [self createController:vcPic title:@"图片" normal:@"item-01-normal" select:@"item-01-select"];
    GKSetViewController * vcInfo = [[GKSetViewController alloc]init];
    [self createController:vcInfo title:@"设置" normal:@"item-04-normal" select:@"item-04-select"];

    self.viewControllers = self.listData;
    self.tabBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
    self.tabBar.tintColor = AppColor;
    if (@available(iOS 10.0, *)) {
        self.tabBar.unselectedItemTintColor = Appx999999;
    } else {

    }
}
- (void)createController:(UIViewController *)vc title:(NSString *)title normal:(NSString *)normal select:(NSString *)select{
    BaseNavigationController* nv = [[BaseNavigationController alloc]initWithRootViewController:vc];
    [vc showNavTitle:title backItem:NO];
    nv.tabBarItem.title = title;
    nv.tabBarItem.image = [[UIImage imageNamed:normal] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nv.tabBarItem.selectedImage = [[UIImage imageNamed:select] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [nv.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:Appx999999} forState:UIControlStateNormal];
    [nv.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:AppColor} forState:UIControlStateSelected];
    [self.listData addObject:nv];
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
