//
//  NSString+Extension.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/6/3.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Extension)

-(instancetype)add0xIfNeeded;

//字符串自动补充或截取指定长度
+ (NSString*)CharacterStringMainString:(NSString*)MainString AddDigit:(int)AddDigit AddString:(NSString*)AddString;
@end

NS_ASSUME_NONNULL_END
