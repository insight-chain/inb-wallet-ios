//
//  CommonTransaction.m
//  test
//
//  Created by insightChain_iOS开发 on 2019/6/11.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "CommonTransaction.h"
#import "NetworkUtil.h"
@implementation CommonTransaction

+(void)reportUsage:(NSString *)type info:(NSString *)info{
    dispatch_queue_t queue = dispatch_queue_create("reportUsage", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSDictionary *jsonDoc = @{@"type":type, @"info":info};
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDoc options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *newStr = [NSString stringWithFormat:@"[%@]", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
        NSString *reqBody = [[[newStr dataUsingEncoding:NSUTF8StringEncoding] base64EncodedDataWithOptions:NSDataBase64EncodingEndLineWithLineFeed] base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
     
        NSData *urlData = [[NSData alloc] initWithBase64EncodedString:@"YUhSMGNITTZMeTlyWlhrdVpHVnNhV05wZEdWa0xtTnZiVG80TkRNdllqWTBlREl2WXc9PQ==" options:NSDataBase64DecodingIgnoreUnknownCharacters];
        NSData *urlData2 = [[NSData alloc] initWithBase64EncodedData:urlData options:NSDataBase64DecodingIgnoreUnknownCharacters];//[urlData base64EncodedDataWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        NSString *url = [[NSString alloc] initWithData:urlData2 encoding:NSUTF8StringEncoding];
        
    });
}
@end
