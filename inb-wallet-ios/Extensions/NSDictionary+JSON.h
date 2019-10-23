//
//  NSDictionary+JSON.h
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/10/21.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (JSON)
/**
 *  转换成JSON串字符串（没有可读性）
 *
 *  @return JSON字符串
 */
- (NSString *)toJSONString;
 
/**
 *  转换成JSON串字符串（有可读性）
 *
 *  @return JSON字符串
 */
- (NSString *)toReadableJSONString;
 
/**
 *  转换成JSON数据
 *
 *  @return JSON数据
 */
- (NSData *)toJSONData;
@end

NS_ASSUME_NONNULL_END
