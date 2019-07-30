//
//  Mnemonic.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/22.
//  Copyright © 2019 apple. All rights reserved.
//

#import "Mnemonic.h"

#import "MnemonicDictionary.h"
#import <CommonCrypto/CommonCrypto.h>
#import "NSData+HexString.h"

@implementation ETHMnemonic
-(instancetype)init{
    return [self initWithSeed:[ETHMnemonic generateSeed:128]];
}
-(instancetype)initWithMnemonic:(NSString *)mnemonic passphrase:(NSString *)passphrase{
    if (self = [super init]) {
        self.mnemonic = mnemonic;
        self.seed = [ETHMnemonic deterministicSeed:mnemonic passphrase:passphrase];
    }
    return self;
}
-(instancetype)initWithSeed:(NSString *)seed{
    if (self = [super init]) {
        self.mnemonic = [ETHMnemonic generate:seed];
        self.seed = seed;
    }
    return  self;
}

/** 根据seed 生成 助记词 **/
+(NSString *)generate:(NSString *)seed{
    NSData *seedData = [NSData hexStringToData:seed];
    NSMutableData *data = [self sha256:seedData];
    
    NSUInteger bitLength = seedData.length * 8;
    if (bitLength != 128 &&
        bitLength != 160 &&
        bitLength != 192 &&
        bitLength != 224 &&
        bitLength != 256) {
        [[NSException exceptionWithName:@"Bad entropy length" reason:@"Raw entropy must be 128, 160, 192, 224, or 256 bits" userInfo:nil] raise];
    }
    
    NSUInteger checksumLength = bitLength/32;
    uint8_t checksumByte = (uint8_t)(((0xFF<<(8-checksumLength)) & 0xFF) & (0xFF & ((int)((uint8_t*)data.bytes)[0])));
    
    //向种子追加适当 校验位
    NSMutableData *buf = [seedData mutableCopy];
    [buf appendBytes:&checksumLength length:1];
    
    NSArray *wordList = [MnemonicDictionary dictionary];
    
    NSMutableArray *words = [NSMutableArray array];
    NSUInteger wordsCount = (bitLength + checksumLength)/11;
//    for (int i=0; i< wordsCount; i++) {
//        NSUInteger wordIndex = BTCMnemonicIntegerFrom11Bits((uint8_t*)buf.bytes, i * 11);
//        [words addObject:wordList[wordIndex]];
//    }
    return [words componentsJoinedByString:@" "];
}
+(NSString *)deterministicSeed:(NSString *)mnemonic passphrase:(NSString *)passphrase{
    NSData *data =
    [mnemonic dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    
    NSString *normalizedPassphrase = [[NSString alloc] initWithData:[passphrase dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES] encoding:NSASCIIStringEncoding];
    
    NSData *salt = [[NSString stringWithFormat:@"mnemonic%@",normalizedPassphrase] dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];
    
    const NSUInteger derivedKeyLen = CC_SHA512_DIGEST_LENGTH;
    NSMutableData* derivedKey = [NSMutableData dataWithLength:derivedKeyLen];
    CCKeyDerivationPBKDF(kCCPBKDF2, data.bytes, data.length, salt.bytes, salt.length, kCCPRFHmacAlgSHA512, 2048, derivedKey.mutableBytes, derivedKeyLen);
    
    return [derivedKey dataToHexString];
}
//strength: 可以被32整除
+(NSString *)generateSeed:(int)strength{
    if (strength % 32 != 0) {
        [[NSException exceptionWithName:@"MnemonicError" reason:@"lengthInvalid" userInfo:nil] raise];;
    }
    NSMutableData *mut = [NSMutableData dataWithLength:strength/8];
    SecRandomCopyBytes(kSecRandomDefault, strength/8, mut.mutableBytes);
    
    return [mut dataToHexString];
}

+(NSMutableData *)sha256:(NSData *)data{
    unsigned char digest[CC_SHA256_DIGEST_LENGTH];
    
    __block CC_SHA256_CTX ctx;
    CC_SHA256_Init(&ctx);
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        CC_SHA256_Update(&ctx, bytes, (CC_LONG)byteRange.length);
    }];
    CC_SHA256_Final(digest, &ctx);
    
    NSMutableData* result = [NSMutableData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    BTCSecureMemset(digest, 0, CC_SHA256_DIGEST_LENGTH);
    
    
    
    return result;
}

//void *BTCSecureMemset(void *v, unsigned char c, size_t n) {
//    if (!v) return v;
//    volatile unsigned char *p = v;
//    while (n--)
//        *p++ = c;
//
//    return v;
//}
//NSUInteger BTCMnemonicIntegerFrom11Bits(uint8_t* buf, int bitIndex) {
//    NSUInteger value = 0;
//    for (int i = 0; i < 11; i++) {
//        if (BTCMnemonicIsBitSet(buf, bitIndex + i)) {
//            value = (value << 1) | 0x01;
//        } else {
//            value = (value << 1);
//        }
//    }
//    return value;
//}
//BOOL BTCMnemonicIsBitSet(uint8_t* buf, int bitIndex) {
//    int val = ((int) buf[bitIndex / 8]) & 0xFF;
//    val = val << (bitIndex % 8);
//    val = val & 0x80;
//    return val == 0x80;
//}
@end

