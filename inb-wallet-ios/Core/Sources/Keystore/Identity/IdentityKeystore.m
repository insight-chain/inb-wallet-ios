//
//  IdentityKeystore.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/20.
//  Copyright © 2019 apple. All rights reserved.
//

#import "IdentityKeystore.h"

#import "Crypto.h"
#import "ETHKeystore.h"
#import "BTCMnemonic.h"

#import "Hash.h"
#import "SigUtil.h"

#import "NSData+HexString.h"

@interface IdentityKeystore()

@end

@implementation IdentityKeystore

-(instancetype)initWithMetadata:(WalletMeta *)metadata menmonic:(NSString *)menmonic password:(NSString *)password{
    if (self = [super init]) {
        self.version = [IdentityKeystore defaultVersion];
        self.ID = [ETHKeystore generateKeystoreId];
        
        BTCMnemonic *btcMnemonic = [[BTCMnemonic alloc] initWithWords:[menmonic componentsSeparatedByString:@" "] password:@"" wordListType:BTCMnemonicWordListTypeEnglish];
        NSData *seedData = [btcMnemonic seed];
        
        BTCKeychain *masterKeychain = [[BTCKeychain alloc] initWithSeed:seedData];
        BTCNetwork *network = [BTCNetwork mainnet];
        masterKeychain.network = network;
        
        NSString *masterKey = [masterKeychain.key.privateKey dataToHexString];
        NSData *backupKey = [BTCEncryptedBackup backupKeyForNetwork:network masterKey:[NSData hexStringToData:masterKey]];
        BTCKey *authenticationKey = [BTCEncryptedBackup authenticationKeyWithBackupKey:backupKey];
        
        
        NSData *dd = [@"Encryption key" dataUsingEncoding:NSUTF8StringEncoding];
        _encKey = [[Hash hmacSHA256WithKey:backupKey data:dd] dataToHexString];
        
        NSMutableData *identifierData = [NSMutableData data];
        // this magic hex will start with 'im' after base58check
        NSString *magicHex = @"0fdc0c";
        [identifierData appendData:[NSData hexStringToData:magicHex]];
        // todo: hardcode the network header
        uint8_t networkHeader = [network isMainnet] ? 0 : 111;
        NSMutableData *networkHeaderData = [NSMutableData dataWithBytes:&networkHeader length:sizeof(uint8_t)];
        [identifierData appendData:networkHeaderData];
        uint8_t identifierVersion = 2;
        NSMutableData *identifierVersionData = [NSMutableData dataWithBytes:&identifierVersion length:sizeof(uint8_t)];
        [identifierData appendData:identifierVersionData];
        
        NSData *hash160 = BTCHash160(authenticationKey.publicKey);
        [identifierData appendData:hash160];
        
        self.identifier = BTCBase58CheckStringWithData(identifierData);
        
        BTCKey *ipfsIDKey = [[BTCKey alloc] initWithPrivateKey:[NSData hexStringToData:self.encKey]];
        _ipfsId = [SigUtil calcIPFSIDFromKey:ipfsIDKey];
        
        _crypto = [[Crypto alloc] initWith:password privateKey:[[masterKeychain.extendedPrivateKey dataUsingEncoding:NSUTF8StringEncoding] dataToHexString] cacheDerivedKey:YES];
        NSString *derivedKey = [self.crypto cachedDerivedKey:password];
        
        NSString *mnemonicHex = [[menmonic dataUsingEncoding:NSUTF8StringEncoding] dataToHexString];
        _encMnemonic = [EncryptedMessage createCrypto:_crypto derivedKey:derivedKey message:menmonic nonce:nil]; //mnemonicHex
        
        NSString *authKeyHex = [authenticationKey.privateKey dataToHexString];
        _encAuthKey = [EncryptedMessage createCrypto:_crypto derivedKey:derivedKey message:authKeyHex nonce:nil];
        
        [_crypto clearDerivedKey];
        
        _meta = metadata;
    }
    return self;
}

-(instancetype)initWithJSON:(NSDictionary *)json{
    if (self = [super init]) {
        _ID = [ETHKeystore generateKeystoreId];
        self.version = json[@"version"]?[json[@"version"] intValue] : defaultVersion_identityKeystore;
        
        NSDictionary *cryptoJSON = json[@"crypto"];
        if (!cryptoJSON) {
            @throw [NSException exceptionWithName:@"KeystoreError" reason:@"invalid" userInfo:nil];
        }else{
            self.crypto = [[Crypto alloc] initWithJSON:cryptoJSON];
        }
        
        NSDictionary *encMnemonicJSON = json[@"encMnemonic"];
        NSString *identifier = json[@"identifier"];
        NSString *ipfsId = json[@"ipfsId"];
        NSDictionary *encAuthKeyJSON = json[@"encAuthKey"];
        NSString *encKey = json[@"encKey"];
        NSArray *walletIds = json[@"walletIds"];
        if (!encMnemonicJSON || !identifier || !ipfsId || !encAuthKeyJSON || !encKey || !walletIds) {
            @throw [NSException exceptionWithName:@"KeystoreError" reason:@"invalid" userInfo:nil];
        }
        EncryptedMessage *encMnemonic = [[EncryptedMessage alloc] initWithJSON:encMnemonicJSON];
        
        EncryptedMessage *encAuthKey = [[EncryptedMessage alloc] initWithJSON:encAuthKeyJSON];
        
        NSDictionary *metaJSON = json[[WalletMeta getKey]];
        
        self.encMnemonic = encMnemonic;
        self.encAuthKey = encAuthKey;
        self.identifier = identifier;
        _ipfsId = ipfsId;
        _encKey = encKey;
        self.walletIds = [NSMutableArray arrayWithArray:walletIds];
        self.wallets = @[].mutableCopy;
        self.meta = [[WalletMeta alloc] initWithJSON:metaJSON];
    }
    return self;
}

-(NSString *)dump:(BOOL)includingExtra{
    return [self toJSONString];
}
-(BOOL)verify:(NSString *)password{
    NSString *decryptedMac = [self.crypto macFrom:password];
    NSString *mac = self.crypto.mac;
    return [[decryptedMac lowercaseString] isEqualToString:[mac lowercaseString]];
}

-(NSString *)mnemonic:(NSString *)password{
    NSString *str = [self.encMnemonic decrypt:self.crypto password:password]; //HexStr
    NSData *da = [NSData hexStringToData:str];
    NSString *mnemonic = [[NSString alloc] initWithData:da encoding:NSUTF8StringEncoding];
    return mnemonic;
}

-(NSDictionary *)toJSON{
    return @{@"id": self.ID,
             @"identifier": self.identifier,
             @"ipfsId": self.ipfsId,
             @"encKey": self.encKey,
             @"version": @(self.version),
             @"encMnemonic": [self.encMnemonic toJSON],
             @"encAuthKey": [self.encAuthKey toJSON],
             @"crypto": [self.crypto toJSON],
             @"walletIds": self.walletIds,
            [WalletMeta getKey]: [self.meta toJSON]
             };
    
}
-(NSString *)toJSONString{
    NSData *data = [NSJSONSerialization dataWithJSONObject:[self toJSON] options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+(int)defaultVersion{
//    static int defaultVersion = 10000;
    return 10000;
}

-(NSMutableArray<BasicWallet *> *)wallets{
    if(_wallets == nil){
        _wallets = @[].mutableCopy;
    }
    return _wallets;
}
-(NSMutableArray *)walletIds{
    if (_walletIds == nil) {
        _walletIds = @[].mutableCopy;
    }
    return _walletIds;
}
@end
