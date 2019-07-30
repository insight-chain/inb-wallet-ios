//
//  WalletDetailVC.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/9.
//  Copyright © 2019 apple. All rights reserved.
//
/**
 *  钱包详情
 */
#import <UIKit/UIKit.h>

#import "BasicWallet.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletDetailVC : UIViewController
@property(nonatomic, strong) BasicWallet *wallet;
@end

#pragma mark ---- 点击按钮
@interface MoreView : UIView

-(instancetype)initWithTitle:(NSString *)title click:(void(^)(void))click;
@end

NS_ASSUME_NONNULL_END
