//
//  AES128.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/21.
//  Copyright © 2019 apple. All rights reserved.
//

#import "AES128.h"
#import "NSData+HexString.h"

#import "CocoaSecurity.h"
@interface AES128()
@property(nonatomic, strong) NSString *key;
@property(nonatomic, strong) NSString *iv;
@property(nonatomic, assign) Mode mode;
@property(nonatomic, assign) CCPadding padding; //填充方式
 
@end

@implementation AES128

-(instancetype)initWithKey:(NSString *)key iv:(NSString *)iv mode:(Mode)mode padding:(CCPadding)padding{
    if (self = [super init]) {
        self.key = key;
        self.iv = iv;
        if (mode) {
            self.mode = mode;
        }else{
            self.mode = Mode_ctr;
        }
        if (padding) {
            self.padding = padding;
        }else{
            self.padding = ccNoPadding;
        }
        
    }
    return self;
}

-(NSString *)encrypt:(NSString *)string{
    NSString *hex = [[string dataUsingEncoding:NSUTF8StringEncoding] dataToHexString];
    return [self encryptHexString:hex];
}
-(NSString *)encryptHexString:(NSString *)hex{
    
    NSData *hexData = [hex dataUsingEncoding:NSUTF8StringEncoding];
    
//    CocoaSecurityResult *result = [CocoaSecurity aesEncrypt:hex hexKey:self.key hexIv:self.iv];
//    return result.hex;
    NSData *keyData = [NSData hexStringToData:self.key];
    NSData *ivData = [NSData hexStringToData:self.iv];
    NSData *encryptData = [self aesEncryptWithData:hexData andKey:keyData iv:ivData];
    
    return [encryptData dataToHexString];
}

-(NSString *)decrypt:(NSString *)hex{
    NSData *inputData = [NSData hexStringToData:hex];
    NSData *keyData = [NSData hexStringToData:self.key];
    NSData *ivData = [NSData hexStringToData:self.iv];
    NSData *decryptData = [self aesDecryptWithData:inputData andKey:keyData iv:ivData];

    return [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];//[decryptData dataToHexString];
//    CocoaSecurityResult *result = [CocoaSecurity aesDecryptWithBase64:hex hexKey:self.key hexIv:self.iv];
//    return result.hex;
}

/**
 *MARK:key
 *OC中的AES加密是通过key的bytes数组位数来进行AES128/192/256加密
 * key -> 加密方式
 * 16  -> AES128
 * 24  -> AES192
 * 32  -> AES256
 * iv:偏移量，加密过程中会按照偏移量进行循环位移
 */
- (NSData *)aesEncryptWithData:(NSData *)enData andKey:(NSData *)key iv:(NSData *)iv {
    if (key.length != 16 && key.length != 24 && key.length != 32) {
        return nil;
    }
    if (iv.length != 16 && iv.length != 0) {
        return nil;
    }
    
    NSData *result = nil;
    size_t bufferSize = enData.length + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    if (!buffer) return nil;
    size_t encryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,//填充方式
                                          key.bytes,
                                          key.length,
                                          iv.bytes,
                                          enData.bytes,
                                          enData.length,
                                          buffer,
                                          bufferSize,
                                          &encryptedSize);
    if (cryptStatus == kCCSuccess) {
        result = [[NSData alloc]initWithBytes:buffer length:encryptedSize];
        free(buffer);
        return result;
    } else {
        free(buffer);
        return nil;
    }
}
- (NSData *)aesDecryptWithData:(NSData *)deData andKey:(NSData *)key iv:(NSData *)iv {
    if (key.length != 16 && key.length != 24 && key.length != 32) {
        return nil;
    }
    if (iv.length != 16 && iv.length != 0) {
        return nil;
    }
    
    NSData *result = nil;
    size_t bufferSize = deData.length + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    if (!buffer) return nil;
    size_t encryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,//填充方式
                                          key.bytes,
                                          key.length,
                                          iv.bytes,
                                          deData.bytes,
                                          deData.length,
                                          buffer,
                                          bufferSize,
                                          &encryptedSize);
    if (cryptStatus == kCCSuccess) {
        result = [[NSData alloc]initWithBytes:buffer length:encryptedSize];
        free(buffer);
        return result;
    } else {
        free(buffer);
        return nil;
    }
}

@end
