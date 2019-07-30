//
//  NSData+HexString.m
//  wallet
//
//  Created by apple on 2019/3/25.
//  Copyright © 2019 apple. All rights reserved.
//

#import "NSData+HexString.h"

@implementation NSData (HexString)
-(NSString *)dataToHexString{
    if(!self || [self length] == 0){
        return @"";
    }
    NSMutableString *hexString = [[NSMutableString alloc] init];
   
    [self enumerateByteRangesUsingBlock:^(const void * _Nonnull bytes, NSRange byteRange, BOOL * _Nonnull stop) {
        unsigned char *dataBytes = (unsigned char *)bytes;
        for (NSInteger i=0; i<byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%02x",(dataBytes[i])&0xff];
            [hexString appendString:hexStr];
        }
    }];
    return hexString;
}
+(NSData *)hexStringToData:(NSString *)hexString{
    if (!hexString || [hexString length] == 0) {
        return nil;
    }
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([hexString length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [hexString length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [hexString substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    
    return hexData;
    
//    const char* chars = [hexString UTF8String];
//    int i=0;
//    int len = (int)hexString.length;
//    NSMutableData *data = [NSMutableData dataWithCapacity:len/2];
//    char byteChars[3] = {('\0'), '\0', '\0'};
//    unsigned long wholeByte;
//    
//    while (i<len) {
//        byteChars[0] = chars[i++];
//        byteChars[1] = chars[i++];
//        wholeByte = strtoul(byteChars, NULL, 16);
//        [data appendBytes:&wholeByte length:1];
//    }
//    return data;
}

+(NSData *)random:(int)length{
//    void * bytes = NULL;
//    uint8_t bytes[length];
//    SecRandomCopyBytes(kSecRandomDefault, length, bytes);
//    NSData *data = [NSData dataWithBytes:bytes length:length];
//    return data;
    
    NSMutableData *da = [NSMutableData dataWithLength:length];
    [da enumerateByteRangesUsingBlock:^(const void * _Nonnull bytes, NSRange byteRange, BOOL * _Nonnull stop) {
        SecRandomCopyBytes(kSecRandomDefault, byteRange.length, bytes);
    }];
    return da;
}

@end
