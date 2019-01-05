//
//  MOLWebViewController.m
//  reward
//
//  Created by moli-2017 on 2018/10/10.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>
#import "MOLWeakScriptMessageHandler.h"
#import "MOLJSManager.h"

@interface MOLWebViewController ()<WKUIDelegate, WKNavigationDelegate, UIGestureRecognizerDelegate, MOLScriptMessageHandler>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIBarButtonItem *backItem;
@property (nonatomic, strong) UIBarButtonItem *closeItem;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) WKNavigation *backNavigation;

@property (nonatomic, strong) MOLJSManager *jsHelper;
@property (nonatomic, strong) NSArray *bridgeArray;

@end

@implementation MOLWebViewController

- (BOOL)showNavigationLine
{
    return YES;
}


- (void)dealloc
{
    [self.webView.configuration.userContentController removeAllUserScripts];
    
    [self.webView removeObserver:self forKeyPath:@"loading"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    
    self.webView.UIDelegate = nil;
    self.webView.navigationDelegate = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self clearCache];
}

- (void)clearCache
{
    if (@available(iOS 9.0, *)) {
        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        }];
    } else {
        // Fallback on earlier versions
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (![self.urlString hasPrefix:@"http"]) {
        return;
    }
    [self setupNaviBar];
    
    [self setupWebView];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"loading"]) {
        
    } else if([keyPath isEqualToString:@"title"]) {
        if (!self.titleString.length) {
            
            [self basevc_setCenterTitle:self.webView.title titleColor:HEX_COLOR(0xffffff)];
        }
    } else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
    }
    // 加载完成时
    if (![self.webView isLoading]) {
        [UIView animateWithDuration:0.5 animations:^{
            self.progressView.alpha = 0.0;
        }];
    }
}

#pragma mark - JAScriptMessageHandler
- (void)ja_userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message isEqual:[NSNull null]] ||!message.body) {
        // 无参数
        SEL selector = NSSelectorFromString(message.name);
        if ([self.jsHelper respondsToSelector:selector]) {
            IMP imp = [self.jsHelper methodForSelector:selector];
            void (*func)(id, SEL) = (void *)imp;
            func(self.jsHelper, selector);
        }
    } else {
        // 带参数（json串）
        NSString *methods = [NSString stringWithFormat:@"%@:", message.name];
        SEL selector = NSSelectorFromString(methods);
        if ([self.jsHelper respondsToSelector:selector]) {
            // messaeg.body json串自动转json对象
            if ([message.body isKindOfClass:[NSDictionary class]]) {
                IMP imp = [self.jsHelper methodForSelector:selector];
                void (*func)(id, SEL, NSString *) = (void *)imp;
                func(self.jsHelper, selector, message.body);
            }else if ([message.body isKindOfClass:[NSString class]]){
                IMP imp = [self.jsHelper methodForSelector:selector];
                void (*func)(id, SEL, NSString *) = (void *)imp;
                func(self.jsHelper, selector, message.body);
            }else if ([message.body isKindOfClass:[NSNumber class]]){
                IMP imp = [self.jsHelper methodForSelector:selector];
                void (*func)(id, SEL, NSString *) = (void *)imp;
                func(self.jsHelper, selector, [NSString stringWithFormat:@"%@",message.body]);
            }
        }
    }
}

#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {}

// 内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    if (webView.canGoBack) {
        [self setupBackButton];
    }
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    // 苹果bug, 不禁掉双击网页会崩溃
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
        [self.webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none'" completionHandler:nil];
        [self.webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none'" completionHandler:nil];
    }
    
    if ([self.backNavigation isEqual:navigation]) { // 这次的加载是点击返回产生的，刷新
        [webView reload];
        self.backNavigation = nil;
    }
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
}

// 接受到服务器跳转之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
}

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
   
    if (navigationAction.request.URL.host.lowercaseString.length > 0) {
        self.progressView.alpha = 1.0;
        decisionHandler(WKNavigationActionPolicyAllow);
    } else if([navigationAction.request.URL.scheme isEqualToString:@"tel"]){
        NSURL *URL = navigationAction.request.URL;
        NSString *scheme = [URL scheme];
        if ([scheme isEqualToString:@"tel"]) {
            NSString *resourceSpecifier = [URL resourceSpecifier];
            NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", resourceSpecifier];
            /// 防止iOS 10及其之后，拨打电话系统弹出框延迟出现
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
            });
        }
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyCancel);
    }}

#pragma mark - WKUIDelegate
// 会拦截到window.open()事件.
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

/// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    // 根据返回得到展示信息
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:prompt preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = defaultText;
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

/// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

/// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 按钮点击
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.webView.canGoBack) {
        self.backNavigation = [self.webView goBack];
        self.navigationItem.leftBarButtonItems = @[self.backItem, self.closeItem];
        return NO;
    }
    return YES;
}

- (void)clickedBackItem:(UIBarButtonItem *)btn{
    if (self.webView.canGoBack) {
        self.backNavigation = [self.webView goBack];
        [self setupBackButton];
    }else{
        [self clickedCloseItem];
    }
}

- (void)setupBackButton {
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    // 在这里测试负数没有达到效果,正数是可以加大间距
    negativeSpacer.width = 10;
    self.navigationItem.leftBarButtonItems = @[self.backItem, self.closeItem, negativeSpacer];
}

- (void)clickedCloseItem {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 全屏
-(void)RegeistNoticeCenter
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}

-(void)startFullScreen
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

-(void)endFullScreen
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

#pragma mark - UI
- (void)setupWebView
{
    self.bridgeArray = @[
                         @"js_startWithUser",
                         @"shareActive",
                         @"shareWithCopyWord",
                         @"openAppWithPage"
                         ];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.allowsInlineMediaPlayback = YES;
    config.userContentController = [NSClassFromString(@"WKUserContentController") new];
    for (NSString *str in self.bridgeArray) {
        [config.userContentController addScriptMessageHandler:[[MOLWeakScriptMessageHandler alloc] initWithHandler:self] name:str];
    }
    
    WKPreferences* preferences = [NSClassFromString(@"WKPreferences") new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    config.preferences = preferences;
    
    self.webView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:config];
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.opaque = NO;
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self.webView addObserver:self forKeyPath:@"loading" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.view addSubview:self.webView];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    [self.webView loadRequest:request];
    
    [self setupProgressView];
    
    [self RegeistNoticeCenter];
    
    self.jsHelper = [MOLJSManager new];
    self.jsHelper.webView = self.webView;
    
//    if (@available(iOS 11.0, *)) {
//        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    }else{
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
}

- (void)keyboardWillHide
{
    self.webView.scrollView.contentOffset = CGPointMake(0, 0);
}

- (void)setupNaviBar
{
    if (self.titleString.length) {
        [self basevc_setCenterTitle:self.titleString titleColor:HEX_COLOR(0xffffff)];
    }
    
    UIImage *image = [[UIImage imageNamed:@"navigation_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(clickedBackItem:)];
    backItem.imageInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    self.backItem = backItem;
    
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(clickedCloseItem)];
    closeItem.tintColor = HEX_COLOR(0x363636);
    self.closeItem = closeItem;
    
    self.navigationItem.leftBarButtonItems = @[backItem];
}

- (void)setupProgressView
{
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.width = MOL_SCREEN_WIDTH;
    self.progressView.tintColor = HEX_COLOR(0x6BD379);
    self.progressView.trackTintColor = [UIColor clearColor];
    [self.view addSubview:self.progressView];
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 2.0f);
    self.progressView.y = MOL_StatusBarAndNavigationBarHeight;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.webView.width = self.view.width;
    self.webView.height = self.view.height - MOL_StatusBarAndNavigationBarHeight;
    self.webView.y = MOL_StatusBarAndNavigationBarHeight;
}
@end
