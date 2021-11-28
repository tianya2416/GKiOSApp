//
//  VTContentView+GKBack.m
//  GKiOSApp
//
//  Created by wangws1990 on 2017/5/22.
//  Copyright © 2017 wangws1990. All rights reserved.
//

#import "VTContentView+GKBack.h"

@implementation VTContentView (GKBack)
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.contentOffset.x <= 0) {
        if ([otherGestureRecognizer.delegate isKindOfClass:NSClassFromString(@"_FDFullscreenPopGestureRecognizerDelegate")]) {
            return YES;
        }
    }
    return NO;
}
@end
