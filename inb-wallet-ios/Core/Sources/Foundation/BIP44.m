//
//  BIP44.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/6/28.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "BIP44.h"

static const NSString *eth  = @"m/44'/60'/0'/0/0";
static const NSString *ipfs = @"m/44'/99'/0'";

static const NSString *btcMainnet = @"m/44'/0'/0'";
static const NSString *btcTestnet = @"m/44'/1'/0'";
static const NSString *btcSegwitMainnet = @"m/49'/0'/0'";
static const NSString *btcSegwitTestnet = @"m/49'/1'/0'";

static const NSString *eos = @"m/44'/194'";
//  public static let slip48 = "m/48'/4'/0'/0'/0',m/48'/4'/1'/0'/0'"
static const NSString *eosLedger = @"m/44'/194'/0'/0/0";

@implementation BIP44

+(NSString *)eth{
    return eth;
}
+(NSString *)ipfs{
    return ipfs;
}
+(NSString *)btcMainnet{
    return btcMainnet;
}
+(NSString *)btcTestnet{
    return btcTestnet;
}
+(NSString *)btcSegwitMainnet{
    return btcSegwitMainnet;
}
+(NSString *)btcSegwitTestnet{
    return btcSegwitTestnet;
}
+(NSString *)eos{
    return eos;
}

+(NSString *)pathFor:(Network)network segWit:(NSString *)segWit{
    if (network == network_main) {
        if ([segWit isEqualToString:@"P2WPKH"]) {
            return [BIP44 btcSegwitMainnet];
        }else{
            return [BIP44 btcMainnet];
        }
    }else{
        if ([segWit isEqualToString:@"P2WPKH"]) {
            return [BIP44 btcSegwitTestnet];
        }else{
            return [BIP44 btcTestnet];
        }
    }
}

@end
