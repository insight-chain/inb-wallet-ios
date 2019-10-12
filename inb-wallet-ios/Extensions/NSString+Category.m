//
//  NSString+Category.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/6/26.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString (Category)

//给16进制字符串添加0x
-(instancetype)add0xIfNeeded{
    if ([self hasPrefix:@"0x"]) {
        return self;
    }else{
        return [NSString stringWithFormat:@"0x%@",self];
    }
}
-(instancetype)remove0x{
    if ([self hasPrefix:@"0x"]) {
        return [self substringFromIndex:2];
    }else{
        return self;
    }
}



// 十六进制转换为普通字符串的。
-(NSString *)stringFromHexString{
    
    char *myBuffer = (char *)malloc((int)[self length] / 2 + 1);
    bzero(myBuffer, [self length] / 2 + 1);
    for (int i = 0; i < [self length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [self substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:self];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    NSLog(@"------字符串=======%@",unicodeString);
    return unicodeString;
    
    
}
//普通字符串转换为十六进制的。
-(NSString *)hexString{
    NSData *myD = [self dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}

// 十六进制数字字符串转换为大数。
-(NSDecimalNumber *)decimalNumberFromHexString{ //
    NSString *hexString = [self remove0x];
    NSDecimalNumber *totalDecimalNumber = [NSDecimalNumber decimalNumberWithString:@"0"];
    int length = hexString.length;
    for (int i=length-1; i >= 0; i--) {
        NSString *str = [hexString substringWithRange:NSMakeRange(i, 1)];
        NSInteger v = (NSInteger)strtoul([str UTF8String], 0, 16);
        totalDecimalNumber = [totalDecimalNumber decimalNumberByAdding:[[[NSDecimalNumber alloc] initWithInt:v] decimalNumberByMultiplyingBy:[[NSDecimalNumber decimalNumberWithString:@"16"] decimalNumberByRaisingToPower:length-1-i]]];
    }
    return totalDecimalNumber;
}


//转化为千分位格式，
+(NSString*)changeNumberFormatter:(NSString*)str{
    NSString *numString = [NSString stringWithFormat:@"%@",str];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"###,##0.00###"];
    NSNumber *number = [formatter numberFromString:numString];
//    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    NSString *string = [formatter stringFromNumber:number];
    if (IsStrEmpty(string)) {
        return str;
    }
    return string;
}

@end
