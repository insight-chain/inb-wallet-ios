//
//  BTCTransactionSigner.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/6/29.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "BTCTransactionSigner.h"
#import "BTCTransaction+Transaction.h"

@implementation BTCTransactionSigner

-(instancetype)initWith:(NSArray *)utxos keys:(NSArray *)keys amount:(SInt64)amount fee:(SInt64)fee toAddress:(BTCAddress *)toAddress changeAddress:(BTCAddress *)changeAddress{
    if(self = [super init]){
        if (amount < self.dustThreshould) {
            @throw [NSException exceptionWithName:@"GenericError" reason:@"amountLessThanMinimum" userInfo:nil];
        }
        self.utxos = utxos;
        self.keys  = keys;
        self.amount = amount;
        self.fee = fee;
        self.toAddress = toAddress;
        self.changeAddress = changeAddress;
    }
    return self;
}

-(TransactionSignedResult *)sign{
    BTCTransaction *rawTx = [[BTCTransaction alloc] init];
    SInt64 totalAmount = [rawTx calculateTotalSpend:self.utxos];
    if (totalAmount < self.amount) {
        @throw [NSException exceptionWithName:@"GenericError" reason:@"insufficientFunds" userInfo:nil];
    }
    [rawTx addInputsFrom:self.utxos];
    [rawTx addOutput:[[BTCTransactionOutput alloc] initWithValue:self.amount address:self.toAddress]];
    
    SInt64 changeAmount = totalAmount - self.amount - self.fee;
    if (changeAmount >= self.dustThreshould) {
        [rawTx addOutput:[[BTCTransactionOutput alloc] initWithValue:changeAmount address:self.changeAddress]];
    }
    [rawTx signWithPrivateKey:self.keys isSegWit:NO];
    
    NSString *signedTx = rawTx.hex;
    NSString *txHash = rawTx.transactionID;
    return [[TransactionSignedResult alloc] initWithSignedTx:signedTx txHash:txHash];
}
-(TransactionSignedResult *)signSegWit{
    BTCTransaction *rawTx = [[BTCTransaction alloc] init];
    rawTx.version = 2;
    
    SInt64 totalAmount = [rawTx calculateTotalSpend:self.utxos];
    if (totalAmount < self.amount) {
        @throw [NSException exceptionWithName:@"GenericError" reason:@"insufficientFunds" userInfo:nil];
    }
    [rawTx addInputsFrom:self.utxos isSegWit:YES];
    
    [rawTx addOutput:[[BTCTransactionOutput alloc] initWithValue:self.amount address:self.toAddress]];
    
    SInt64 changeAmount = totalAmount - self.amount - self.fee;
    if (changeAmount >= self.dustThreshould) {
        [rawTx addOutput:[[BTCTransactionOutput alloc] initWithValue:changeAmount address:self.changeAddress]];
    }
    [rawTx signWithPrivateKey:self.keys isSegWit:YES];
    
    NSString *signedTx = rawTx.hexWithWitness;
    NSString *txHash = rawTx.transactionID;
    NSString *wtxID = rawTx.witnessTransactionID;
    
    return [[TransactionSignedResult alloc] initWithSignedTx:signedTx txHash:txHash wtxID:wtxID];
}
-(SInt64)dustThreshould{
    return 2730;
}

@end


#pragma mark UTXO
@implementation UTXO

-(instancetype)initWith:(NSString *)txHash vout:(int)vout amount:(SInt64)amount address:(NSString *)address scriptPubKey:(NSString *)scriptPubKey derivedPath:(NSString *)derivedPath{
    return [self initWith:txHash vout:vout amount:amount address:address scriptPubKey:scriptPubKey derivedPath:derivedPath sequence:4294967295];
}
-(instancetype)initWith:(NSString *)txHash vout:(int)vout amount:(SInt64)amount address:(NSString *)address scriptPubKey:(NSString *)scriptPubKey derivedPath:(NSString *)derivedPath sequence:(UInt32) sequence{
    if (self = [super init]) {
        self.txHash = txHash;
        self.vout = vout;
        self.amount = amount;
        self.address = address;
        self.scriptPubKey = scriptPubKey;
        self.derivedPath = derivedPath;
        self.sequence = sequence;
    }
    return self;
}
-(instancetype)initWithRaw:(NSDictionary *)raw{
    @try {
        NSString *txHash = raw[@"txHash"];
        int vout = (int)raw[@"vout"];
        SInt64 amount = (SInt64)(raw[@"amount"]);
        NSString *address = raw[@"address"];
        NSString *scriptPubKey = raw[@"scriptPubKey"];
        NSString *derivedPath = raw[@"derivedPath"];
        return [self initWith:txHash vout:vout amount:amount address:address scriptPubKey:scriptPubKey derivedPath:derivedPath];
    } @catch (NSException *exception) {
        return nil;
    } @finally {
        
    }
    
}

+(UTXO *)parseFormBlockchain:(NSDictionary *)raw isTestNet:(BOOL)isTestNet isSegWit:(BOOL)isSegWit{
    @try {
        NSString *txHash = raw[@"tx_hash_big_endian"];
        int vout = (int)raw[@"tx_output_n"];
        SInt64 amount = (SInt64)raw[@"value"];
        NSString *scriptPubKey = raw[@"script"];
        //    let address = WalletManager.scriptToAddress(scriptPubKey, isTestNet: isTestNet, isSegWit: isSegWit)
        
        return [[UTXO alloc] initWith:txHash vout:vout amount:amount address:@"" scriptPubKey:scriptPubKey derivedPath:nil];
        
    } @catch (NSException *exception) {
        return nil;
    } @finally {
        
    }
    
}
@end
