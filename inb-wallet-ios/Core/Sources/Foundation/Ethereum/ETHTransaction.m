//
//  ETHTransaction.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/6/3.
//  Copyright © 2019 apple. All rights reserved.
//

#import "ETHTransaction.h"
#import "rlp.h"
#import "Keccak256.h"
#import "Secp256k1_Insight.h"

#import "NSString+Extension.h"
#import "NSData+HexString.h"

#import "inb_wallet_ios-Swift.h"

@interface ETHTransaction()
@property(nonatomic, strong) NSDictionary *raw;
@property(nonatomic, assign) int chainID;
@property(nonatomic, assign) BOOL isSigned;
@end

@implementation ETHTransaction

-(instancetype)initWithRaw:(NSDictionary *)raw chainID:(int)chainID{
    if (self = [super init]) {
        self.raw = raw;
        self.chainID = chainID;
        
        //Make sure every property at least has empty string value
        _nonce = [ETHTransaction parseData:raw key:@"nonce"];
        _gasPrice = [ETHTransaction parseData:raw key:@"gasPrice"];
        _gasLimit = [ETHTransaction parseData:raw key:@"gasLimit"];
        _to = [ETHTransaction parseData:raw key:@"to"];
        _value = [ETHTransaction parseData:raw key:@"value"];
        _data = [ETHTransaction parseData:raw key:@"data"];
        _v = [ETHTransaction parseData:raw key:@"v"];
        _r = [ETHTransaction parseData:raw key:@"r"];
        _s = [ETHTransaction parseData:raw key:@"s"];
        
        if ([self.v isEqualToString:@""] && chainID > 0) {
            _v = [NSString stringWithFormat:@"%d", chainID];
            _r = @"0";
            _s = @"0";
        }
        
    }
    return self;
}

-(instancetype)initWithRaw:(NSDictionary *)raw{
    return [self initWithRaw:raw chainID:-4]; //-4 is to support old ecoding without chain id.
}

/// - Returns: Signed TX, always prefixed with 0x
-(NSString *)signedTx{
    NSString *str = [RLP encode:[self serialize]];
    return str; //[str add0xIfNeeded];
}
-(TransactionSignedResult *)signedResult{
    return [[TransactionSignedResult alloc] initWithSignedTx:self.signedTx txHash:self.signingHash];
}
-(NSString *)signingData{
    NSString *rlpStr = [RLP encode:[self serialize]];
    return rlpStr;
}
-(NSString *)signingHash{
    NSString *sss = [[[Keccak256_bridge alloc] init] encryptWithHex:self.signingData];
//    NSString *str = [[[Keccak256 alloc] init] encrypt:self.signingData];
    return [sss add0xIfNeeded];
}

/// Sign transaction with private key
/// - Parameters:
///     - privateKey: The private key from the keystore to sign the transaction.
/// - Returns: dictionary [v, r, s] (all as String)
-(NSDictionary *)signWithPrivateKey:(NSString *)privateKey{
    
    SignResult *resu = [[[Secp256k1_bridge alloc] init] signWithKey:privateKey message:self.signingHash];
    
    NSDictionary *result = [[[Secp256k1_Insight alloc] init] signWithKey:privateKey message:self.signingHash];
    self.v = [self encodeV:(int32_t)[result[@"recid"] intValue]];
    self.r = [result[@"signature"] substringToIndex:64];
    self.s = [result[@"signature"] substringFromIndex:64];
    
    return @{@"v": self.v,
             @"r": self.r,
             @"s": self.s,
             };
}

-(NSString *)encodeV:(int32_t) v{
    int32_t intValue = v + (int32_t)(self.chainID) * 2 + 35;
    return [NSString stringWithFormat:@"%d", intValue];
}

-(BOOL)isSigned{
    return !([self.v isEqualToString:@""] || [self.r isEqualToString:@""] || [self.s isEqualToString:@""]);
}

-(NSArray *)serialize{
    //TODO....
    NSMutableArray *base = [NSMutableArray arrayWithArray:@[[BigNumberTest parse:self.nonce padding:NO paddingLen:-1],
                      [BigNumberTest parse:self.gasPrice padding:NO paddingLen:-1],
                      [BigNumberTest parse:self.gasLimit padding:NO paddingLen:-1],
                      [BigNumberTest parse:self.to padding:YES paddingLen:-1],
                      [BigNumberTest parse:self.value padding:NO paddingLen:-1],
                      [BigNumberTest parse:self.data padding:YES paddingLen:-1]]];
    if (self.isSigned) {
        [base addObject:[BigNumberTest parse:self.v padding:NO paddingLen:-1]];
        [base addObject:[BigNumberTest parse:self.r padding:NO paddingLen:-1]];
        [base addObject:[BigNumberTest parse:self.s padding:NO paddingLen:-1]];
        return base;
    }else{
        return base;
    }
}

/*** 抵押 ***/
-(instancetype)initWithMortgageRaw:(NSDictionary *)raw chainID:(int)chainID{
    if (self = [super init]) {
        self.raw = raw;
        self.chainID = chainID;
        
        //Make sure every property at least has empty string value
        _from = [ETHTransaction parseData:raw key:@"from"];
        _to = [ETHTransaction parseData:raw key:@"to"];
        _value = [ETHTransaction parseData:raw key:@"value"];
        _data = [ETHTransaction parseData:raw key:@"data"];
        _v = [ETHTransaction parseData:raw key:@"v"];
        _r = [ETHTransaction parseData:raw key:@"r"];
        _s = [ETHTransaction parseData:raw key:@"s"];
        
        if ([self.v isEqualToString:@""] && chainID > 0) {
            _v = [NSString stringWithFormat:@"%d", chainID];
            _r = @"0";
            _s = @"0";
        }
    }
    return self;
}
-(NSString *)signedMortgageTx{
    NSString *str = [RLP encode:[self serializeMortgage]];
    return str; //[str add0xIfNeeded];
}
-(NSString *)signingMortgageData{
    NSString *rlpStr = [RLP encode:[self serializeMortgage]];
    return rlpStr;
}
-(NSString *)signingMortgageHash{
    NSString *sss = [[[Keccak256_bridge alloc] init] encryptWithHex:self.signingMortgageData];
    //    NSString *str = [[[Keccak256 alloc] init] encrypt:self.signingData];
    return [sss add0xIfNeeded];
}

-(TransactionSignedResult *)signedMortgageResult{
    return [[TransactionSignedResult alloc] initWithSignedTx:self.signedMortgageTx txHash:self.signingMortgageHash];
}

-(NSDictionary *)signMortgageWithPrivateKey:(NSString *)privateKey{
    SignResult *resu = [[[Secp256k1_bridge alloc] init] signWithKey:privateKey message:self.signingMortgageHash];
    NSDictionary *result = [[[Secp256k1_Insight alloc] init] signWithKey:privateKey message:self.signingHash];
    self.v = [self encodeV:(int32_t)[result[@"recid"] intValue]];
    self.r = [result[@"signature"] substringToIndex:64];
    self.s = [result[@"signature"] substringFromIndex:64];
    
    return @{@"v": self.v,
             @"r": self.r,
             @"s": self.s,
             };
}

-(NSArray *)serializeMortgage{
    NSMutableArray *base = [NSMutableArray arrayWithArray:@[[BigNumberTest parse:self.from padding:NO paddingLen:-1],
                                                            [BigNumberTest parse:self.to padding:NO paddingLen:-1],
                                                            [BigNumberTest parse:self.value padding:NO paddingLen:-1],
                                                            [BigNumberTest parse:self.data padding:NO paddingLen:-1],
                                                            ]];
    if (self.isSigned) {
        [base addObject:[BigNumberTest parse:self.v padding:NO paddingLen:-1]];
        [base addObject:[BigNumberTest parse:self.r padding:NO paddingLen:-1]];
        [base addObject:[BigNumberTest parse:self.s padding:NO paddingLen:-1]];
        return base;
    }else{
        return base;
    }
}

+(NSString *)parseData:(NSDictionary *)data key:(NSString *)key{
    return data[key] ? data[key] : @"";
}

@end
