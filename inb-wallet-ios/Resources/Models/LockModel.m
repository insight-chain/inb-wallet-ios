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
    return self.lockHeight*2/(24*60*60);
}

@end
