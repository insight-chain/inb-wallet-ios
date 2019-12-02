//
//  WelcomBackupVC.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/29.
//  Copyright © 2019 apple. All rights reserved.
//
/**
 * 创建钱包时候的备份
 */
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WelcomBackupVC : UIViewController
@property(nonatomic, strong) NSString *address;
@property(nonatomic, strong) NSString *memonry;
@property(nonatomic, strong) NSString *privateKey;
@property (nonatomic, assign) BOOL needVertify; //是否需要验证
@end

NS_ASSUME_NONNULL_END
