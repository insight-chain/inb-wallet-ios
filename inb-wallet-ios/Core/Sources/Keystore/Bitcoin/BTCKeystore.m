//
//  BTCKeystore.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/6/28.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "BTCKeystore.h"
#import "PrivateKeyValidator.h"
#import "BTCKey+Category.h"
#import "NSData+HexString.h"

#import "BTCKeystore.h"

@implementation BTCKeystore

-(instancetype)initWithPassword:(NSString *)password wif:(NSString *)wif metadata:(WalletMeta *)metadata ID:(NSString *)ID{
    if (self = [super init]) {
        NSString *privateKey = [[[PrivateKeyValidator alloc] initWithPrivateKey:wif chain:chain_btc network:network_main requireCompressed:metadata.isSegWit] validate];
        BTCKey *key = [[BTCKey alloc] initWithWIF:wif];
        self.address = [[key addressOn:network_main segWit:metadata.segWit] string];
        
        self.crypto = [[Crypto alloc] initWith:password privateKey:[[privateKey dataUsingEncoding:NSUTF8StringEncoding] dataToHexString] cacheDerivedKey:NO];
        self.ID = [ID isEqualToString:@""] ? [BTCKeystore generateKeystoreId] : ID;
        self.meta = metadata;
    }
    return self;
}

-(instancetype)initWithJSON:(NSDictionary *)json{
    if (self = [super init]) {
        NSDictionary *cryptoJson = json[@"crypto"] ? json[@"crypto"] : json[@"Crypto"];
        if (!cryptoJson) {
            Exception(@"KeystoreError", @"invalid");
        }
        if([json[@"version"] intValue] != self.version){
            @throw Exception(@"KeystoreError", @"invalid");
        }
        self.ID = json[@"id"] ? json[@"id"] : [BTCKeystore generateKeystoreId];
        self.address = json[@"address"] ? json[@"address"] : @"";
        self.crypto = [[Crypto alloc] initWithJSON:cryptoJson];
        
        NSDictionary *metaJSON = json[[WalletMeta getKey]];
        if (metaJSON) {
            self.meta = [[WalletMeta alloc] initWithJSON:metaJSON];
        }else{
            self.meta = [[WalletMeta alloc] initWith:chain_btc source:source_keystore network:network_main];
        }
    }
    return self;
}



-(NSDictionary *)serializeToMap{
    return @{@"id":self.ID,
             @"address":self.address,
             @"createdAt":@(self.meta.timestamp),
             @"source":self.meta.source,
             @"chainType":self.meta.chain,
             @"segWit":self.meta.segWit
             };
}

//-(NSString *)dump{
//    
//}
//-(BOOL)verify:(NSString *)password{
//    
//}
//-(NSDictionary *)toJSON{
//    
//}

-(NSString *)decryptWIF:(NSString *)password{
    //TODO....可能 需要 hexString
    NSString *wif = [self.crypto privateKey:password];
    BTCKey *key = [[BTCKey alloc] initWithWIF:wif];
    
    return self.meta.isMainnet ? key.WIF : key.WIFTestnet;
}

-(int)version{
    return 3;
}

+(NSString *)generateKeystoreId{
    return [[NSUUID UUID].UUIDString lowercaseString];
}

@end
