//
//  GKLaunchViewController.m
//  GKiOSApp
//
//  Created by wangws1990 on 2017/5/24.
//  Copyright © 2017 wangws1990. All rights reserved.
//

#import "GKLaunchViewController.h"
#import "GKWebController.h"
#import "GKLaunchModel.h"
#define tyCurrentWindow [[UIApplication sharedApplication].windows firstObject]
@interface GKLaunchViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UIButton *skipBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomCon;
@property (copy, nonatomic) NSString *launchImageName;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSArray *listData;
@property (strong, nonatomic) GKLaunchModel *model;
@end

@implementation GKLaunchViewController
- (void)dealloc{
    [self stopTimer];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
    [self loadData];
    [self.skipBtn addTarget:self action:@selector(skipAction) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    self.imageV.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view from its nib.
}
- (void)loadUI{
    self.bottomCon.constant = TAB_BAR_ADDING + 30;
    self.skipBtn.hidden = YES;
    [self.skipBtn setTitleColor:[UIColor colorWithRGB:0xffffff] forState:UIControlStateNormal];
    [self.skipBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:0x000000 alpha:0.35]] forState:UIControlStateNormal];
    self.skipBtn.layer.masksToBounds = YES;
    self.skipBtn.layer.cornerRadius = 16;
    self.skipBtn.titleLabel.font = [UIFont monospacedDigitSystemFontOfSize:16.0f weight:UIFontWeightRegular];
}
- (void)loadData{
    UIImage *placeholder = self.launchImageName ?[UIImage imageNamed:self.launchImageName]:[self LaunchScreenImage];
    self.imageV.image = placeholder;
    NSTimeInterval now = [[[NSDate alloc] init] timeIntervalSince1970];
    [GKHomeNetManager appLaunch:now success:^(id  _Nonnull object) {
        if (!object) {
            [self skipAction];
            return ;
        }
        self.listData = [NSArray modelArrayWithClass:GKLaunchModel.class json:object[@"ads"]];
        NSInteger index = arc4random() % [self.listData count];
        self.model = self.listData[index] ;
        if (self.model.res_url.firstObject) {
            [self performSelector:@selector(skipBtn) withObject:nil afterDelay:2];
            [self.imageV setImageWithURL:[NSURL URLWithString:self.model.res_url.firstObject] placeholder:placeholder options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(skipBtn) object:nil];
                    if (!error) {
                        [self startTimer];
                    }else{
                        [self skipAction];
                    }
                });
            }];
        }else{
             [self skipAction];
        }
    } failure:^(NSString * _Nonnull error) {
        [self skipAction];
    }];
}
- (void)skipAction{
    [self stopTimer];
    [self dismissController];
}
- (void)tapAction{
    NSString *link_url = self.model.action_params.link_url;
    if (link_url) {
        UIViewController *rootVc = [UIViewController rootTopPresentedController];
        GKWebController *vc = [GKWebController vcWithLoadUrl:link_url];
        [vc showNavTitle:@""];
        [rootVc.navigationController pushViewController:vc animated:YES];
    }
}
- (void)startTimer{
    self.skipBtn.hidden = NO;
    __block NSInteger time = [self.model.show_time integerValue];
    [self.skipBtn setTitle:[NSString stringWithFormat:@"跳过%@S",@(time)] forState:UIControlStateNormal];
    @weakify(self)
    self.timer = [NSTimer timerWithTimeInterval:1.0f block:^(NSTimer * _Nonnull timer) {
        @strongify(self)
        time = time - 1;
        [self.skipBtn setTitle:[NSString stringWithFormat:@"跳过%@S",@(time)] forState:UIControlStateNormal];
        if (time <=0) {
            [self skipAction];
        }
    } repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}
- (void)stopTimer{
    if ([self.timer isValid]) {
        [self.timer invalidate];
    }
    self.timer = nil;
}
- (void)dismissController
{
    [UIView animateWithDuration:0.6 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.1, 1.1);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}
- (NSString *)launchImageName{
    NSString *viewOrientation = @"Portrait";
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        viewOrientation = @"Landscape";
    }
    NSString *launchImageName = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    CGSize viewSize = tyCurrentWindow.bounds.size;
    for (NSDictionary* dict in imagesDict)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            launchImageName = dict[@"UILaunchImageName"];
        }
    }
    return launchImageName;
}
- (UIImage *)LaunchScreenImage{
    UIViewController *vc = [UIViewController vcFromStoryBoard:@"LaunchScreen" theId:@"launch"];
    UIImageView *imageV = [vc.view viewWithTag:10000];
    return imageV.image;
}

@end
