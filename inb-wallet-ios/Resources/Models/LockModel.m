//
//  LockModel.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/9/11.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "LockModel.h"



@implementation LockModel
MJExtensionCodingImplementation


+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id",
             @"hashStr":@"hash",
             };
}

-(NSInteger)days{
    double dd = self.lockHeight*1.0 / kDayNumbers;
    if(dd > 0){
        return ceil(dd); //向上取整
    }else{
        return 0;
    }
}

@end
