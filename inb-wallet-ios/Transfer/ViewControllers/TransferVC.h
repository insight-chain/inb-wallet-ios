//
//  TransferVC.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/7.
//  Copyright © 2019 apple. All rights reserved.
//
/**
 *  转账 控制器
 */
#import <UIKit/UIKit.h>
#import "BasicWallet.h"

NS_ASSUME_NONNULL_BEGIN

@interface TransferVC : UIViewController

@property(nonatomic, strong) BasicWallet *wallet;
@property(nonatomic, assign) double balance; //余额
@end

NS_ASSUME_NONNULL_END
