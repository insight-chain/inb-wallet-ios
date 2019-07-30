//
//  Keccak256.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/21.
//  Copyright © 2019 apple. All rights reserved.
//

#import "Keccak256.h"
#import "NSData+HexString.h"

#import <CommonCrypto/CommonCrypto.h>

@implementation Keccak256
-(instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}
-(NSString *)encrypt:(NSString *)hex{
    
    return [self encryptData:[NSData hexStringToData:hex]]; //[hex dataUsingEncoding:NSUTF8StringEncoding]
}
-(NSString *)encryptData:(NSData *)data{
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256(data.bytes, data.length, digest);
    
    NSData *da = [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    return [da dataToHexString];
}
@end
