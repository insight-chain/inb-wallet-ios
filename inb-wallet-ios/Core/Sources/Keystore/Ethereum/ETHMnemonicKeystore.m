//
//  ETHMnemonicKeystore.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/23.
//  Copyright © 2019 apple. All rights reserved.
//

#import "ETHMnemonicKeystore.h"
#import "NSData+HexString.h"
#import "ETHKey.h"

@implementation ETHMnemonicKeystore

-(instancetype)initWithPassword:(NSString *)password mnemonic:(NSString *)mnemonic path:(NSString *)path metadata:(WalletMeta *)metadata ID:(NSString *)ID{
    if (self = [super init]) {
        self.ID = ID ? ID : [ETHMnemonicKeystore generateKeystoreId];
        self.meta = metadata;
        
        ETHKey *ethKey = [[ETHKey alloc] initWithMnemonic:mnemonic path:path];
        self.crypto = [[Crypto alloc] initWith:password privateKey:ethKey.privateKey cacheDerivedKey:YES];
        NSString *dk = [self.crypto cachedDerivedKey:password];
        self.encMnemonic = [EncryptedMessage createCrypto:self.crypto derivedKey:dk  message:mnemonic nonce:nil]; //mnemonic
        NSString *hesStr = [[mnemonic dataUsingEncoding:NSUTF8StringEncoding] dataToHexString];
        NSString *mne = [[NSString alloc] initWithData:[NSData hexStringToData:hesStr] encoding:NSUTF8StringEncoding];
        NSLog(@"mmmm...:%@", mne);
        [self.crypto clearDerivedKey];
        self.mnemonicPath = path;
        self.address = [NSString stringWithFormat:@"95%@",ethKey.address];
    }
    return self;
}
-(instancetype)initJSON:(NSDictionary *)json{
    if (self = [super init]) {
        
        NSDictionary *cryptoJson =  json[@"crypto"] ? json[@"crypto"] : json[@"Crypto"];
        int version = [json[@"version"] intValue];
        NSDictionary *encMnemonicNode = json[@"encMnemonic"];
        NSString *mnemonicPath = json[@"mnemonicPath"];
        if (!cryptoJson || version!=self.version || !encMnemonicNode || !mnemonicPath) {
            @throw Exception(@"KeystoreError", @"invalid");
        }
        self.ID = json[@"id"] ? json[@"id"] : [ETHMnemonicKeystore generateKeystoreId];
        self.address = [NSString stringWithFormat:@"95%@",json[@"address"] ? json[@"address"] : @""];
        self.crypto = [[Crypto alloc] initWithJSON:cryptoJson];
        
        self.encMnemonic = [[EncryptedMessage alloc] initWithJSON:encMnemonicNode];
        self.mnemonicPath = mnemonicPath;
        NSDictionary *metaJSON = json[[WalletMeta getKey]];
        if (metaJSON) {
            self.meta = [[WalletMeta alloc] initWithJSON:metaJSON];
        }else{
            self.meta = [[WalletMeta alloc] initWith:chain_eth source:source_keystore network:network_main];
        }
    }
    return self;
}
-(int)version{
    return 3;
}
-(NSDictionary *)toJSON{
    NSMutableDictionary *json = [NSMutableDictionary dictionaryWithDictionary:[self getStardandJSON]];
    json[@"mnemonicPath"] = self.mnemonicPath;
    json[@"encMnemonic"] = [self.encMnemonic toJSON];
    json[[WalletMeta getKey]] = [self.meta toJSON];
    return json;
}
-(NSDictionary *)serializeToMap{
    return @{@"id": self.ID,
             @"address": [self.address hasPrefix:@"95"]?[self.address substringFromIndex:2]:self.address,
             @"createdAt": @(self.meta.timestamp),
             @"source": self.meta.source,
             @"chainType": self.meta.chain
             };
}

-(NSString *)decryptMnemonic:(NSString *)password{
    NSString *mnemonicHexStr = [self.encMnemonic decrypt:self.crypto password:password];
    NSData *mnemonicData = [NSData hexStringToData:mnemonicHexStr];
    NSString *mnemonic = [[NSString alloc] initWithData:mnemonicData encoding:NSUTF8StringEncoding];
    return mnemonic;
}
-(BOOL)verify:(NSString *)password{
    NSString *decryptedMac = [self.crypto macFrom:password];
    NSString *mac = self.crypto.mac;
    return [[decryptedMac lowercaseString] isEqualToString:[mac lowercaseString]];
}

@end
