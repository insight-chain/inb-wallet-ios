//
//  WalletManager.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/23.
//  Copyright © 2019 apple. All rights reserved.
//

#import "WalletManager.h"
#import "Identity.h"
#import "IdentityValidator.h"
#import "V3KeystoreValidator.h"
#import "ETHTransaction.h"

#import "BTCKey+Category.h"
#import "BTCTransactionSigner.h"
#import "BTCMnemonicKeystore.h"

@implementation WalletManager

+(BasicWallet *)importFromMnemonic:(NSString *)mnemonic metadata:(WalletMeta *)metadata encryptBy:(NSString *)password path:(NSString *)path{
    Identity *identity = [[[IdentityValidator alloc] init] validate];
    //TODO.... CommonTransaction.reportUsage
    
    return [identity importFromMnemonic:mnemonic metadata:metadata password:password path:path];
}
+(BasicWallet *)importFromKeystore:(NSDictionary *)keystore encryptedBy:(NSString *)password metadata:(WalletMeta *)metadata{
    Identity *identity = [[[IdentityValidator alloc] init] validate];
    [[[V3KeystoreValidator alloc] initWithKeystore:keystore] validate];
    return [identity importFromKeystore:keystore password:password metadata:metadata];
}

+(BasicWallet *)importFromPrivateKey:(NSString *)private encryptedBy:(NSString *)password metadata:(WalletMeta *)metadata accountName:(NSString *)account{
    Identity *identity = [[[IdentityValidator alloc] init] validate];
    //TODO.... CommonTransaction.reportUsage
    
    return [identity importFromPrivateKey:private encryptedBy:password metadata:metadata accountName:account];
}

+(NSString *)exportPrivateKeyForID:(NSString *)walletID password:(NSString *)password{
    BasicWallet *wallet = [[Identity currentIdentity] findWalletByWalletID:walletID];
    if (!wallet) {
        @throw Exception(@"GenericError", @"walletNotFound");
    }
    return [wallet privateKey:password];
}
+(NSString *)exportMnemonicForID:(NSString *)walletID password:(NSString *)password{
    BasicWallet *wallet = [[Identity currentIdentity] findWalletByWalletID:walletID];
    if (!wallet) {
        @throw Exception(@"GenericError", @"walletNotFound");
    }
    return [wallet exportMnemonic:password];
}
+(NSString *)exportKeystoreForID:(NSString *)walletID password:(NSString *)password{
    BasicWallet *wallet = [Identity.currentIdentity findWalletByWalletID:walletID];
    if (!wallet) {
        @throw Exception(@"GenericError", @"walletNotFound");
    }
    if(![wallet verifyPassword:password]){
        @throw Exception(@"PasswordError", @"incorrect");
    }
    return [wallet exportT];
}

+(BasicWallet *)findWalletByPrivateKey:(NSString *)privateKey chainType:(ChainType)chainType network:(NSString *)network segWit:(NSString *)segWit{
    Identity *identity = [[[IdentityValidator alloc] init] validate];
    return [identity findWalletByPrivateKey:privateKey chainType:chainType network:@"MAINNET" segWit:nil];
}
+(BasicWallet *)findWalletByMnemonic:(NSString *)mnemonic chainType:(ChainType)chainType path:(NSString *)path network:(NSString *)network segWit:(NSString *)segWit{
    Identity *identity = [[[IdentityValidator alloc] init] validate];
    
    return [identity findWalletByMnemonic:mnemonic chainType:chainType path:path network:network segWit:segWit];
    
}
+(BasicWallet *)findWalletByKeystore:(NSDictionary *)keystore chainType:(ChainType)chainType passwork:(NSString *)password{
    Identity *identity = [[[IdentityValidator alloc] init] validate];
    return [identity findWalletByKeystore:keystore chainType:chainType password:password];
}
+(BasicWallet *)findWalletByWalletID:(NSString *)walletID{
    Identity *identity = [[[IdentityValidator alloc] init] validate];
    return [identity findWalletByWalletID:walletID];
}
+(BasicWallet *)findWalletByAddress:(NSString *)address chainType:(ChainType)chainType{
    Identity *identity = [[[IdentityValidator alloc] init] validate];
    BasicWallet *wallet = [identity findWalletByAddress:address chainType:chainType];
    if (!wallet) {
        @throw Exception(@"GenericError", @"walletNotFound");
    }
    return wallet;
}

+(BasicWallet *)modifyWalletPasswordByWalletID:(NSString *)walletID oldPassword:(NSString *)old newPassword:(NSString *)newPassword{
    Identity *identity = [[[IdentityValidator alloc] init] validate];
    BasicWallet *wallet = [identity findWalletByWalletID:walletID];
    if(![wallet verifyPassword:old]){
        return nil;
    }else{
        NSString *mnemonic = [wallet exportMnemonic:old];
        if(mnemonic && ![mnemonic isEqualToString:@""]){
            BasicWallet *newWallet = [self importFromMnemonic:mnemonic metadata:wallet.imTokenMeta encryptBy:newPassword path:@"m/49'/0'/0'"];
            [identity removeWallet:wallet]; //移除
            return newWallet;
        }else{
            NSString *privateKey = [wallet privateKey:old];
            if(!privateKey || [privateKey isEqualToString:@""]){
                return nil;
            }
            BasicWallet *newWallet = [self importFromPrivateKey:privateKey encryptedBy:newPassword metadata:wallet.imTokenMeta accountName:wallet.name];
            [identity removeWallet:wallet]; //移除
            return newWallet;
        }
    }
}

/**
 * Sign transaction with given parameters
 * returns signed data
 */
+(TransactionSignedResult *)ethSignTransactionWithWalletID:(NSString *)walletID nonce:(NSString *)nonce txType:(TxType)txType gasPrice:(NSString *)gasPrice gasLimit:(NSString *)gasLimit to:(NSString *)to value:(NSString *)value data:(NSString *)data password:(NSString *)password chainID:(int)chainID{
    
    BasicWallet *wallet = [[Identity currentIdentity] findWalletByWalletID:walletID];
    if (!wallet) {
        @throw Exception(@"GenericError", @"walletNotFound");
    }
    @try {
        NSString *privatedKey = [wallet privateKey:password];
        NSLog(@"地址。。%@", wallet.address);
        NSDictionary *raw = @{@"nonce":nonce,
//                              @"gasPrice":gasPrice,
//                              @"gasLimit":gasLimit,
                              @"to":to,
                              @"value": value, //@"0x9184e23",
                              @"data":data,
                              @"txType":[NSString stringWithFormat:@"%d",txType],
                              }; /*@"resourcePayer":@"0xaa18a055AB2017a0Cd3fB7D70f269C9B80092206",
                                  @"vp":@"",
                                  @"rp":@"",
                                  @"sp":@""*/
        NSData *dd = [NSJSONSerialization dataWithJSONObject:raw options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc] initWithData:dd encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@", str);
        
        ETHTransaction *tx = [[ETHTransaction alloc] initWithRaw:raw chainID:chainID];
        [tx signWithPrivateKey:privatedKey];
        return tx.signedResult;
    } @catch (NSException *exception) {
        @throw exception;
    } @finally {
        
    }
    
    
    
}

/** 抵押 **/
+(TransactionSignedResult *)inbMortgageWithWalletID:(NSString *)walletID value:(NSString *)value password:(NSString *)password chainID:(int)chainID{
    BasicWallet *wallet = [[Identity currentIdentity] findWalletByWalletID:walletID];
    if (!wallet) {
        @throw Exception(@"GenericError", @"walletNotFound");
    }
    @try {
        NSString *privatedKey = [wallet privateKey:password];
        
        NSDictionary *mortgageRaw = @{@"from":[wallet.address add0xIfNeeded],
                                      @"to":@"",
                                      @"value":value,
                                      @"data":[[@"mortgageNet" hexString] add0xIfNeeded],
                                      };
        ETHTransaction *tx = [[ETHTransaction alloc] initWithMortgageRaw:mortgageRaw chainID:chainID];
        [tx signMortgageWithPrivateKey:privatedKey];
        return tx.signedMortgageResult;
    }@catch (NSException *exception) {
        @throw exception;
    } @finally {
        
    }
}


/** BTC交易 **/
+(TransactionSignedResult *)btcSignTransactionWithWalletID:(NSString *)walletID to:(NSString *)to amount:(int64_t)amount fee:(int64_t)fee password:(NSString *)password outputs:(NSArray *)outputs changeIdx:(int)changeIdx isTestnet:(BOOL)isTestnet segWit:(NSString *)segWit{
    BasicWallet *wallet = [[Identity currentIdentity] findWalletByWalletID:walletID];
    if (!wallet) {
        @throw Exception(@"GenericError", @"walletNotFound");
    }
    
    BTCAddress *toAddress = [BTCAddress addressWithString:to];
    if (!toAddress) {
        @throw Exception(@"AddressError", @"invalid");
    }
    
    NSMutableArray *unspents = [NSMutableArray array];
    SInt64 unspentAmount = 0;
    for (NSDictionary *output in outputs) {
        UTXO *utxo;
        if (output[@"tx_hash_big_endian"] != nil) {
            utxo = [UTXO parseFormBlockchain:output isTestNet:isTestnet isSegWit:[segWit isEqualToString:@"P2WPKH"]];
        }else{
            utxo = [[UTXO alloc] initWithRaw:output];
        }
        
        if (!utxo) {
            @throw Exception(@"GenericError", @"paramError");
        }
        UTXO *unspent = utxo;
        [unspents addObject:unspent];
        unspentAmount += unspent.amount;
        
        if (unspentAmount >= (amount + fee)) {
            break;
        }
    }
    
    BTCKey *changeKey;
    NSMutableArray *privateKeys;
    if(wallet.imTokenMeta.sourceType == source_wif){
        NSString *wif = [wallet privateKey:password];
        changeKey = [[BTCKey alloc] initWithWIF:wif];
        privateKeys = [[NSMutableArray alloc] init];
        for (int i=0; i<outputs.count; i++) {
            [privateKeys addObject:changeKey];
        }
    }else{
        NSString *extendedKey = [wallet privateKey:password];
        BTCKeychain *keychain = [[BTCKeychain alloc] initWithExtendedKey:extendedKey];
        BTCKey *key = [keychain changeKeyAtIndex:(UInt32)changeIdx];
        if (!keychain || key)  {
            @throw Exception(@"GenericError", @"unknownError");
        }
        changeKey = key;
        privateKeys = [NSMutableArray array];
        for (UTXO *output in unspents) {
            BTCKey *key;
            NSString *derivedPath = output.derivedPath;
            if (derivedPath) {
                NSString *pathWithSlash = [NSString stringWithFormat:@"/%@", derivedPath];
                key = [keychain keyWithPath:pathWithSlash];
            }else{
                key = [BTCMnemonicKeystore findUtxoKeyByScript:output.scriptPubKey at:keychain isSwgWit:[segWit isEqualToString:@"P2WPKH"]];
            }
            key.publicKeyCompressed = YES;
            [privateKeys addObject:key];
        }
    }
    BTCAddress *changeAddress = [changeKey addressOn:isTestnet?network_test:network_main segWit:segWit];
    BTCTransactionSigner *signer = [[BTCTransactionSigner alloc] initWith:unspents keys:privateKeys amount:amount fee:fee toAddress:toAddress changeAddress:changeAddress];
    if ([segWit isEqualToString:@"P2WPKH"]) {
        return [signer signSegWit];
    }else{
        return [signer sign];
    }
}

@end
