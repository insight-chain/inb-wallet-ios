//
//  BasiceWebViewController.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/28.
//  Copyright © 2019 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BasicWebViewController : UIViewController
@property(nonatomic, strong) WKWebView *webView;

@property(nonatomic, strong) NSString *urlStr;

@end

NS_ASSUME_NONNULL_END
