//
//  GKNewDetailModel.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/24.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKNewDetailModel.h"

@implementation GKNewDetailModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
        return @{@"img" : GKNewImgModel.class };
}
- (NSString *)baseURL{
    NSError *error = nil;
    NSString *filepath = [self filepath];
    [[self html]  writeToFile:filepath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        return nil;
    }
    return filepath;
}
- (NSString *)html{

    NSMutableString *html = [NSMutableString string];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"new" ofType:@"css"];
//    NSString * htmlCont = [NSString stringWithContentsOfFile:path
//                                                    encoding:NSUTF8StringEncoding
//                                                       error:nil];
    [html appendString:@"<html>"];
    [html appendString:@"<head>"];
    [html appendString:@"<meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'>"];
    [html appendString:@"<link href='css/new.css' rel='stylesheet' type='text/css'>"];
   // [html appendFormat:@"<link href=\"css/%@\" rel=\"stylesheet\" type=\"text/css\">",htmlCont];
    [html appendString:@"</head>"];
    [html appendString:@"<body style=\"background:#f6f6f6\">"];
    [html appendString:[self getBodyString]];
    [html appendString:@"</body>"];
    [html appendString:@"</html>"];
    return html;
}
- (NSString *)getBodyString
{
    NSMutableString *body = [NSMutableString string];
    [body appendFormat:@"<h3>%@</h3>",self.title];
    [body appendFormat:@"<h4>%@</h4>",self.ptime];
    if  (self.body) {
        [body appendString:self.body];
    }
    for (GKNewImgModel *model in self.img) {
        NSMutableString *imgHtml = [NSMutableString string];
        // 设置img的div
        [imgHtml appendString:@"<div class=\"img-parent\">"];
        NSArray *pixel = [model.pixel componentsSeparatedByString:@"*"];
        CGFloat width = [[pixel firstObject]floatValue];
        CGFloat height = [[pixel lastObject]floatValue];
        // 判断是否超过最大宽度
        CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width  - 20;
        if (width > maxWidth) {
            height = maxWidth / width * height;
            width = maxWidth;
        }
        NSString *onload = @"this.onclick = function() {"
        "  window.location.href = 'sx://github.com/dsxNiubility?src=' +this.src+'&top=' + this.getBoundingClientRect().top + '&whscale=' + this.clientWidth/this.clientHeight ;"
        "};";
        [imgHtml appendFormat:@"<img onload=\"%@\" width=\"%f\" height=\"%f\" src=\"%@\">",onload,width,height,model.src];
        [imgHtml appendString:@"</div>"];
        [body replaceOccurrencesOfString:model.ref withString:imgHtml options:NSCaseInsensitiveSearch range:[body rangeOfString:body]];
    }
    return body;
}
- (NSString *)filepath
{
    NSString * stringPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/House"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:stringPath]) {
        BOOL res = [[NSFileManager defaultManager]createDirectoryAtPath:stringPath withIntermediateDirectories:YES attributes:nil error:nil];
        if (res) {
            NSLog(@"create successful");
        }
    }
    NSString * dbPatch = [stringPath stringByAppendingPathComponent:@"HTML.html"];
    return dbPatch;
}
@end

@implementation GKNewImgModel

@end
