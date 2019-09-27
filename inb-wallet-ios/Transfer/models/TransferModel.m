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

@end
