//
//  PrivateKeyValidator.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/23.
//  Copyright © 2019 apple. All rights reserved.
//

#import "PrivateKeyValidator.h"


#import "ETHKeystore.h"

#import "NSData+HexString.h"
#import "Secp256k1_Insight.h"
#import "BTCKey.h"

@interface PrivateKeyValidator()
@property(nonatomic, strong) NSString *privateKey;
@property(nonatomic, assign) ChainType chain;
@property(nonatomic, assign) Network network;
@property(nonatomic, assign) BOOL requireCompressed;
@end

@implementation PrivateKeyValidator

-(instancetype)initWithPrivateKey:(NSString *)privateKey chain:(ChainType)chain network:(Network)network requireCompressed:(BOOL)requireCompressed{
    if (self = [super init]) {
        self.privateKey = privateKey;
        self.chain = chain;
        self.network = network;
        self.requireCompressed = requireCompressed;
    }
    return self;
}
-(BOOL)isValid{
    switch (self.chain) {
        case chain_btc:
            @try {
                [self validateBtc];
                return YES;
            } @catch (NSException *exception) {
                return NO;
            } @finally {
                break;
            }
        case chain_eth:
            @try {
                [self validateEth];
                return YES;
            } @catch (NSException *exception) {
                return NO;
            } @finally {
                
            }
        case chain_eos:
            return NO;
        default:
            return NO;
    }
}

-(NSString *)validate{
    switch (self.chain) {
        case chain_btc:
            return [self validateBtc];
        case chain_eth:
            return [self validateEth];
        case chain_eos:
            return [self validateEos];
        default:
            return @"";
            break;
    }
}
-(NSString *)validateBtc{
    BTCKey *key = [[BTCKey alloc] initWithWIF:self.privateKey];
    if (!key || key.privateKey ) {
        Exception(@"PrivateKeyError", @"wifInvalid");
        return @"";
    }
    if (self.requireCompressed && ![key isPublicKeyCompressed]) {
        Exception(@"PrivateKeyError", @"publicKeyNotCompressed");
    }
    
    NSString *wif = self.network == network_main ? key.WIF : key.WIFTestnet;
    if (![wif isEqualToString:self.privateKey]) {
        Exception(@"GenericError", @"wifWrongNetwork");
    }
    
    return self.privateKey;
}
-(NSString *)validateEth{
    if(![[[Secp256k1_Insight alloc] init] verify:self.privateKey]){
        @throw Exception(@"PrivateKeyError", @"invalid");
    }
    NSMutableData *pubKeyData = [[BTCKey alloc] initWithPrivateKey:[NSData hexStringToData:self.privateKey]].publicKey;
    NSString *pubStr = [pubKeyData dataToHexString];
    NSString *stringToEncrypt = [pubStr substringFromIndex:2];
    if([stringToEncrypt isEqualToString:@""]){
        @throw Exception(@"PrivateKeyError", @"invalid");
        return nil;
    }
    return self.privateKey;
}
-(NSString *)validateEos{
    return @"";
}
@end
