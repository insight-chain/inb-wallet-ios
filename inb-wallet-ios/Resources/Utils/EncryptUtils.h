//  EncryptUtils.h
//  aimao
//
//  Created by 吉建勋 on 17-02-10.
//  Copyright (c) 2017年 矮猫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
//#import "ARSA.h"
#import "CocoaSecurity.h"


static NSString *public_key = @"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCT+KUq1Dg7BHEF18R2vaKeh9HoJIYzX1OWl1StaiEVrjA4cTHnZHWMf6sBZO9nR+qsNTOBU6qp1JU5m6OjtxWQ3ZiQUbCCdT/Y4PMQX60GMzHBe5wds5FiBisCpjsHB8uzwXg8pm9hHoBwuwMyAlX6922QuTnzWlmHwGpTrnaypwIDAQAB\n-----END PUBLIC KEY-----";



@interface EncryptUtils : NSObject {
    
}

//生成随机的16位的AES key
+(NSString *)generateRandomAESKey;

//HmacSHA1加密
+(NSString *)hash:(NSString *)data key:(NSString *)key;

//AES加密，返回加密以后的bytes的base64
+(NSString *)encryptByAES:(NSString *)data key:(NSString *)key;

//AES解密，输入为加密以后的bytes的base64
+(NSString *)decryptByAES:(NSString *)data key:(NSString *)key;


+(NSString *)encryptByRSA:(NSString *)data;

+(NSString *)sign:(NSString *)key data:(NSString *)data;

//创建网络请求的签名
+(NSString*) sign:(NSString *)key parameters:(NSDictionary*)parameters;

@end
