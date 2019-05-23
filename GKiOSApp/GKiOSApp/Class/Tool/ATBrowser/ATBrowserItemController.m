//
//  BrowserItemController.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/23.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "ATBrowserItemController.h"
// 判断是否为iPhone X 系列  这样写消除了在Xcode10上的警告。
//#define IPHONE_X \
//({BOOL isPhoneX = NO;\
//if (@available(iOS 11.0, *)) {\
//isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
//}\
//(isPhoneX);})


@interface ATBrowserItemController ()

@property (strong, nonatomic) UIImageView *imageV;

@end

@implementation ATBrowserItemController
- (void)dealloc{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
    [self loadData];
}
- (void)setObject:(id)object{
    _object = object;
    if ([object isKindOfClass:UIImage.class]) {
        self.imageV.image = object;
    }else if ([object isKindOfClass:NSString.class]){
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:object] placeholderImage:placeholders];
    }
}

- (void)vtm_prepareForReuse{
    self.imageV.image = nil;
}
- (void)loadUI{
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.imageV];
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    [temp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_imageV]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageV)]];
    [temp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_imageV]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageV)]];
    [self.view addConstraints:temp];
    
}
- (void)loadData{
    
}

- (UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc] init];
        _imageV.clipsToBounds = YES;
        _imageV.contentMode = UIViewContentModeScaleAspectFit;
        _imageV.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _imageV;
}

@end
