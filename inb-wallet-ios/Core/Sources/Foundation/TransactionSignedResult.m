//
//  TransactionSignedResult.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/6/3.
//  Copyright © 2019 apple. All rights reserved.
//

#import "TransactionSignedResult.h"

@implementation TransactionSignedResult
-(instancetype)initWithSignedTx:(NSString *)signedTx txHash:(NSString *)txHash wtxID:(NSString *)wtxID{
    if (self = [super init]) {
        _signedTx = signedTx;
        _txHash = txHash;
        _wtxID = wtxID;
    }
    return self;
}
-(instancetype)initWithSignedTx:(NSString *)signedTx txHash:(NSString *)txHash{
    return [self initWithSignedTx:signedTx txHash:txHash wtxID:@""];
}
@end
