//
//  BrowserItemController.m
//  GKiOSApp
//
//  Created by wangws1990 on 2017/5/23.
//  Copyright © 2017 wangws1990. All rights reserved.
//

#import "ATBrowserItemController.h"


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
    //[self loadData];
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
    self.image = nil;
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
- (void)saveAction{
    if (self.image) {
        [self saveImageToPhotos:self.image];
    }
}
- (void)saveImageToPhotos:(UIImage*)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(saveImageToPhotos:didFinishSavingWithError:contextInfo:), NULL);
}
- (void)saveImageToPhotos:(UIImage *)image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    [MBProgressHUD showMessage:error ? @"下载图片失败" :  @"下载图片成功"];
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
