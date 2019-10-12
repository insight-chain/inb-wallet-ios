//
//  TransferModel.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/7/8.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "TransferModel.h"
@implementation TransferModel
MJExtensionCodingImplementation

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"tradingHash":@"hash"};
}
+(NSDictionary *)mj_objectClassInArray{
    return @{@"transactionLog":@"InlineTransfer"};
}

-(NSDecimalNumber *)lockNumber{
    if([self.input hasPrefix:@"days:"]){
        NSString *lockNum = [self.input substringFromIndex:[self.input rangeOfString:@"days:"].length];
        return [NSDecimalNumber decimalNumberWithString:lockNum];
    }else{
        return [NSDecimalNumber decimalNumberWithString:@"0"];
    }
}
-(NSInteger)lockDays{
    double dd = [self.lockNumber doubleValue] / kDayNumbers;
    if(dd > 0){
        return ceil(dd); //向上取整
    }else{
        return 0;
    }
}
-(double)lockRate{
    switch (self.lockDays) {
        case 30:
            return kRateReturn7_30;
        case 90:
            return kRateReturn7_90;
        case 180:
            return kRateReturn7_180;
        case 360:
            return kRateReturn7_360;
        default:
            return 0;
            break;
    }
}

@end

#pragma mark ---- 内联交易
@implementation InlineTransfer
MJExtensionCodingImplementation
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}
@end
