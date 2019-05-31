//
//  GKLoginViewController.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/17.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKloginViewController.h"
#import <PLPlayerKit/PLPlayerKit.h>
@interface GKLoginViewController ()<PLPlayerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *accountText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (nonatomic, strong) PLPlayer *player;
@end

@implementation GKLoginViewController
- (void)dealloc{
    [self.player stop];
    self.player = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
}
- (void)loadUI{
    self.fd_prefersNavigationBarHidden = YES;
    [self.accountText setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.passwordText setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.accountText.delegate = self;
    self.passwordText.delegate = self;
    self.accountText.tintColor = self.passwordText.tintColor = AppColor;
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.cornerRadius = 5;
    [self.loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.player.playerView];
    [self.player.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.player.playerView.superview);
    }];
    [self.player play];
    [self.view sendSubviewToBack:self.player.playerView];
    UIView *mainView = [[UIView alloc] init];
    [self.player.playerView addSubview:mainView];
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(mainView.superview);
    }];
    mainView.backgroundColor = [UIColor colorWithRGB:0x000000 alpha:0.2];
    
    self.accountText.text = @"w";
    self.passwordText.text = @"1";
}
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField canResignFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}
#pragma mark action
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
#pragma mark get
- (PLPlayer *)player{
    if (!_player) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"video" ofType:@"mp4"];
        _player = [PLPlayer playerWithURL:[NSURL fileURLWithPath:path] option:[PLPlayerOption defaultOption]];
        _player.loopPlay = YES;
        _player.backgroundPlayEnable = YES;
        _player.mute = YES;
    }
    return _player;
}
@end
