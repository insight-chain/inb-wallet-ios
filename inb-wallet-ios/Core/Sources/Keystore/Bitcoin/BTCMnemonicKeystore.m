//
//  BTCMnemonicKeystore.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/23.
//  Copyright © 2019 apple. All rights reserved.
//

#import "BTCMnemonicKeystore.h"

#import "EncryptedMessage.h"

#import "Mnemonic.h"

#import "NSData+HexString.h"
#import "BTCKey+Category.h"

#import "AES128.h"

static int defultVersion;
static NSString *defaultSalt = @"imToken";

@implementation BTCMnemonicKeystore

-(instancetype)initWithPassword:(NSString *)password mnemonic:(NSString *)mnemonic path:(NSString *)path metadata:(WalletMeta *)metadata ID:(NSString *)ID{
    if (self = [super init]) {
        self.version = defaultVersion_btnMnemonicKeystore;
        self.ID = (ID && ![ID isEqualToString:@""]) ? ID : [BTCMnemonicKeystore generateKeystoreId];
        
        NSString *realMnemonic = mnemonic;
        if ([mnemonic isEqualToString:@""]) {
            realMnemonic = [[[ETHMnemonic alloc] init] mnemonic];
        }
        self.mnemonicPath = path;
        
        BTCMnemonic *btnMnemonic = [[BTCMnemonic alloc] initWithWords:[realMnemonic componentsSeparatedByString:@" "] password:@"" wordListType:BTCMnemonicWordListTypeEnglish];
        NSData *seedData = btnMnemonic.seed;
        if (!btnMnemonic || !seedData) {
            @throw Exception(@"MnemonicError", @"wordInvalid");
        }
        BTCNetwork *btcNetwork = metadata.isMainnet ? [BTCNetwork mainnet] : [BTCNetwork testnet];
        BTCKeychain *masterKeychain = [[BTCKeychain alloc] initWithSeed:seedData network:btcNetwork];
        BTCKeychain *accountKeychain = [masterKeychain derivedKeychainWithPath:self.mnemonicPath];
        if (!masterKeychain || !accountKeychain) {
            @throw Exception(@"GenericError", @"unknownError");
        }
        accountKeychain.network = btcNetwork;
        NSString *rootPrivateKey = [accountKeychain extendedPrivateKey];
        if (!rootPrivateKey) {
            @throw Exception(@"GenericError", @"unknownError");
        }
        self.crypto = [[Crypto alloc] initWith:password privateKey:[[rootPrivateKey dataUsingEncoding:NSUTF8StringEncoding] dataToHexString] cacheDerivedKey:true];
        self.encMnemonic = [EncryptedMessage createCrypto:self.crypto derivedKey:[self.crypto cachedDerivedKey:password] message:[[realMnemonic dataUsingEncoding:NSUTF8StringEncoding] dataToHexString] nonce:nil];
        [self.crypto clearDerivedKey];
        
        BTCKey *indexKey = [[accountKeychain derivedKeychainWithPath:@"/0/0"] key];
        self.address = [[indexKey addressOn:metadata.network segWit:metadata.segWit] string];
        self.xpub = [accountKeychain extendedPublicKey];
        self.meta = metadata;
        
    }
    return self;
}

-(instancetype)initWithJSON:(NSDictionary *)json{
    if(self = [super init]){
        
        if(json[@"version"]){
            self.version = [json[@"version"] intValue];
        }else{
            self.version = defaultVersion_btnMnemonicKeystore;
        }
        
        NSDictionary *cryptoJSON = json[@"crypto"];
        self.crypto = [[Crypto alloc] initWithJSON:cryptoJSON];
        
        self.ID = json[@"id"];
        self.mnemonicPath = json[@"mnemonicPath"];
        NSDictionary *encMnemonicJSON = json[@"encMnemonic"];
        self.encMnemonic = [[EncryptedMessage alloc] initWithJSON:encMnemonicJSON];
        
        self.address = json[@"address"];
        self.xpub = json[@"xpub"];
        
        NSDictionary *metaJSON = json[[WalletMeta getKey]];
        if (metaJSON) {
            self.meta = [[WalletMeta alloc] initWithJSON:metaJSON];
        }else{
            self.meta = [[WalletMeta alloc] initWith:chain_btc source:source_newIdentity network:network_main];
        }
    }
    return self;
}

-(NSString *)derivedKeyFor:(NSString *)password{
    NSString *key = [self.crypto derivedKey:password];
    return [key substringToIndex:32];
}

-(NSString *)getEncryptedXPub{
   AES128 *aes =  [[AES128 alloc] initWithKey:commonKey iv:commonIv mode:Mode_cbc padding:ccPKCS7Padding];
    return [BTCDataFromHex([aes encrypt:self.xpub]) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}
-(NSString *)getDecryptXPub{
    return self.xpub;
}

-(NSString *)calcExternalAddressAt:(NSInteger)index{
    BTCKey *indexKey = [[[[BTCKeychain alloc] initWithExtendedKey:self.xpub] derivedKeychainWithPath:[NSString stringWithFormat:@"/0/%ld",(long)index]] key];
    return [[indexKey addressOn:self.meta.network segWit:self.meta.segWit] string];
}


-(BOOL)verify:(NSString *)password{
    NSString *decryptedMac = [self.crypto macFrom:password];
    NSString *mac = self.crypto.mac;
    return [[decryptedMac lowercaseString] isEqualToString:[mac lowercaseString]];
}

-(NSString *)decryptMnemonic:(NSString *)password{
    NSString *mnemonicHexStr = [self.encMnemonic decrypt:self.crypto password:password];
    NSData *mnemonicData = [NSData hexStringToData:mnemonicHexStr];
    NSString *mnemonic = [[NSString alloc] initWithData:mnemonicData encoding:NSUTF8StringEncoding];
    return mnemonic;
}

+(NSDictionary *)scriptDerivedPathCache{
    return @{}.mutableCopy;
}

+(BTCKey *)findUtxoKeyByScript:(NSString *)script at:(BTCKeychain *)keychain isSwgWit:(BOOL)isSwgWit{
    NSString *derivedPath = [BTCMnemonicKeystore scriptDerivedPathCache][script];
    if (derivedPath) {
        NSString *s = [NSString stringWithFormat:@"/%@", derivedPath];
        return [keychain keyWithPath:s];
    }else{
        //TODO....
        return nil;
    }
}

#pragma mark ----
-(NSDictionary *)toJSON{
    NSMutableDictionary *mutJson = [NSMutableDictionary dictionaryWithDictionary:[self getStardandJSON]];
    mutJson[@"mnemonicPath"] = self.mnemonicPath;
    mutJson[@"encMnemonic"] = [self.encMnemonic toJSON];
    mutJson[@"xpub"] = self.xpub;
    mutJson[[WalletMeta getKey]] = [self.meta toJSON];
    
    return mutJson;
}

-(NSDictionary *)serializeToMap{
    NSDictionary *externalMap =@{@"address":[self calcExternalAddressAt:1],
                                 @"derivedPath":@"0/1",
                                 @"type":@"EXTERNAL",
                                 };
    return @{@"id":self.ID,
             @"address":self.address,
             @"externalAddress":externalMap,
             @"encXPub":[self getEncryptedXPub],
             @"createdAt":@(self.meta.timestamp),
             @"source":self.meta.source,
             @"chainType":self.meta.chain,
             @"segWit":self.meta.segWit,
             };
}



@end


#pragma mark ----
@implementation Info

-(instancetype)init{
    if (self = [super init]) {
        _curve = @"secp256k1";
        _purpose = @"sign";
    }
    return self;
}
-(instancetype)initWithJSON:(NSDictionary *)json{
    if (self = [super init]) {
        if (!json[@"curve"] || !json[@"purpose"]) {
            return nil;
        }
        _curve = json[@"curve"];
        _purpose = json[@"purpose"];
    }
    return self;
}
-(NSDictionary *)toJSON{
    return @{@"curve":self.curve,
             @"purpose":self.purpose,
             };
}

@end
