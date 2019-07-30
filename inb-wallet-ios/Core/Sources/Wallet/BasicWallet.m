//
//  BasicWallet.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/17.
//  Copyright © 2019 apple. All rights reserved.
//

#import "BasicWallet.h"
#import "WalletMeta.h"

#import "Identity.h"

#import "ETHKeystore.h"
#import "ETHMnemonicKeystore.h"

#import "BTCKeystore.h"
#import "BTCMnemonicKeystore.h"

#import "NSData+HexString.h"

@implementation BasicWallet

-(instancetype)initWithJSON:(NSDictionary *)json{
    if(self = [super init]){
        int version = [json[@"version"] intValue];
        NSDictionary *meta = json[[WalletMeta getKey]];
        NSString *chainTypeStr = meta[@"chain"];
        ChainType chainType = [WalletMeta getChainType:chainTypeStr];
        NSString *sourceStr = meta[@"source"];
        SourceType sourceType = [WalletMeta getSourceType:sourceStr];
//        [[WalletMeta alloc] initWithChainStr:chainTypeStr sourceStr:sourceStr];
        
        NSArray *mnemonicKeystoreSource = @[@(source_mnemonic), @(source_newIdentity), @(source_recoverdIdentity)];
        switch (version) {
            case 3:{
                switch (chainType) {
                    case chain_eth:{
                        if([mnemonicKeystoreSource containsObject:@(sourceType)]){
                            self.keystore = [[ETHMnemonicKeystore alloc] initJSON:json];
                        }else{
                            self.keystore = [[ETHKeystore alloc] initWithJSON:json];
                        }
                        break;
                    }
                    case chain_btc:{
//                        self.keystore = BTC
                        self.keystore = [[BTCKeystore alloc] initWithJSON:json];
                        break;
                    }
                    case chain_eos:{
                        break;
                    }
                    case chain_insight:{
                        break;
                    }
                }
                break;
            }
            case defaultVersion_btnMnemonicKeystore:{
                self.keystore = [[BTCMnemonicKeystore alloc] initWithJSON:json];
                break;
            }
            default:
                break;
        }
        
        self.chainType = chainTypeStr;
        
        self.walletID = self.keystore.ID;
    }
    return self;
}
-(instancetype)initWithKeystore:(Keystore *)keystore{
    if (self = [super init]) {
        self.walletID = keystore.ID;
        self.keystore = keystore;
        self.chainType = keystore.meta.chain;
    }
    return self;
}

-(BOOL)verifyPassword:(NSString *)password{
    return [self.keystore verify:password];
}

-(NSString *)privateKey:(NSString *)password{
    if(![self.keystore verify:password]){
        @throw Exception(@"PasswordError", @"incorrect");
        return nil;
    }
    if([self.keystore isKindOfClass:[PrivateKeyCrypto class]]){
        PrivateKeyCrypto *pkKestore = (PrivateKeyCrypto *)self.keystore;
        return [pkKestore decryptPrivateKey:password];
    }else if([self.keystore conformsToProtocol:@protocol(WIFCrypto)]){
       BTCKeystore *wifKeystore = (BTCKeystore *)self.keystore;
        return [wifKeystore decryptWIF:password];
    }else{
        @throw Exception(@"GenericError", @"operationUnsupported");
        return nil;
    }
}
-(NSString *)exportMnemonic:(NSString *)password{
    if ([self.keystore isKindOfClass:[ETHMnemonicKeystore class]]) {
        ETHMnemonicKeystore *mnemonicKeystore = (ETHMnemonicKeystore *)self.keystore;
        
        if(![self.keystore verify:password]){
            @throw Exception(@"PasswordError", @"incorrect");
        }
        NSString *str = [mnemonicKeystore decryptMnemonic:password];
        return str;
    }else if([self.keystore isKindOfClass:[BTCMnemonicKeystore class]]){
        BTCMnemonicKeystore *mnemonicKeystore = (BTCMnemonicKeystore *)self.keystore;
        if(![self.keystore verify:password]){
            @throw Exception(@"PasswordError", @"incorrect");
        }
        NSString *str = [mnemonicKeystore decryptMnemonic:password];
        NSString *menStr = [[NSString alloc] initWithData:[NSData hexStringToData:str] encoding:NSUTF8StringEncoding];
        return menStr;
    }
    return @"";
    
}
-(NSString *)exportT{
    return [self.keystore exportToString];
}

-(BOOL)deleteWallet{
    Identity *identity = [Identity currentIdentity];
    if (!identity) {
        return NO;
    }
    return [identity removeWallet:self];
}

#pragma mark ----
-(NSString *)name{
    return self.keystore.meta.name;
}
-(NSString *)address{
    return self.keystore.address;
}
-(WalletMeta *)imTokenMeta{
    return self.keystore.meta;
}

@end
