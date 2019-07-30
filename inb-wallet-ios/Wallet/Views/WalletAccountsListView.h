//
//  WalletAccountsListView.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/15.
//  Copyright © 2019 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BasicWallet;

typedef void(^ClickBlock)(BasicWallet * _Nullable wallet);

NS_ASSUME_NONNULL_BEGIN

@interface WalletAccountsListView : UIView
@property(nonatomic, copy) void(^addAccountBlock)(void);
@property(nonatomic, strong) NSArray *accounts; //账户数组
@property(nonatomic, strong) NSString *currentAccount;

+(instancetype)showAccountList:(NSArray *)accounts selectAccount:(BasicWallet *)selected clickBlock:(void(^)(int index))clickBlock;
@end

NS_ASSUME_NONNULL_END
