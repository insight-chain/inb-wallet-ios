//
//  EncryptedMessage.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/20.
//  Copyright © 2019 apple. All rights reserved.
//
/**
 * Store anything like { encStr: "secertMessage", nonce: "randomBytes" }
 */
#import <Foundation/Foundation.h>

#import "Crypto.h"

NS_ASSUME_NONNULL_BEGIN

@interface EncryptedMessage : NSObject

@property(nonatomic, strong) NSString *encStr;
@property(nonatomic, strong) NSString *nonce;

-(instancetype)init:(NSString *)encStr nonce:(NSString *)nonce;
-(instancetype)initWithJSON:(NSDictionary *)json;

+(EncryptedMessage *)createCrypto:(Crypto *)crypto password:(NSString *)password message:(NSString *)message nonce:(NSString *)nonce;
+(EncryptedMessage *)createCrypto:(Crypto *)crypto derivedKey:(NSString *)derivedKey message:(NSString *)message nonce:(NSString *)nonce;

-(NSString *)decrypt:(Crypto *)crypto password:(NSString *)password;
-(NSDictionary *)toJSON;

@end

NS_ASSUME_NONNULL_END
