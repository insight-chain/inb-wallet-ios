//
//  NSDictionary+JSON.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/10/21.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "NSDictionary+JSON.h"

@implementation NSDictionary (JSON)
-(NSString *)toJSONString{
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONReadingMutableLeaves|NSJSONReadingAllowFragments error:nil];
    if (data == nil) {
        return nil;
    }
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}
-(NSString *)toReadableJSONString{
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    if (data == nil) {
        return nil;
    }
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}
-(NSData *)toJSONData{
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    return data;
}
@end
