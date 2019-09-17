//
//  Keystore.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/17.
//  Copyright © 2019 apple. All rights reserved.
//

#import "Keystore.h"

@implementation Keystore

-(NSString *)dump{
    NSDictionary *json = [self toJSON];
    return [self prettyJSON:json];
}

-(NSDictionary *)toJSON{
    NSMutableDictionary *json = [[NSMutableDictionary alloc] initWithDictionary:[self getStardandJSON]];
    json[[WalletMeta getKey]] = self.meta.toJSON;
    return json;
}

-(NSString *)prettyJSON:(NSDictionary *)json{
    NSData *data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

-(NSString *)decryptPrivateKey:(NSString *)password{
    return [self.crypto privateKey:password];
}

-(NSDictionary *)getStardandJSON{
    return @{@"id": self.ID,
             @"address": [self.address hasPrefix:@"95"]?[self.address substringFromIndex:2]:self.address,
             @"version": @(self.version),
             @"crypto": [self.crypto toJSON],
             };
}

-(NSString *)exportToString{
    NSDictionary *json = [self getStardandJSON];
    return [self prettyJSON:json];
}

-(BOOL)verify:(NSString *)password{
    NSString *decryptedMac = [self.crypto macFrom:password];
    NSString *mac = self.crypto.mac;
    return [[decryptedMac lowercaseString] isEqualToString:[mac lowercaseString]];
}
#pragma mark ---- Static Fun
+(NSString *)generateKeystoreId{
    return [[NSUUID UUID].UUIDString lowercaseString];
}
@end



#pragma mark ---- PrivateKeyCrypto
@implementation PrivateKeyCrypto

-(NSString *)decryptPrivateKey:(NSString *)passwod{
    return [self.crypto privateKey:passwod];
}

@end
