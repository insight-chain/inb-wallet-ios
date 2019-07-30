//
//  WalletBackupVC.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/15.
//  Copyright © 2019 apple. All rights reserved.
//
/**
 * 备份钱包
 */
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WalletBackupVC : UIViewController
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *privateKey; //私钥
@property(nonatomic, strong) NSString *menmonryKey; //助记词
@end

NS_ASSUME_NONNULL_END
