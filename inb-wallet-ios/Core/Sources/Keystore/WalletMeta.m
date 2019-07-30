//
//  WalletMeta.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/17.
//  Copyright © 2019 apple. All rights reserved.
//
#import "WalletMeta.h"

@implementation WalletMeta

+(double)currentTime{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    return (double)timeInterval;
}
+(NSString *)currentVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    if (!infoDictionary) {
        return @"none-loaded-bundle";
    }
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // app build版本
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    return [NSString stringWithFormat:@"iOS-%@.%@", app_Version, app_build];
}

-(instancetype)initWith:(SourceType)source{
    if (self = [super init]) {
        self.source = [WalletMeta getSourceStr:source];
        self.timestamp = [WalletMeta currentTime];
        self.version = [WalletMeta currentVersion];
        
        self.mode = @"normal";
        self.passwordHint = @"";
        self.segWit = @"none";
        self.backup = @[];
    }
    return self;
}
-(instancetype)initWith:(ChainType)chain source:(SourceType)source network:(Network)network{
    if(self = [super init]){
        self.chainType = chain;
        self.sourceType = source;
        
        self.mode = @"normal";
        self.passwordHint = @"";
        self.segWit = @"none";
        self.backup = @[];
        
        self.source = [WalletMeta getSourceStr:source];
        self.chain = [WalletMeta getChainStr:chain];
        self.timestamp = [WalletMeta currentTime];
        self.version = [WalletMeta currentVersion];
        self.network = network;
    }
    return self;
}
-(instancetype)initWithChainStr:(NSString *)chainStr sourceStr:(NSString *)sourceStr{
    if (self = [super init]) {
        
        self.mode = @"normal";
        self.passwordHint = [NSString stringWithFormat:@""];
        self.segWit = @"none";
        self.backup = @[];
        
        self.source = sourceStr;
        self.chain = chainStr;
        self.timestamp = [WalletMeta currentTime];
        self.version = [WalletMeta currentVersion];
    }
    return self;
}

-(instancetype)initWithJSON:(NSDictionary *)json{
    if(self = [super init]){
        NSString *source = json[@"source"];
        if(source){
            self.source = source? source : @"";
        }else{
            self.source = @"NEW_IDENTITY"; //新身份
        }
        NSString *timestampStr = json[@"timestamp"];
        if (timestampStr) {
            self.timestamp = [timestampStr doubleValue];
        }else{
            self.timestamp = [WalletMeta currentTime];
        }
        NSString *version = json[@"version"];
        if(version){
            self.version = version;
        }else{
            self.version = [WalletMeta currentVersion];
        }
        
        NSString *chainStr = json[@"chain"];
        if (chainStr) {
            self.chain = chainStr;
        }
        
        NSString *mode = json[@"mode"];
        if(mode){
            self.mode = mode;
        }else{
            self.mode = @"";
        }
        
        NSString *name = json[@"name"];
        if(name){
            self.name = name;
        }
        
        NSString *passwordHint = json[@"passwordHint"];
        if(passwordHint){
            self.passwordHint = passwordHint;
        }else{
            self.passwordHint = [NSString stringWithFormat:@""];
        }
        NSString *segWit = json[@"segWit"];
        if (segWit) {
            self.segWit = segWit;
        }else{
            self.segWit = @"none";
        }
        NSArray *back = json[@"backup"];
        if (back) {
            self.backup = back;
        }else{
            self.backup = @[];
        }
        
    }
    return self;
}

-(WalletMeta *)mergeMetaName:(NSString *)name chainType:(ChainType)chainType{
    WalletMeta *metadata = self;
    metadata.name = name;
    metadata.chain = [WalletMeta getChainStr:chainType];
    return metadata;
}

-(NSDictionary *)toJSON{
    
    NSDictionary *dic = @{@"source":self.source,
                          @"timestamp": [NSString stringWithFormat:@"%f",self.timestamp],
                          @"version": self.version,
                          @"mode": self.mode,
                          @"name": self.name,
                          @"passwordHint": self.passwordHint?self.passwordHint:@"",
                          @"backup": self.backup
                          };
    NSMutableDictionary *mut = [[NSMutableDictionary alloc] initWithDictionary:dic];
    
    if(self.chain){
        mut[@"chain"] = self.chain;
    }
    
    mut[@"segWit"] = self.segWit;
    
    return mut;
}

-(BOOL)isSegWit{
    if ([self.segWit isEqualToString:@"P2WPKH"]) {
        return YES;
    }else{
        return NO;
    }
}
-(BOOL)isNetwork{
    return self.network == network_main;
}
-(void)setChain:(NSString *)chain{
    _chain = chain;
    self.chainType = [WalletMeta getChainType:_chain];
}
-(void)setSource:(NSString *)source{
    _source = source;
    self.sourceType = [WalletMeta getSourceType:_source];
}

#pragma mark ---- private Function
+(NSString *)getChainStr:(ChainType) chain{
    switch (chain) {
        case chain_insight:
            return @"INSIGHT";
            break;
        case chain_eth:
            return @"ETHEREUM";
            break;
        case chain_btc:
            return @"BITCOIN";
            break;
        case chain_eos:{
            return @"EOS";
            break;
        }
    }
    return @"";
}
+(ChainType)getChainType:(NSString *)str{
    if ([str isEqualToString:@"INSIGHT"]) {
        return chain_insight;
    }else if ([str isEqualToString:@"ETHEREUM"]){
        return chain_eth;
    }else if ([str isEqualToString:@"BITCOIN"]){
        return chain_btc;
    }else if([str isEqualToString:@"EOS"]){
        return chain_eos;
    }else{
        return chain_insight;
    }
}
+(NSString *)getSourceStr:(SourceType)type{
    switch (type) {
        case source_newIdentity:
            return @"NEW_IDENTITY";
            break;
        case source_recoverdIdentity:
            return @"RECOVERED_IDENTITY";
        case source_privateKey:
            return @"PRIVATE";
        case source_wif:
            return @"WIF";
        case source_keystore:
            return @"KEYSTORE";
        case source_mnemonic:
            return @"MNEMONIC";
    }
}
+(SourceType)getSourceType:(NSString *)str{
    if ([str isEqualToString:@"NEW_IDENTITY"]) {
        return source_newIdentity;
    }else if ([str isEqualToString:@"RECOVERED_IDENTITY"]){
        return source_recoverdIdentity;
    }else if ([str isEqualToString:@"PRIVATE"]){
        return source_privateKey;
    }else if([str isEqualToString:@"WIF"]){
        return source_wif;
    }else if ([str isEqualToString:@"KEYSTORE"]){
        return source_keystore;
    }else if ([str isEqualToString:@"MNEMONIC"]){
        return source_mnemonic;
    }else{
        return -1;
    }
}
+(NSString *)getKey{
    return key;
}
@end
