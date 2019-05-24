//
//  ProgressWKWebView.m
//  FDLive
//
//  Created by wws1990 on 2017/2/28.
//  Copyright © 2017年 Linjw. All rights reserved.
//

#import "ProgressWKWebView.h"



static void *FDWebBrowserContext = &FDWebBrowserContext;


@interface ProgressWKWebView ()<WKNavigationDelegate, WKUIDelegate>
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation ProgressWKWebView


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self createContentView];
    }
    return self;
}


- (void)dealloc {
    [self.wkWebView setNavigationDelegate:nil];
    [self.wkWebView setUIDelegate:nil];
    [self.wkWebView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    [self.wkWebView removeObserver:self forKeyPath:NSStringFromSelector(@selector(title))];

}


#pragma mark - 控件数据初始化
-(WKWebView *)wkWebView
{
    if (_wkWebView == nil) {
        _wkWebView = [[WKWebView alloc] initWithFrame:self.frame];
        [self.wkWebView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [self.wkWebView setNavigationDelegate:self];
        [self.wkWebView setUIDelegate:self];
        [self.wkWebView setMultipleTouchEnabled:YES];
        [self.wkWebView setAutoresizesSubviews:YES];
        [self.wkWebView.scrollView setAlwaysBounceVertical:YES];
        self.wkWebView.scrollView.bounces = YES;
        [self.wkWebView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:FDWebBrowserContext];
        [self.wkWebView addObserver:self forKeyPath:NSStringFromSelector(@selector(title)) options:NSKeyValueObservingOptionNew context:NULL];

    }
    return _wkWebView;
}

-(UIProgressView *)progressView
{
    if (_progressView == nil) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.backgroundColor = [UIColor clearColor];
        [_progressView setTrackTintColor:[UIColor greenColor]];
        [_progressView setTintColor:[UIColor redColor]];
    }
    return _progressView;
}

#pragma mark - 界面生成
-(void)createContentView
{
    @weakify(self)
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.wkWebView];
    [self.wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.edges.equalTo(self);
    }];
    
    [self addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.left.right.equalTo(self);
        make.height.equalTo(@(2.0f));
        make.top.equalTo(self).offset(0);
    }];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    if([self.delegate respondsToSelector:@selector(fdwebViewDidStartLoad:)])
    {
        [self.delegate fdwebViewDidStartLoad:self];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if([self.delegate respondsToSelector:@selector(fdwebView:didFinishLoadingURL:)])
    {
        [self.delegate fdwebView:self didFinishLoadingURL:self.wkWebView.URL];
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
      withError:(NSError *)error {
    if([self.delegate respondsToSelector:@selector(fdwebView:didFailToLoadURL:error:)])
    {
        [self.delegate fdwebView:self didFailToLoadURL:self.wkWebView.URL error:error];
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation
      withError:(NSError *)error {
    if([self.delegate respondsToSelector:@selector(fdwebView:didFailToLoadURL:error:)])
    {
        [self.delegate fdwebView:self didFailToLoadURL:self.wkWebView.URL error:error];
    }
}

- (void)webView:(WKWebView *)webView
decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    if([self.delegate respondsToSelector:@selector(fdwebView:shouldStartLoadWithURL:decisionHandler:)])
    {
        [self.delegate fdwebView:self shouldStartLoadWithURL:navigationAction.request.URL decisionHandler:^(BOOL cancelTurn) {
            decisionHandler(cancelTurn?WKNavigationActionPolicyCancel:WKNavigationActionPolicyAllow);
        }];
    }
    else
    {
        NSURL *URL = navigationAction.request.URL;
        if(!navigationAction.targetFrame)
        {
            [self loadURL:URL];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

#pragma mark - WKUIDelegate
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}


#pragma mark - Estimated Progress KVO (WKWebView)

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.wkWebView)
    {
        [self.progressView setAlpha:1.0f];
        BOOL animated = self.wkWebView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.wkWebView.estimatedProgress animated:animated];
        @weakify(self)
        // Once complete, fade out UIProgressView
        if(self.wkWebView.estimatedProgress >= 1.0f)
        {
            [UIView animateWithDuration:0.3f
                                  delay:0.3f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                @strongify(self)
                [self.progressView setAlpha:0.0f];
            }
                             completion:^(BOOL finished)
            {
                @strongify(self)
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
    else if ([keyPath isEqualToString:NSStringFromSelector(@selector(title))] && object == self.wkWebView)
    {
        if ([self.delegate respondsToSelector:@selector(fdwebViewChangeTitle:)]) {
            [self.delegate fdwebViewChangeTitle:self];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - 外部接口
- (void)loadRequest:(NSURLRequest *)request {
    [self.wkWebView loadRequest:request];
}

- (void)loadURL:(NSURL *)URL {
    [self loadRequest:[NSURLRequest requestWithURL:URL]];
}

- (void)loadURLString:(NSString *)URLString {
    NSURL *URL = [NSURL URLWithString:URLString];
    [self loadURL:URL];
}

- (void)loadHTMLString:(NSString *)HTMLString {
    [self.wkWebView loadHTMLString:HTMLString baseURL:nil];
}

- (void)setProgressTintColor:(UIColor *)tintColor TrackColor:(UIColor *)trackColor
{
    [self.progressView setTrackTintColor:trackColor];
    [self.progressView setTintColor:tintColor];
}

@end
