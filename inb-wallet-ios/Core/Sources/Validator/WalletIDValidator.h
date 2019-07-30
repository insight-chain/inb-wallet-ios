//
//  WalletIDValidator.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/22.
//  Copyright © 2019 apple. All rights reserved.
//
/** 钱包ID验证器 **/
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WalletIDValidator : NSObject

@property(nonatomic, assign) BOOL isValid;

-(instancetype)initWithWalletID:(NSString *)walletID;

-(NSString *)validate;

@end

NS_ASSUME_NONNULL_END
