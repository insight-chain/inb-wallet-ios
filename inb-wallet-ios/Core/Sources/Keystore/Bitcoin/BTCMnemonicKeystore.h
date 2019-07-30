//
//  BTCMnemonicKeystore.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/23.
//  Copyright © 2019 apple. All rights reserved.
//

#import "Keystore.h"
#import "EncryptedMessage.h"

NS_ASSUME_NONNULL_BEGIN

@class Info;

/// 生成app特定的键和IV!
static NSString *commonKey = @"00000000000000000000000000000000";
static NSString *commonIv  = @"00000000000000000000000000000000";

@interface BTCMnemonicKeystore : PrivateKeyCrypto

@property(nonatomic, strong) NSString *mnemonicPath;
@property(nonatomic, strong) EncryptedMessage *encMnemonic;
@property(nonatomic, strong) NSString *xpub;

@property(nonatomic, strong) Info *info;


-(instancetype)initWithPassword:(NSString *)password mnemonic:(NSString *)mnemonic path:(NSString *)path metadata:(WalletMeta *)metadata ID:(NSString *)ID;
-(instancetype)initWithJSON:(NSDictionary *)json;

-(BOOL)verify:(NSString *)password;
-(NSString *)decryptMnemonic:(NSString *)password;

+(NSDictionary *)scriptDerivedPathCache;
+(BTCKey *)findUtxoKeyByScript:(NSString *)script at:(BTCKeychain *)keychain isSwgWit:(BOOL)isSwgWit;
+(NSData *)hashPubKey:(NSData *)data isSegWit:(BOOL)isSegWit;


@end

#pragma mark ---- 
@interface Info:NSObject
@property(nonatomic, strong, readonly) NSString *curve;
@property(nonatomic, strong, readonly) NSString *purpose;

-(instancetype)init;
-(instancetype)initWithJSON:(NSDictionary *)json;

-(NSDictionary *)toJSON;

@end

NS_ASSUME_NONNULL_END
