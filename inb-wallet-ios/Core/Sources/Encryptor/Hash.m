//
//  Hash.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/30.
//  Copyright © 2019 apple. All rights reserved.
//

#import "Hash.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
@implementation Hash


/**
 *  加密方式,MAC算法: HmacSHA256
 *
 *  @param key       秘钥
 *  @param data 要加密的文本
 *
 *  @return 加密后的Data
 */
+(NSData *)hmacSHA256WithKey:(NSData *)key data:(NSData *)data{
   
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, key.bytes, key.length, data.bytes, data.length, cHMAC);
    NSData *HMACData = [NSData dataWithBytes:cHMAC length:sizeof(cHMAC)];
    return HMACData;
}
+(NSData *)merkleRoot:(NSData *)cipherData{
    return nil;
}
@end
