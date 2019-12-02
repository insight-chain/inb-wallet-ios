//  EncryptUtils.m
//  aimao
//
//  Created by 吉建勋 on 17-02-10.
//  Copyright (c) 2017年 矮猫. All rights reserved.
//


#import "EncryptUtils.h"

@implementation EncryptUtils

static EncryptUtils *global;
+(NSString *)stringWithUUID{
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);//create a new UUID
    //get the string representation of the UUID
    NSString    *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    NSMutableString * uuid = [NSMutableString stringWithString:uuidString];
    for (int i = 0; i < uuid.length; i++) {
        unichar c = [uuid characterAtIndex:i];
        NSRange range = NSMakeRange(i, 1);
        if (c == '-' ) {
            [uuid deleteCharactersInRange:range];
            --i;
        }
    }
    uuidString = [NSString stringWithString:uuid];
    return uuidString;
}
+(NSString *)generateRandomAESKey
{
    return [[EncryptUtils stringWithUUID] substringToIndex:16];
}

+(NSString *)hash:(NSString *)data key:(NSString *)key
{
    if(data == nil || key == nil){
        return nil;
    }
    CocoaSecurityResult *encrypt = [CocoaSecurity hmacSha1:data hmacKey:key];
    return encrypt.hex;
}

+(NSString *)encryptByAES:(NSString *)data key:(NSString *)key   //加密
{
    if(data == nil || key == nil){
        return nil;
    }
    //CocoaSecurityResult *encrypt = [CocoaSecurity aesEncrypt:data key:key];
    CocoaSecurityResult *encrypt = [CocoaSecurity aesEncrypt:data key:[key dataUsingEncoding:NSUTF8StringEncoding] iv:[iv dataUsingEncoding:NSUTF8StringEncoding]];
    return encrypt.base64;
}

+(NSString *)decryptByAES:(NSString *)data key:(NSString *)key   //解密
{
    if(data == nil || key == nil){
        return nil;
    }
    //CocoaSecurityResult *decrypt = [CocoaSecurity aesDecryptWithBase64:data key:key];
    CocoaSecurityResult *decrypt = [CocoaSecurity aesDecryptWithBase64:data key:[key dataUsingEncoding:NSUTF8StringEncoding] iv:[iv dataUsingEncoding:NSUTF8StringEncoding]];

    return decrypt.utf8String;
}

//+(NSString *)encryptByRSA:(NSString *)data
//{
//    if(data == nil){
//        return nil;
//    }
//    return [ARSA encryptString:data publicKey:public_key];
//}

+(NSString*)sign:(NSString *)key data:(NSString *)data
{
    if(data == nil || key == nil){
        return nil;
    }
    return [EncryptUtils encryptByRSA:[EncryptUtils hash:data key:key]];
}

//创建网络请求的签名
+(NSString*)sign:(NSString *)key parameters:(NSDictionary*)parameters
{
    if (parameters == nil || parameters.count <= 0) {
        return nil;
    }
    NSMutableString *contentString  = [NSMutableString string];
    NSArray *keys = [parameters allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *parameter in sortedArray) {
        NSObject *value = [parameters objectForKey:parameter];
        if (value && ![parameter isEqualToString:@"s"])
        {
            [contentString appendFormat:@"%@=%@", parameter, value];
        }
        
    }
    NSString *sign = [EncryptUtils sign:key data:contentString];
    
    return sign;
}


@end
