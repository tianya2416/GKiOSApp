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
@property (strong, nonatomic) UIImage *image;
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
        self.image = object;
    }else if ([object isKindOfClass:NSString.class]){
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:object] placeholderImage:placeholders completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            self.image = image;
        }];
    }
}

- (void)vtm_prepareForReuse{
    self.imageV.image = nil;
    self.imageV = nil;
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
    self.imageV.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longAction:)];
    longTap.minimumPressDuration = 0.5;
    longTap.numberOfTapsRequired = 1;
    [self.imageV addGestureRecognizer:longTap];
}
- (void)longAction:(UILongPressGestureRecognizer *)sender{
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"是否保存该图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveImageToPhotos:self.image];
    }];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [vc addAction:sure];
    [vc addAction:cancle];
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)saveImageToPhotos:(UIImage*)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(saveImageToPhotos:didFinishSavingWithError:contextInfo:), NULL);
}
- (void)saveImageToPhotos:(UIImage *)image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    [MBProgressHUD showMessage:error ? @"保存图片失败" :  @"保存图片成功"];
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
