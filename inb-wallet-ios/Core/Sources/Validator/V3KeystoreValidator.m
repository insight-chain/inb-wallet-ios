//
//  V3KeystoreValidator.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/6/1.
//  Copyright © 2019 apple. All rights reserved.
//

#import "V3KeystoreValidator.h"
@interface V3KeystoreValidator()
@property(nonatomic, strong) NSDictionary *keystore;
@end

@implementation V3KeystoreValidator
-(instancetype)initWithKeystore:(NSDictionary *)keystore{
    if (self = [super init]) {
        _keystore = keystore;
    }
    return self;
}

-(BOOL)isValid{
    NSDictionary *crypto = self.keystore[@"crypto"]?self.keystore[@"crypto"]:self.keystore[@"Crypto"];
    int version = [self.keystore[@"version"] intValue];
    NSString *address = self.keystore[@"address"];
    if (crypto == nil || version != 3 || address == nil || [address isEqualToString:@""]) {
        return NO;
    }
    return YES;
}
-(NSDictionary *)validate{
    if (![self validate]) {
        @throw [NSException exceptionWithName:@"KeystoreError" reason:@"invalid" userInfo:nil];
    }
    return self.keystore;
}

@end
