//
//  ATIDMPhotoBrowser.m
//  GKiOSApp
//
//  Created by wangws1990 on 2017/5/16.
//  Copyright © 2017 wangws1990. All rights reserved.
//

#import "ATIDMPhotoBrowser.h"
@interface ATIDMPhotoBrowser()<IDMPhotoBrowserDelegate>
@property (nonatomic, copy) void(^dismiss)(IDMPhotoBrowser *browser, NSUInteger index);
@end

@implementation ATIDMPhotoBrowser
+ (instancetype)photoBrowsers:(NSArray *)arrayUrl selectIndex:(NSInteger)selectIndex
{
    
    NSMutableArray<IDMPhoto *> *imageArray = [[NSMutableArray alloc]init];
    for (int i = 0; i< [arrayUrl count]; i++) {
        NSURL * imageURL = [NSURL URLWithString:arrayUrl[i]];
        IDMPhoto * poho = [IDMPhoto photoWithURL:imageURL];
        [imageArray addObject:poho];
    }
    return [self photoBrowsers:imageArray currentIndex:selectIndex dismiss:^(IDMPhotoBrowser * _Nonnull brower, NSUInteger index) {
        
    }];
}
+ (instancetype)photoBrowsers:(NSArray<IDMPhoto *> *)photos currentIndex:(NSInteger)currentIndex dismiss:(void (^)(IDMPhotoBrowser *, NSUInteger))dismiss {
    ATIDMPhotoBrowser * vc = [[ATIDMPhotoBrowser alloc]init];
    vc.dismiss = dismiss;
    IDMPhotoBrowser * browser = [[IDMPhotoBrowser alloc]initWithPhotos:photos];
    [browser setInitialPageIndex:[photos count] > currentIndex ? currentIndex : photos.count];
    browser.displayActionButton = true;
    browser.displayArrowButton = NO;
    browser.delegate = vc;
    browser.displayToolbar = true;
    browser.displayCounterLabel = true;
    browser.dismissOnTouch = true;
    
    browser.autoHideInterface = false;
    
    browser.forceHideStatusBar = false;
    browser.displayDoneButton = false;
    browser.actionButtonTitles = @[@"保存图片"];
    browser.backgroundScaleFactor = 5.0f;
    UIViewController *currentRootVC = [UIViewController rootTopPresentedController];
    [currentRootVC presentViewController:browser animated:true completion:nil];
    return vc;
}
#pragma mark - IDMPhotoBrowser Delegate
- (void)photoBrowser:(IDMPhotoBrowser *)photoBrowser didDismissAtPageIndex:(NSUInteger)index {
    !self.dismiss ?: self.dismiss(photoBrowser, index);
    self.dismiss = nil;
}
- (void)willAppearPhotoBrowser:(IDMPhotoBrowser *)photoBrowser {
    @try {
        UIToolbar *toolBar = [photoBrowser valueForKeyPath:@"toolbar"];
        toolBar.items.lastObject.tintColor = [UIColor whiteColor];
    } @catch (NSException *exception) {
        
    }
}
- (void)photoBrowser:(IDMPhotoBrowser *)photoBrowser didDismissActionSheetWithButtonIndex:(NSUInteger)buttonIndex photoIndex:(NSUInteger)photoIndex
{
    if (buttonIndex == 0) {
        IDMPhoto * poto = [photoBrowser photoAtIndex:photoIndex];
        UIImage * image = poto.underlyingImage;
        [self saveImageToPhotos:image];
    }
}
- (void)saveImageToPhotos:(UIImage*)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(saveImageToPhotos:didFinishSavingWithError:contextInfo:), NULL);
}
- (void)saveImageToPhotos:(UIImage *)image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    [MBProgressHUD showMessage:error ? @"保存图片失败" :  @"保存图片成功"];
}
@end
