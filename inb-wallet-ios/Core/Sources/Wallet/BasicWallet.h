//
//  BasicWallet.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/17.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Keystore.h"

NS_ASSUME_NONNULL_BEGIN

@interface BasicWallet : NSObject
@property(nonatomic, strong) NSString *walletID;
@property(nonatomic, strong) Keystore *keystore;

@property(nonatomic, assign) ChainType chain;
@property(nonatomic, strong) NSString *chainType;

@property(nonatomic, strong, readonly) NSString *name;
@property(nonatomic, strong, readonly) NSString *address;
@property(nonatomic, strong, readonly) WalletMeta *imTokenMeta;

@property(nonatomic, assign) double mortgagedINB; //已抵押的INB
@property(nonatomic, assign) double balanceINB; //INB余额

-(instancetype)initWithJSON:(NSDictionary *)json;
-(instancetype)initWithKeystore:(Keystore *)keystore;


-(NSString *)exportMnemonic:(NSString *)password;
-(NSString *)exportT;

-(NSString *)privateKey:(NSString *)password;

-(BOOL)deleteWallet;
-(BOOL)verifyPassword:(NSString *)password;

-(NSString *)derivedKeyByPassword:(NSString *)password;
-(NSDictionary *)serializeToMap;

-(NSString *)calcExternalAddressAt:(int)externalIdx;
@end

NS_ASSUME_NONNULL_END
