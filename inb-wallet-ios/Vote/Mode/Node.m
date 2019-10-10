//
//  Node.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/6/18.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "Node.h"
#import "CountryCodeView.h"

@implementation Node
MJExtensionCodingImplementation

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id",
             @"countryCode":@"country",
             };
}

-(NSString *)countryName{
    NSArray *arr = [CountryCodeView countryList];
    for (NSDictionary *dic in arr) {
        NSArray *allKey = [dic allKeys];
        for (NSString *key in allKey) {
            if ([key isEqualToString:self.countryCode]) {
                return dic[key];
            }
        }
    }
    return @"其他";
}
@end
