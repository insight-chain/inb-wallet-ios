//
//  NSDate+DateString.h
//  test
//
//  Created by insightChain_iOS开发 on 2019/6/10.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (DateString)

/** 时间戳转换成指定格式的字符串 **/
+(NSString *)timestampSwitchTime:(double)time formatter:(NSString *)formatter;
/** 指定格式的时间字符串转成时间戳 **/
+(double)timeSwitchTimestamp:(NSString *)timestamp formatter:(NSString *)formatter;
+(NSDate *)dateSwitchTimeStamp:(NSString *)timestamp formatter:(NSString *)formatter;
@end

NS_ASSUME_NONNULL_END
