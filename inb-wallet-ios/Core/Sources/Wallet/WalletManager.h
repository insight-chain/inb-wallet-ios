//
//  WalletManager.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/23.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicWallet.h"

#import "TransactionSignedResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletManager : NSObject

+(BasicWallet *)importFromMnemonic:(NSString *)mnemonic metadata:(WalletMeta *)metadata encryptBy:(NSString *)password path:(NSString *)path;
/**
 Import ETH keystore json to generate wallet
 
 - parameter keystore: JSON text
 - parameter password: Password of keystore
 - parameter metadata: Wallet metadata
 */
+(BasicWallet *)importFromKeystore:(NSDictionary *)keystore encryptedBy:(NSString *)password metadata:(WalletMeta *)metadata;
+(BasicWallet *)importFromPrivateKey:(NSString *)private encryptedBy:(NSString *)password metadata:(WalletMeta *)metadata accountName:(NSString *)account;

+(NSString *)exportPrivateKeyForID:(NSString *)walletID password:(NSString *)password;
+(NSString *)exportMnemonicForID:(NSString *)walletID password:(NSString *)password;
+(NSString *)exportKeystoreForID:(NSString *)walletID password:(NSString *)password;

+(BasicWallet *)findWalletByPrivateKey:(NSString *)privateKey chainType:(ChainType)chainType network:(NSString *)network segWit:(NSString *)segWit;
+(BasicWallet *)findWalletByMnemonic:(NSString *)mnemonic chainType:(ChainType)chainType path:(NSString *)path network:(NSString *)network segWit:(NSString *)segWit;
+(BasicWallet *)findWalletByKeystore:(NSDictionary *)keystore chainType:(ChainType)chainType passwork:(NSString *)password;
+(BasicWallet *)findWalletByWalletID:(NSString *)walletID;
+(BasicWallet *)findWalletByAddress:(NSString *)address chainType:(ChainType)chainType;

+(BasicWallet *)modifyWalletPasswordByWalletID:(NSString *)walletID oldPassword:(NSString *)old newPassword:(NSString *)newPassword;

/**
 * Sign transaction with given parameters
 * chainID: Chain ID, 1 by default after [EIP 155](https://github.com/ethereum/EIPs/issues/155) fork.
 * returns signed data
 */
+(TransactionSignedResult *)ethSignTransactionWithWalletID:(NSString *)walletID nonce:(NSString *)nonce txType:(TxType)txType gasPrice:(NSString *)gasPrice gasLimit:(NSString *)gasLimit to:(NSString *)to value:(NSString *)value data:(NSString *)data password:(NSString *)password chainID:(int)chainID;
/** 抵押交易 **/
+(TransactionSignedResult *)inbMortgageWithWalletID:(NSString *)walletID value:(NSString *)value password:(NSString *)password chainID:(int)chainID;

/** BTC交易 **/
+(TransactionSignedResult *)btcSignTransactionWithWalletID:(NSString *)walletID to:(NSString *)to amount:(int64_t)amount fee:(int64_t)fee password:(NSString *)password outputs:(NSArray *)outputs changeIdx:(int)changeIdx isTestnet:(BOOL)isTestnet segWit:(NSString *)segWit;
@end

NS_ASSUME_NONNULL_END
