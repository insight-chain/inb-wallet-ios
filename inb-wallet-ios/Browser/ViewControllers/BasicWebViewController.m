//
//  BasiceWebViewController.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/28.
//  Copyright © 2019 apple. All rights reserved.
//

#import "BasicWebViewController.h"


@interface BasicWebViewController ()<WKNavigationDelegate, WKUIDelegate>

@property(nonatomic, strong) UIProgressView *progressView;

@end

@implementation BasicWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /** 进度条初始化 **/
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, 2)];
    self.progressView.backgroundColor = [UIColor clearColor];
    self.progressView.trackTintColor = [UIColor clearColor];//设置进度条颜色
    self.progressView.progressTintColor = kColorBlue; //设置进度条上进度的颜色
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    
    //开了支持滑动返回
    self.webView.allowsBackForwardNavigationGestures = YES;
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    
    
    [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(self.view);
    }];
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
}

-(void)dealloc{
    //移除监听
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}



#pragma mark ---- 监听
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webView.estimatedProgress;
        if (self.progressView.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
                
            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

//重写左上角返回按钮，这个很重要，用户体验影响很大
-(void)backNative{
    //判断是否有上一层H5
    if([self.webView canGoBack]){
        //如果有,则返回
        [self.webView goBack];
        //同事设置返回按钮和关闭按钮为导航栏左边的按钮
        self.navigationItem.leftBarButtonItems = @[];
    }else{
        [self closeNative];
    }
}
-(void)closeNative{
    
}

#pragma mark ---- WKUIDelegate主要处理JS脚本，确认框，警告框等
// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    return [[WKWebView alloc]init];
}
// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    completionHandler(@"http");
}
// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    completionHandler(YES);
}
// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"%@",message);
    completionHandler();
}
#pragma mark ---- WKNavigationDelegate主要处理一些跳转、加载处理操作
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
    /** 进度条： 开始加载网页时展示出progressView **/
    self.progressView.hidden = NO;
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f); //开始加载网页的时候将progressView的Height恢复为1.5倍
    [self.view bringSubviewToFront:self.progressView];//防止progressView被网页挡住
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    /** 进度条：加载完成后隐藏progressView ***/
    self.progressView.hidden = YES;
    
    //这里修改导航栏的标题，动态改变
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
    /** 进度条：加载完成后隐藏progressView ***/
    self.progressView.hidden = YES;
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
    //允许跳转,必须加，否则会异常
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSLog(@"%@",navigationAction.request.URL.absoluteString);
    
    WKNavigationActionPolicy actionPolicy = WKNavigationActionPolicyAllow;
    
    if(navigationAction.navigationType == WKNavigationTypeBackForward){//判断是返回类型
        //同时设置返回按钮和关闭按钮为导航栏左边的按钮 这里可以监听左滑返回事件，仿微信添加关闭按钮。
        self.navigationItem.leftBarButtonItems = @[];
        //可以在这里找到指定的历史页面做跳转
        //        if (webView.backForwardList.backList.count>0) {                                  //得到栈里面的list
        //            DLog(@"%@",webView.backForwardList.backList);
        //            DLog(@"%@",webView.backForwardList.currentItem);
        //            WKBackForwardListItem * item = webView.backForwardList.currentItem;          //得到现在加载的list
        //            for (WKBackForwardListItem * backItem in webView.backForwardList.backList) { //循环遍历，得到你想退出到
        //                //添加判断条件
        //                [webView goToBackForwardListItem:[webView.backForwardList.backList firstObject]];
        //            }
        //        }
    }
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationActionPolicyCancel);
}
#pragma mark ---- getter
-(WKWebView *)webView{
    if (_webView == nil) {
        _webView = [[WKWebView alloc] init];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
    }
    return _webView;
}
@end
