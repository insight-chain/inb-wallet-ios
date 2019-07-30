//
//  BTCTransaction+Transaction.h
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/6/29.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "BTCTransaction.h"
@class UTXO, SegWitInput;
NS_ASSUME_NONNULL_BEGIN

@interface BTCTransaction (Transaction)

-(void)addInputsFrom:(NSArray<UTXO *> *)utxos;
-(void)addInputsFrom:(NSArray<UTXO *> *)utxos isSegWit:(BOOL)isSegWit;

-(void)signWithPrivateKey:(NSArray<BTCKey *> *)privateKeys isSegWit:(BOOL)isSegWit;

-(SInt64) calculateTotalSpend:(NSArray<UTXO *> *)utxos;

@end

#pragma mark ---- SegWitInput
@interface SegWitInput : BTCTransactionInput

@end

NS_ASSUME_NONNULL_END
