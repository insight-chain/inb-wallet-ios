//
//  SigUtil.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/30.
//  Copyright © 2019 apple. All rights reserved.
//

#import "SigUtil.h"
#import "Secp256k1_Insight.h"
#import "NSData+Crypto.h"

@implementation SigUtil

+(NSDictionary *)personalSign:(NSString *)privateKey msgParams:(NSDictionary *)msgParams{
    NSString *data = msgParams[@"data"];
    if(!data){
        return @{@"error":@"no"};
    }
    return [self ecsignWith:privateKey data:[self hashPersonalMessage:data]];
}

+(NSDictionary *)ecsignWith:(NSString *)privateKey data:(NSString *)data{
    SignResult *resu = [[[Secp256k1_bridge alloc] init] signWithKey:privateKey message:data];
    NSDictionary *result = [[[Secp256k1_Insight alloc] init] signWithKey:privateKey message:data];
    NSString *v = [NSString stringWithFormat:@"%d", [result[@"recid"] intValue] + 27];
    NSString *r = [result[@"signature"] substringToIndex:64];
    NSString *s = [result[@"signature"] substringToIndex:64];
    return @{@"v":v, @"r":r, @"s":s};
}

+(NSString *)calcIPFSIDFromKey:(BTCKey *)key{
    NSData *pubKeyHash = [key.publicKey sha256];
    uint8_t multiHashIndex = 0x12;
    uint8_t length = (uint8_t)pubKeyHash.length;
    NSMutableData *ipfsIdData = [NSMutableData dataWithBytes:&multiHashIndex length:sizeof(uint8_t)];
    [ipfsIdData appendData:[NSData dataWithBytes:&length length:sizeof(uint8_t)]];
    [ipfsIdData appendData:pubKeyHash];
    return BTCBase58StringWithData(ipfsIdData);
}
@end
