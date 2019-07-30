//
//  NSData+Crypto.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/3/31.
//  Copyright © 2019 apple. All rights reserved.
//

#import "NSData+Crypto.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSData (Crypto)

-(UInt16)checksum{
    UInt32 s = 0;
    const void *bytesArray = self.bytes;
//    for (int i=0; i<strlen(bytesArray); i++) {
//        s = s + (UInt32)(bytesArray[i]);
//    }
    s = s%65535;
    return UINT16_C(s);
}
-(NSData *)md5{
    const char *original_str = [self bytes];
    
    unsigned char digist[CC_MD5_DIGEST_LENGTH]; //CC_MD5_DIGEST_LENGTH = 16
    CC_MD5(original_str, (uint)strlen(original_str), digist);
    NSMutableString *outPutStr = [NSMutableString stringWithCapacity:10];
    for (int i =0 ; i<CC_MD5_DIGEST_LENGTH; i++) {
        [outPutStr appendFormat:@"%02x", digist[i]]; //小写x表示输出的是小写MD5，大写X表示输出的是大写MD5
    }
    
    Byte byte[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (uint)strlen(original_str), byte);
    
    return [NSMutableData dataWithBytes:byte length:CC_MD5_DIGEST_LENGTH];
}
-(NSData *)sha1{
    
    Byte byte[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(self.bytes, (uint)self.length, byte);
    return [NSMutableData dataWithBytes:byte length:CC_SHA1_DIGEST_LENGTH];
}
-(NSData *)sha224{
    Byte byte[CC_SHA224_DIGEST_LENGTH];
    CC_SHA224(self.bytes, (uint)self.length, byte);
    return [NSData dataWithBytes:byte length:CC_SHA224_DIGEST_LENGTH];
}
-(NSData *)sha256{
    Byte byte[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(self.bytes, (uint)self.length, byte);
    return [NSData dataWithBytes:byte length:CC_SHA256_DIGEST_LENGTH];
}
-(NSData *)sha384{
    Byte byte[CC_SHA384_DIGEST_LENGTH];
    CC_SHA384(self.bytes, (uint)self.length, byte);
    return [NSData dataWithBytes:byte length:CC_SHA384_DIGEST_LENGTH];
}
-(NSData *)sha512{
    Byte byte[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(self.bytes, (uint)self.length, byte);
    return [NSData dataWithBytes:byte length:CC_SHA512_DIGEST_LENGTH];
}

@end
