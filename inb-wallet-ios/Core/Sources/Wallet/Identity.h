//
//  Identity.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/20.
//  Copyright © 2019 apple. All rights reserved.
//
/**
 * 身份
 */
#import <Foundation/Foundation.h>

#import "Keystore.h"
#import "WalletMeta.h"
#import "IdentityKeystore.h"

NS_ASSUME_NONNULL_BEGIN

@interface Identity : NSObject

@property(nonatomic, strong) IdentityKeystore *keystore;
@property(nonatomic, strong) NSString *identifier;
@property(nonatomic, strong) NSArray *wallets;

-(instancetype)initWithJSON:(NSDictionary *)json;
-(instancetype)initWithMetadata:(WalletMeta *)metadata mnemonic:(NSString *)mnemonic password:(NSString *)password;

-(instancetype)initBTCWithMetadata:(WalletMeta *)metadata mnemonic:(NSString *)mnemonic password:(NSString *)password;

-(NSArray *)deriveWalletsFor:(NSArray *)chainTypes password:(NSString *)password;
-(NSArray *)deriveWallets:(NSArray *)chainTypes mnemonic:(NSString *)mnemonic password:(NSString *)password name:(NSString *)name;

-(NSString *)exportWith:(NSString *)password;
-(BOOL)deleteWith:(NSString *)password;



-(BasicWallet *)appendByKeystore:(Keystore *)keystore;
-(BOOL)removeWallet:(BasicWallet *)wallet;

-(BasicWallet *)importFromMnemonic:(NSString *)mnemonic metadata:(WalletMeta *)metadata password:(NSString *)password path:(NSString *)path;

-(BasicWallet *)importFromKeystore:(NSDictionary *)keystore password:(NSString *)password metadata:(WalletMeta *)metadata;
-(BasicWallet *)importFromPrivateKey:(NSString *)privateKey encryptedBy:(NSString *)password metadata:(WalletMeta *)metadata accountName:(NSString *)accountName;

-(BasicWallet *)findWalletByWalletID:(NSString *)walletID;
-(BasicWallet *)findWalletByAddress:(NSString *)address chainType:(ChainType)chainType;
-(BasicWallet *)findWalletByPrivateKey:(NSString *)privateKey chainType:(ChainType)chainType network:(NSString *)network segWit:(NSString *)segWit;
-(BasicWallet *)findWalletByMnemonic:(NSString *)mnemonic chainType:(ChainType)chainType path:(NSString*)path network:(NSString *)netWork segWit:(NSString *)segWit;
-(BasicWallet *)findWalletByKeystore:(NSDictionary *)keystore chainType:(ChainType)chainType password:(NSString *)password;

#pragma mark ---- 工厂方法和存储
+(void)setCurrentIdentity:(Identity *)identity;
+(Identity *)currentIdentity;

/**
 * return @{@"mnemonic":String, @"identity":Identity}
 */
+(NSDictionary *)createIdentityWithPassword:(NSString *)password metadata:(WalletMeta *)metadata;
+(Identity *)recoverIdentityWithMetadata:(WalletMeta *)metadata mnemonic:(NSString *)mnemonic password:(NSString *)password;

+(NSDictionary *)createBtcIdentityWithPassword:(NSString *)password metadata:(WalletMeta *)metadata;

@end

NS_ASSUME_NONNULL_END
