//
//  NSString+Extension.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/6/3.
//  Copyright © 2019 apple. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

-(instancetype)add0xIfNeeded{
    if ([self hasPrefix:@"0x"]) {
        return self;
    }else{
        return [NSString stringWithFormat:@"0x%@",self];
    }
}

//字符串自动补充
+ (NSString*)CharacterStringMainString:(NSString*)MainString AddDigit:(int)AddDigit AddString:(NSString*)AddString
{
    if(MainString.length >= AddDigit){
        return [MainString substringWithRange:NSMakeRange(0, AddDigit)];
    }
    NSString *ret = [[NSString alloc] init];
    ret = MainString;
    for(int y =0; y < (AddDigit - MainString.length);y++ ){
        ret = [NSString stringWithFormat:@"%@%@",ret,AddString];
    }
    return ret;
}

@end
