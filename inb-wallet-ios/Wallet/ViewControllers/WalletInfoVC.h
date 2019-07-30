//
//  WalletInfoVC.h
//  wallet
//
//  Created by apple on 2019/3/21.
//  Copyright © 2019 apple. All rights reserved.
//
/**
 * 钱包（账户）信息VC
 */
#import "ViewController.h"

@class WalletInfo, BasicWallet;
NS_ASSUME_NONNULL_BEGIN

@interface WalletInfoVC : ViewController

@property(nonatomic, strong) BasicWallet *selectedWallet; //当前选中的钱包
@property(nonatomic, strong) NSArray<BasicWallet *> *wallets;// 拥有的钱包

-(instancetype)initWithWallet:(WalletInfo *)wallet;

@end

NS_ASSUME_NONNULL_END
