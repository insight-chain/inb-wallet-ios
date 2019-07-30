//
//  BTCTransactionSigner.h
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/6/29.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransactionSignedResult.h"

NS_ASSUME_NONNULL_BEGIN
@class UTXO;

@interface BTCTransactionSigner : NSObject

@property(nonatomic, strong) NSArray<UTXO *>   *utxos;
@property(nonatomic, strong) NSArray<BTCKey *> *keys;
@property(nonatomic, assign) SInt64 amount;
@property(nonatomic, assign) SInt64 fee;
@property(nonatomic, strong) BTCAddress *toAddress;
@property(nonatomic, strong) BTCAddress *changeAddress;
@property(nonatomic, assign) SInt64 dustThreshould; //默认值2730

-(instancetype)initWith:(NSArray *)utxos keys:(NSArray *)keys amount:(SInt64)amount fee:(SInt64)fee toAddress:(BTCAddress *)toAddress changeAddress:(BTCAddress *)changeAddress;
-(TransactionSignedResult *)sign;
-(TransactionSignedResult *)signSegWit;

@end


#pragma mark UTXO
@interface UTXO : NSObject
@property(nonatomic, strong) NSString *txHash;
@property(nonatomic, assign) int vout;
@property(nonatomic, assign) SInt64 amount;
@property(nonatomic, strong) NSString *address;
@property(nonatomic, strong) NSString *scriptPubKey;
@property(nonatomic, strong) NSString *derivedPath;
@property(nonatomic, assign) UInt32 sequence;

-(instancetype)initWith:(NSString *)txHash vout:(int)vout amount:(SInt64)amount address:(NSString *)address scriptPubKey:(NSString *)scriptPubKey derivedPath:(NSString *)derivedPath;
-(instancetype)initWith:(NSString *)txHash vout:(int)vout amount:(SInt64)amount address:(NSString *)address scriptPubKey:(NSString *)scriptPubKey derivedPath:(NSString *)derivedPath sequence:(UInt32) sequence;
-(instancetype)initWithRaw:(NSDictionary *)raw;

+(UTXO *)parseFormBlockchain:(NSDictionary *)raw isTestNet:(BOOL)isTestNet isSegWit:(BOOL)isSegWit;

@end

NS_ASSUME_NONNULL_END
