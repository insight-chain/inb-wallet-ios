//
//  AppDelegate.h
//  test
//
//  Created by insightChain_iOS开发 on 2019/6/4.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *apiHost;
@property (strong, nonatomic) NSString *webHost;
@property (strong, nonatomic) NSString *rpcHost;
@property (strong, nonatomic) NSString *explorerHost;
@property (strong, nonatomic) NSString *explorerWeb;

@property (copy, nonatomic) NSString *selectAddr;  //选择的钱包地址
@property (copy, nonatomic) NSString *selectWalletID; //选择的钱包ID
@property (nonatomic, assign) BOOL isTest; //YES-测试网络，NO-正式网络
@end

