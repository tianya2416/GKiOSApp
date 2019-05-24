//
//  GKNewsDetailController.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/24.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKNewDetailController.h"
#import "GKNewDetailModel.h"
@interface GKNewDetailController ()
@property (strong, nonatomic)GKNewsModel *model;
@property (strong, nonatomic)GKNewDetailModel *detailModel;
@end

@implementation GKNewDetailController
+ (instancetype)vcWithModel:(GKNewsModel *)model{
    GKNewDetailController *vc = [[[self class] alloc] init];
    vc.model = model;
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
    [self loadData];
    // Do any additional setup after loading the view.
}
- (void)loadUI{
    [self showNavTitle:self.model.title];
}
- (void)loadData{
    [GKHomeNetManager newsDetail:self.model.docid success:^(id  _Nonnull object) {
        self.detailModel = [GKNewDetailModel modelWithJSON:object[self.model.docid]];
        [self loadHTMLString:[self getHtmlString]];
    } failure:^(NSString * _Nonnull error) {
        
    }];
}
- (NSString *)getHtmlString
{
    NSMutableString *html = [NSMutableString string];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"new" ofType:@"css"];
    NSString * htmlCont = [NSString stringWithContentsOfFile:path
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    [html appendString:@"<html>"];
    [html appendString:@"<head>"];
    [html appendFormat:@"<link rel=\"stylesheet\" href=\"%@\">",htmlCont];
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
    [body appendFormat:@"<div class=\"title\">%@</div>",self.detailModel.title];
    [body appendFormat:@"<div class=\"time\">%@</div>",self.detailModel.ptime];
    if (self.detailModel.body != nil) {
        [body appendString:self.detailModel.body];
    }
    for (GKNewImgModel *model in self.detailModel.img) {
        NSMutableString *imgHtml = [NSMutableString string];
        // 设置img的div
        [imgHtml appendString:@"<div class=\"img-parent\">"];
        NSArray *pixel = [model.pixel componentsSeparatedByString:@"*"];
        CGFloat width = [[pixel firstObject]floatValue];
        CGFloat height = [[pixel lastObject]floatValue];
        // 判断是否超过最大宽度
        CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width * 0.96;
        if (width > maxWidth) {
            height = maxWidth / width * height;
            width = maxWidth;
        }
        NSString *onload = @"this.onclick = function() {"
        "  window.location.href = 'sx://github.com/dsxNiubility?src=' +this.src+'&top=' + this.getBoundingClientRect().top + '&whscale=' + this.clientWidth/this.clientHeight ;"
        "};";
        [imgHtml appendFormat:@"<img onload=\"%@\" width=\"%f\" height=\"%f\" src=\"%@\">",onload,width,height,model.src];
        [imgHtml appendString:@"</div>"];
        [body replaceOccurrencesOfString:model.ref withString:imgHtml options:NSCaseInsensitiveSearch range:NSMakeRange(0, body.length)];
    }
    return body;
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
