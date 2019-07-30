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
@end
