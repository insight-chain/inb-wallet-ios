//
//  EncryptedMessage.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/20.
//  Copyright © 2019 apple. All rights reserved.
//

#import "EncryptedMessage.h"
#import "NSData+HexString.h"

#import "inb_wallet_ios-Swift.h"

@interface EncryptedMessage()
@end

@implementation EncryptedMessage
-(instancetype)init:(NSString *)encStr nonce:(NSString *)nonce{
    if (self = [super init]) {
        self.encStr = encStr;
        self.nonce = nonce;
    }
    return self;
}
-(instancetype)initWithJSON:(NSDictionary *)json{
    if (self = [super init]) {
        NSString *encStr = json[@"encStr"];
        NSString *nonce = json[@"nonce"];
        if(encStr && nonce){
            self.encStr = encStr;
            self.nonce = nonce;
        }else{
            return nil;
        }
    }
    return self;
}

// use kdf with password to decrypt secert message
-(NSString *)decrypt:(Crypto *)crypto password:(NSString *)password{
    NSString *dk = [crypto derivedKey:password];
    AES128 *encryptor = [crypto encryptor:[dk substringToIndex:32] nonce:self.nonce];
    return [encryptor decrypt:self.encStr];
}

-(NSDictionary *)toJSON{
    return @{@"encStr":self.encStr,
             @"nonce":self.nonce,
             };
}

+(EncryptedMessage *)createCrypto:(Crypto *)crypto password:(NSString *)password message:(NSString *)message nonce:(NSString *)nonce{
    return [self createCrypto:crypto derivedKey:[crypto derivedKey:password] message:message nonce:nonce];
}
+(EncryptedMessage *)createCrypto:(Crypto *)crypto derivedKey:(NSString *)derivedKey message:(NSString *)message nonce:(NSString *)nonce{
    NSString *nonceWithFallback = nonce ? nonce : [[NSData random:16] dataToHexString];
    AES128 *encryptor = [crypto encryptor:[derivedKey substringToIndex:32] nonce:nonceWithFallback];
    return [[EncryptedMessage alloc] init:[encryptor encrypt:message] nonce:nonceWithFallback];
    
}


@end
