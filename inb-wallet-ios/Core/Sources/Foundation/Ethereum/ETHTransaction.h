//
//  ETHTransaction.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/6/3.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransactionSignedResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface ETHTransaction : NSObject
@property(nonatomic, strong, readonly) NSString *nonce;
@property(nonatomic, strong, readonly) NSString *gasPrice;
@property(nonatomic, strong, readonly) NSString *gasLimit;
@property(nonatomic, strong, readonly) NSString *to;
@property(nonatomic, strong, readonly) NSString *value;
@property(nonatomic, strong, readonly) NSString *data;
@property(nonatomic, strong, readonly) NSString *txType;

@property(nonatomic, strong, readonly) NSString *from; //抵押专用
@property(nonatomic, strong) NSString *signedMortgageTx;
@property(nonatomic, strong) NSString *signingMortgageData;
@property(nonatomic, strong) NSString *signingMortgageHash;
@property(nonatomic, strong) TransactionSignedResult *signedMortgageResult;

@property(nonatomic, strong) NSString *v;
@property(nonatomic, strong) NSString *r;
@property(nonatomic, strong) NSString *s;

@property(nonatomic, strong) NSString *signedTx;
@property(nonatomic, strong) TransactionSignedResult *signedResult;
@property(nonatomic, strong) NSString *signingData;
@property(nonatomic, strong) NSString *signingHash;



/**
 * 使用 raw 数据构造 transaction
 * @param chainID Chain ID, 1 by default after [EIP 155](https://github.com/ethereum/EIPs/issues/155) fork.
 */
-(instancetype)initWithRaw:(NSDictionary *)raw chainID:(int)chainID;
-(instancetype)initWithRaw:(NSDictionary *)raw;


-(NSDictionary *)signWithPrivateKey:(NSString *)privateKey;

-(NSArray *)serialize;

/** 抵押 **/
-(instancetype)initWithMortgageRaw:(NSDictionary *)raw chainID:(int)chainID;
-(NSDictionary *)signMortgageWithPrivateKey:(NSString *)privateKey;
-(NSArray *)serializeMortgage;


+(NSString *)parseData:(NSDictionary *)data key:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
