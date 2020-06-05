//
//  ATAlertView.h
//  AT
//
//  Created by Apple on 14-8-3.
//  Copyright (c) 2014年 Summer. All rights reserved.
//

#import <MMPopupView/MMAlertView.h>

typedef void(^ATAlertViewCompletion)(NSUInteger index, NSString *buttonTitle);
typedef NSUInteger(^ATAlertInputViewTextDidChange)(NSUInteger index, UITextField *textField, NSString *text, UIButton *confirmButton);

@interface ATAlertView : MMAlertView
/**
 *  弹出提示
 *
 *  @param title            标题
 *  @param message          详情
 *  @param normalButtons    常规按钮标题数组
 *  @param highlightButtons 高亮按钮标题数组
 *  @param completion       完成时回调(index: 按钮编号, buttonTitle: 按钮标题)
 *
 *  @return 返回弹出实例
 */
+ (instancetype)showTitle:(NSString *)title
                  message:(NSString *)message
            normalButtons:(NSArray<NSString *> *)normalButtons
         highlightButtons:(NSArray<NSString *> *)highlightButtons
               completion:(ATAlertViewCompletion)completion;
@end
