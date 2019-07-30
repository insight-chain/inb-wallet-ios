//
//  NSString+Category.h
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/6/26.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Category)

-(instancetype)add0xIfNeeded;
-(instancetype)remove0x;

-(NSString *)stringFromHexString;
-(NSString *)hexString;

-(NSDecimalNumber *)decimalNumberFromHexString;
//转化为千分位格式
+(NSString*)changeNumberFormatter:(NSString*)str;
@end

NS_ASSUME_NONNULL_END
