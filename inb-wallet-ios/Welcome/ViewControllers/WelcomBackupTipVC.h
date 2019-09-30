//
//  WelcomBackupTipVC.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/28.
//  Copyright © 2019 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BasicWallet;
NS_ASSUME_NONNULL_BEGIN

@interface WelcomBackupTipVC : UIViewController
@property(nonatomic, strong) BasicWallet *wallet;
@property(nonatomic, strong) NSString *password;
@property (nonatomic, assign) BOOL needVertify; //是否需要验证
@end

NS_ASSUME_NONNULL_END
