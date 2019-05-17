//
//  GKLoginViewController.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/17.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKLoginViewController.h"

@interface GKLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation GKLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
}
- (void)loadUI{
    [self showNavTitle:@"登录" backItem:NO];
    self.accountText.tintColor = self.passwordText.tintColor = AppColor;
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.cornerRadius = 5;
    [self.loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.accountText.text = @"w";
    self.passwordText.text = @"1";
}
- (void)loginAction{
    NSString *account = self.accountText.text;
    NSString *password = self.passwordText.text;
    [MBProgressHUD showToView:self.view completion:^(MBProgressHUD *hud) {
        [GKHomeNetManager app_login:account password:password success:^(id  _Nonnull object) {
            if ([GKUserManager loginIn]) {
                [hud hideAnimated:YES];
                [GKUserManager loginSuccess];
            }else{
                [hud hideWithMessage:@"登录失败" completion:nil];
            }
        } failure:^(NSString * _Nonnull error) {
            [hud hideWithMessage:error completion:nil];
        }];
    }];
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
