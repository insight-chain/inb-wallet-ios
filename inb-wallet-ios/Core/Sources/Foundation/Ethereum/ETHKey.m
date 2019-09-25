//
//  ETHKey.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/21.
//  Copyright © 2019 apple. All rights reserved.
//

#import "ETHKey.h"

#import "NSData+HexString.h"

#import "Mnemonic.h"

#import "Keccak256.h"

#import "BTCKey.h"
#import "BTCKeychain.h"

@interface ETHKey()
@property(nonatomic, strong) NSString *rootPrivateKey;

@end

@implementation ETHKey
-(instancetype)initWithPrivateKey:(NSString *)privateKey{
    if(self = [super init]){
        self.rootPrivateKey = @"";
        self.privateKey = privateKey;
    }
    return self;
}
-(instancetype)initWithSeed:(NSData *)seed path:(NSString *)path{
    if (self = [super init]) {
        BTCKeychain *rootKeychain = [[BTCKeychain alloc] initWithSeed:seed];
        self.rootPrivateKey = [[[rootKeychain extendedPrivateKey] dataUsingEncoding:NSUTF8StringEncoding] dataToHexString];
        NSArray *components = [path componentsSeparatedByString:@"/"];
        NSString *lastStr = [components lastObject];
        NSInteger index = [lastStr intValue];
        
        NSMutableArray *arr = [NSMutableArray arrayWithArray:components];
        [arr removeLastObject];
        BTCKeychain *account = [rootKeychain derivedKeychainWithPath:[arr componentsJoinedByString:@"/"]];
        self.privateKey = [[account keyAtIndex:index].privateKey dataToHexString];
    }
    return self;
}
-(instancetype)initWithMnemonic:(NSString *)mnemonic path:(NSString *)path{
    NSString *seed = [ETHMnemonic deterministicSeed:mnemonic passphrase:@""];
    return [self initWithSeed:[NSData hexStringToData:seed] path:path];
}

-(NSString *)address{
    BTCKey *btcKey = [[BTCKey alloc] initWithPrivateKey:[NSData hexStringToData:self.privateKey]];
    
    return [ETHKey pubToAddress:[btcKey uncompressedPublicKey]];
}
#pragma mark ----
+(NSString *)mnemonicToAddress:(NSString *)menmonic path:(NSString *)path{
    return [[ETHKey alloc] initWithMnemonic:menmonic path:path].address;
}
+(NSString *)pubToAddress:(NSData *)publicKey{
    NSString *stringToEncrypt = [[publicKey dataToHexString] substringFromIndex:2];
    NSString *sha3Keccak = [[[Keccak256_bridge alloc] init] encryptWithHex:stringToEncrypt];//[[[Keccak256 alloc] init] encrypt:stringToEncrypt];
//    return [sha3Keccak substringFromIndex:24];
    NSString *newAddr = [sha3Keccak substringFromIndex:26];
    return [NSString stringWithFormat:@"95%@", newAddr];
}



@end
