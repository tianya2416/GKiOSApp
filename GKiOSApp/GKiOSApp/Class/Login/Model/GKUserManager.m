//
//  GKUserManager.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/17.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKUserManager.h"
#import "GKLoginViewController.h"
@interface GKUserManager()
@property (strong, nonatomic) GKUserModel * userModel;
@property (copy, nonatomic) void (^completion)(BOOL success);
@end

@implementation GKUserManager
+ (instancetype)shareInstance {
    static GKUserManager *_shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_shareInstance) {
            _shareInstance = [[GKUserManager alloc]init];
        }
    });
    return _shareInstance;
}

/**
 *  写入当前用户
 */
+ (BOOL)saveUserModel:(GKUserModel *)userModel
{
    [GKUserManager shareInstance].userModel = userModel;
    BOOL res = NO;
    NSData *userData = [GKUserManager archivedDataForData:userModel];
    if (userData)
    {
        [[NSUserDefaults standardUserDefaults] setObject:userData forKey:@"User_CurrentUser"];
        res = [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return res;
}
- (GKUserModel *)userModel
{
    if (!_userModel) {
        NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User_CurrentUser"];
        _userModel = data ? [GKUserManager unarchiveForData:data]: nil;
    }
    return _userModel;
}
+ (void)removeYCUserModel
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"User_CurrentUser"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [GKUserManager shareInstance].userModel = nil;
    
}
+ (BOOL)loginIn;
{
    BOOL login = NO;
    GKUserModel * model = [GKUserManager shareInstance].userModel;
    if (model.login_id) {
        login = YES;
    }
    return login;
}
+ (void)needLogin:(void (^)(BOOL success))completion
{
    if ([GKUserManager loginIn]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            !completion  ?: completion(YES);
        });
    }else
    {
        [GKUserManager shareInstance].completion = completion;
        [GKUserManager login];
    }
}
+ (void)login
{
    UIViewController *vc = [UIViewController rootTopPresentedController];
    UIViewController *topVC = [vc topPresentedController];
    if ([topVC isKindOfClass:GKLoginViewController.class]) {
        return;
    }
    GKLoginViewController *loginVC =[[GKLoginViewController alloc] init];
    loginVC.hidesBottomBarWhenPushed = YES;
    BaseNavigationController *nv = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
    if (@available(iOS 11.0, *)) {
        nv.navigationBar.prefersLargeTitles = NO;
        nv.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    }
    [vc hh_presentCircleVC:nv point:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2) completion:nil];
}
+ (void)loginOut
{
    [ATAlertView showTitle:@"确定要退出登录吗?" message:nil normalButtons:@[@"取消"] highlightButtons:@[@"确定"] completion:^(NSUInteger index, NSString *buttonTitle) {
        if (index > 0) {
            [GKUserManager login];
            [GKUserManager removeYCUserModel];
        }
    }];
}

+ (void)loginSuccess
{
    UIViewController *vc = [UIViewController rootTopPresentedController];
    [vc hh_dismissWithPoint:CGPointMake(SCREEN_HEIGHT/2, SCREEN_HEIGHT/2) completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ![GKUserManager shareInstance].completion ?: [GKUserManager shareInstance].completion(YES);
    });
}

#pragma mark archived and unarchive
+ (NSData *)archivedDataForData:(id)data
{
    NSData * resData = nil;
    @try {
        resData = [NSKeyedArchiver archivedDataWithRootObject:data];
    }
    @catch (NSException *exception) {
        NSLog(@"%s,%d,%@", __FUNCTION__, __LINE__, exception.description);
        resData = nil;
    }
    @finally {
        
    }
    return resData;
}
+ (id)unarchiveForData:(NSData*)data
{
    id resObj = nil;
    @try {
        resObj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    @catch (NSException *exception) {
        NSLog(@"%s,%d,%@", __FUNCTION__, __LINE__, exception.description);
        resObj = nil;
    }
    @finally {
        
    }
    return resObj;
}
@end
