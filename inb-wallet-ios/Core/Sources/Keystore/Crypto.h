//
//  Crypto.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/17.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AES128.h"

@class Cipherparams, ScryptKdfparams, CachedDerivedKey;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CipherType){
    aes128Ctr = 0, // AES-128-CTR is the minimal requirement
    aes128Cbc, //Version 1 fixed algorithm
};

@interface Crypto : NSObject

@property(nonatomic, strong) NSString *cipher; //"aes-128-ctr"
@property(nonatomic, strong) NSString *ciphertext;
@property(nonatomic, strong) Cipherparams *cipherparams;

@property(nonatomic, strong) NSString *kdf;
@property(nonatomic, strong) ScryptKdfparams *kdfparams;//KDF-dependent static and dynamic parameters to the KDF function

@property(nonatomic, strong) NSString *mac; //SHA3 (keccak-256) of the concatenation of the last 16 bytes of the derived key together with the full ciphertext

@property(nonatomic, strong) CachedDerivedKey *cachedDerivedKey;
//@property(nonatomic, assign) BOOL *cachedDerivedKey;//指定密码是否应该缓存派生密钥


-(instancetype)initWith:(NSString *)password privateKey:(NSString *)privateKey cacheDerivedKey:(BOOL)cacheDerivedKey;
-(instancetype)initWithJSON:(NSDictionary *)json;


-(NSDictionary *)toJSON;

-(NSString *)derivedKey:(NSString *)password; //根据密码 导出 key
-(NSString *)cachedDerivedKey:(NSString *)password;
-(void)clearDerivedKey;
-(AES128 *)encryptor:(NSString *)key  nonce:(NSString *)nonce;

//ciphertext -> private key
-(NSString *)privateKey:(NSString *)password;
-(NSString *)macFrom:(NSString *)password;
-(NSString *)macForDerivedKey:(NSString *)key;


-(NSString *)cipherStr:(CipherType) cipherType;
@end


#pragma mark ---- Cipherparams
@interface Cipherparams : NSObject
@property(nonatomic, strong) NSString *iv; //用于密码的128位初始化向量。

-(instancetype)init;
-(instancetype)initWithJSON:(NSDictionary *)json;

-(NSDictionary *)toJSON;
@end


#pragma mark ----
@interface ScryptKdfparams:NSObject

-(instancetype)initWithSalt:(NSString *)salt;
-(instancetype)initWithJSON:(NSDictionary *)json;

-(NSDictionary *)toJSON;
-(NSString *)derivedKey:(NSString *)password;

@end

#pragma mark ---- Cache derivedKey
@interface CachedDerivedKey : NSObject
-(void)cache:(NSString *)password derivedKey:(NSString *)derivedKey;
-(void)clear;

-(NSString *)fetch:(NSString *)password;

@end

NS_ASSUME_NONNULL_END
