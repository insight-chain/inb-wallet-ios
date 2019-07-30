//
//  IdentityKeystore.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/20.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Crypto.h"
#import "WalletMeta.h"
#import "EncryptedMessage.h"
#import "BasicWallet.h"

NS_ASSUME_NONNULL_BEGIN

@interface IdentityKeystore : NSObject

@property(nonatomic, strong) NSString *ID;
@property(nonatomic, strong) NSString *identifier;
@property(nonatomic, assign) int version;
@property(nonatomic, strong) Crypto *crypto;
@property(nonatomic, strong) WalletMeta *meta;
@property(nonatomic, strong) EncryptedMessage *encAuthKey;
@property(nonatomic, strong) EncryptedMessage *encMnemonic;

@property(nonatomic, strong, readonly) NSString *encKey;
@property(nonatomic, strong, readonly) NSString *ipfsId;

@property(nonatomic, strong) NSMutableArray *walletIds;
@property(nonatomic, strong) NSMutableArray<BasicWallet *> *wallets;

-(instancetype)initWithMetadata:(WalletMeta *)metadata menmonic:(NSString *)menmonic password:(NSString *)password;
-(instancetype)initWithJSON:(NSDictionary *)json;

-(NSString *)dump:(BOOL)includingExtra;
-(BOOL)verify:(NSString*)password;

-(NSString *)mnemonic:(NSString *)password;

-(NSDictionary *)toJSON;
-(NSDictionary *)serializeToMap;

+(int)defaultVersion;
@end

NS_ASSUME_NONNULL_END
