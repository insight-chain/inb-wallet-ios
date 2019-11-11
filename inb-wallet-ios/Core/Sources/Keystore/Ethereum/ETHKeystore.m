//
//  ETHKeystore.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/21.
//  Copyright © 2019 apple. All rights reserved.
//

#import "ETHKeystore.h"

#import "ETHKey.h"

@implementation ETHKeystore
-(instancetype)initWith:(NSString *)password privatedKey:(NSString *)privatedKey metadata:(WalletMeta *)metadata ID:(NSString *)ID{
    if (self = [super init]) {
        self.address = [[ETHKey alloc] initWithPrivateKey:privatedKey].address;//[NSString stringWithFormat:@"95%@",[[ETHKey alloc] initWithPrivateKey:privatedKey].address];
        self.crypto = [[Crypto alloc] initWith:password privateKey:privatedKey cacheDerivedKey:NO];
        if (!ID || [ID isEqualToString:@""]) {
            ID = [ETHKeystore generateKeystoreId];
        }
        self.ID = ID;
        
        self.meta = metadata;
    }
    return self;
}
-(instancetype)initWithJSON:(NSDictionary *)json{
    if (self = [super init]) {
        NSDictionary *cryptoJson = json[@"crypto"] ? json[@"crypto"] : json[@"Crypto"];
        int version = [json[@"version"] intValue];
        if (!cryptoJson || version!=self.version) {
            @throw [NSException exceptionWithName:@"Keystore" reason:@"invalid" userInfo:nil];
        }
        NSString *ID = json[@"id"];
        self.ID = ID ? ID : [ETHKeystore generateKeystoreId];
        self.address = json[@"address"] ? json[@"address"] :@"";//[NSString stringWithFormat:@"95%@",json[@"address"] ? json[@"address"] :@""];
        self.crypto = [[Crypto alloc] initWithJSON:cryptoJson];
        
        NSDictionary *metaJSON = json[WalletMeta.getKey];
        if (metaJSON) {
            self.meta = [[WalletMeta alloc] initWithJSON:metaJSON];
        }else{
            self.meta = [[WalletMeta alloc] initWith:chain_eth source:source_keystore network:network_main];
        }
        
    }
    return self;
}

-(NSDictionary *)serializeToMap{
    return @{@"id":self.ID,
             @"address":self.address,//[self.address hasPrefix:@"95"]?[self.address substringFromIndex:2]:self.address,
             @"createdAt":@(self.meta.timestamp),
             @"source":self.meta.source,
             @"chainType":self.meta.chain
             };
}

-(int)version{
    return 3;
}

-(BOOL)verify:(NSString *)password{
    NSString *decryptedMac = [self.crypto macFrom:password];
    NSString *mac = self.crypto.mac;
    return [[decryptedMac lowercaseString] isEqualToString:[mac lowercaseString]];
}


@end
