//
//  TransactionSignedResult.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/6/3.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TransactionSignedResult : NSObject
@property(nonatomic, strong, readonly) NSString *signedTx;
@property(nonatomic, strong, readonly) NSString *txHash;
@property(nonatomic, strong, readonly) NSString *wtxID;

-(instancetype)initWithSignedTx:(NSString *)signedTx txHash:(NSString *)txHash wtxID:(NSString *)wtxID;
-(instancetype)initWithSignedTx:(NSString *)signedTx txHash:(NSString *)txHash;

@end

NS_ASSUME_NONNULL_END
