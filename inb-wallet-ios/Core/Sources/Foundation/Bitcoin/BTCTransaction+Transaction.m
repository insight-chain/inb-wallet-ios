//
//  BTCTransaction+Transaction.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/6/29.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "BTCTransaction+Transaction.h"
#import "BTCTransactionSigner.h"

#import "NSData+HexString.h"

@implementation BTCTransaction (Transaction)
-(void)addInputsFrom:(NSArray<UTXO *> *)utxos{
    [self addInputsFrom:utxos isSegWit:NO];
}
-(void)addInputsFrom:(NSArray<UTXO *> *)utxos isSegWit:(BOOL)isSegWit{
    for (UTXO *utxo in utxos) {
        BTCTransactionInput *input;
        if (isSegWit) {
            input = [[SegWitInput alloc] init];
        }else{
            input = [[BTCTransactionInput alloc] init];
        }
        
        input.previousHash = BTCReversedData(BTCDataFromHex(utxo.txHash));
        input.previousIndex = (UInt32)utxo.vout;
        input.signatureScript = [[BTCScript alloc] initWithHex:utxo.scriptPubKey];
        input.sequence = utxo.sequence;
        input.value = utxo.amount;
        [self addInput:input];
    }
}

-(void)signWithPrivateKey:(NSArray<BTCKey *> *)privateKeys isSegWit:(BOOL)isSegWit{
    [self.inputs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BTCTransactionInput *input = (BTCTransactionInput *)obj;
        BTCKey *key = privateKeys[idx];
        if (isSegWit) {
            BTCScript *scriptCode = [[BTCScript alloc] initWithHex:[NSString stringWithFormat:@"1976a914%@88ac", [BTCHash160(key.publicKey) dataToHexString]]];
            NSError *error;
            NSData *signHash = [self signatureHashForScript:scriptCode forSegWit:isSegWit inputIndex:(UInt32)idx hashType:BTCSignatureHashTypeAll error:&error];
            NSData *signature = [key signatureForHash:signHash hashType:BTCSignatureHashTypeAll];
            input.signatureScript = [[[BTCScript alloc] init] appendScript:key.witnessRedeemScript];
        }else{
            NSData *sigHash = [self signatureHashForScript:input.signatureScript forSegWit:isSegWit inputIndex:(UInt32)idx hashType:BTCSignatureHashTypeAll error:nil];
            NSData *signature = [key signatureForHash:sigHash hashType:BTCSignatureHashTypeAll];
            input.signatureScript = [[[[BTCScript alloc] init] appendData:signature] appendData:key.publicKey];
        }
    }];
}

-(SInt64) calculateTotalSpend:(NSArray<UTXO *> *)utxos{
    SInt64 sum = 0;
    for (UTXO *utxo in utxos) {
        sum += utxo.amount;
    }
    return sum;
}
@end


#pragma mark ---- SegWitInput
@implementation SegWitInput 

-(NSData *)data{
    NSMutableData *payload = [NSMutableData data];
    [payload appendData:self.previousHash];
    uint32_t ss = self.previousIndex;
    [payload appendBytes:&ss length:4];
    
    if (self.isCoinbase) {
        
        [payload appendData:[BTCProtocolSerialization dataForVarInt:(UInt64)self.coinbaseData.length]];
        [payload appendData:self.coinbaseData];
    }else{
        [payload appendData:[BTCProtocolSerialization dataForVarInt:23]];
        [payload appendData:[BTCProtocolSerialization dataForVarInt:22]];
        [payload appendData:self.signatureScript.data];
    }
    uint32_t aa = self.sequence;
    [payload appendBytes:&aa length:4];
    return payload;
    
}

@end
