//
//  NSDate+DateString.m
//  test
//
//  Created by insightChain_iOS开发 on 2019/6/10.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "NSDate+DateString.h"

@implementation NSDate (DateString)
/** 时间戳转换成指定格式的字符串 **/
+(NSString *)timestampSwitchTime:(double)time formatter:(NSString *)formatter{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:formatter];// （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
//    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    NSDate *conformTimesp = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *conform = [format stringFromDate:conformTimesp];
    return conform;
}
/** 指定格式的时间字符串转成时间戳 **/
+(double)timeSwitchTimestamp:(NSString *)timestamp formatter:(NSString *)formatter{
    NSDate *date = [self dateSwitchTimeStamp:timestamp formatter:formatter];
    //时间转时间戳的方法:
    return (double)[date timeIntervalSince1970];
}
+(NSDate *)dateSwitchTimeStamp:(NSString *)timestamp formatter:(NSString *)formatter{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:formatter];
    
    NSDate* date = [format dateFromString:timestamp];//------------将字符串按formatter转成nsdate
    return date;
}

/** 某日期和当前日志相隔多少天 **/
+(NSInteger)getDifferenceByDate:(NSTimeInterval)date{
    //获得当前时间
    
    //    NSDate *now = [NSDate date];
    //    //实例化一个NSDateFormatter对象
    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //    //设定时间格式
    //    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    //    NSDate *oldDate = [dateFormatter dateFromString:date];
    //    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //    unsigned int unitFlags = NSDayCalendarUnit;
    //    NSDateComponents *comps = [gregorian components:unitFlags fromDate:oldDate  toDate:now  options:0];
    //    return [comps day];
    //
    
    //下面这种方法从00:00:00开始计算
    
#pragma clang diagnostic push
    
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setFirstWeekday:2];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    
    NSDate *fromDate;
    NSDate *toDate;
    NSCalendarUnit unit = NSCalendarUnitDay|NSCalendarUnitHour;
    
    [gregorian rangeOfUnit:unit startDate:&fromDate interval:NULL forDate:[NSDate dateWithTimeIntervalSince1970:date]]; //[dateFormatter dateFromString:date]
    [gregorian rangeOfUnit:unit startDate:&toDate interval:NULL forDate:[NSDate date]];
    
    NSDateComponents *dayComponents = [gregorian components:unit fromDate:fromDate toDate:toDate options:0];
    
#pragma clang diagnostic pop
    return [dayComponents day];
}

@end
