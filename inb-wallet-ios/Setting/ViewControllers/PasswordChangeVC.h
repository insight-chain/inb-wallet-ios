//
//  PasswordChangeVC.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/24.
//  Copyright © 2019 apple. All rights reserved.
//
/**
 * 修改密码
 */
#import <UIKit/UIKit.h>
@class BasicWallet;
NS_ASSUME_NONNULL_BEGIN

@interface PasswordChangeVC : UIViewController

@property(nonatomic, strong) BasicWallet *wallet;

@end

NS_ASSUME_NONNULL_END
