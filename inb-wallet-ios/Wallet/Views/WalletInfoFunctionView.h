//
//  WalletInfoFunctionView.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/2.
//  Copyright © 2019 apple. All rights reserved.
//
/**
 * 钱包信息 功能view
 * 转账、收款、扫码等功能按钮
 */
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WalletInfoFunctionView : UIView
@property(nonatomic, copy) void(^click)(FunctionType type);
@end

NS_ASSUME_NONNULL_END
