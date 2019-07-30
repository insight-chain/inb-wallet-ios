//
//  Crypto.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/17.
//  Copyright © 2019 apple. All rights reserved.
//

#import "Crypto.h"
#import "Scrypt.h"

#import "CocoaSecurity.h"
#import "Keccak256.h"

#import "NSData+HexString.h"



@implementation Crypto

-(instancetype)initWith:(NSString *)password privateKey:(NSString *)privateKey cacheDerivedKey:(BOOL)cacheDerivedKey{
    if (self = [super init]) {
        self.cipher = [self cipherStr:aes128Ctr];
        self.cipherparams = [[Cipherparams alloc] init];
        self.kdf = @"scrypt";
        self.kdfparams = [[ScryptKdfparams alloc] initWithSalt:nil];
        NSString *derivedKey = [self.kdfparams derivedKey:password];
        self.cachedDerivedKey = [[CachedDerivedKey alloc] init];
        if (cacheDerivedKey) {
            [self.cachedDerivedKey cache:password derivedKey:derivedKey];
        }
        
        self.ciphertext = [[[AES128 alloc] initWithKey:[derivedKey substringToIndex:32] iv:self.cipherparams.iv mode:[self aesMode:aes128Ctr] padding:nil] encrypt:privateKey];
        NSString *macHex = [NSString stringWithFormat:@"%@%@", [derivedKey substringToIndex:32], self.ciphertext];
        self.mac = [[[Keccak256_bridge alloc] init] encryptWithHex:macHex];//[[[Keccak256 alloc] init] encrypt:macHex];
    }
    return self;
}
-(instancetype)initWithJSON:(NSDictionary *)json{
    if(self = [super init]){
        NSString *ciphertext = json[@"ciphertext"];
        NSDictionary *cipherparamsJson = json[@"cipherparams"];
        NSDictionary *kdfparamsJson = json[@"kdfparams"];
        NSString *mac = json[@"mac"];
        NSString *cipherStr = json[@"cipher"];
        NSString *kdfStr = json[@"kdf"];
        
        if (!ciphertext || !cipherparamsJson || !kdfparamsJson || !mac || !cipherStr || !kdfStr) {
            return nil;
        }
        self.cipher = [cipherStr lowercaseString];
        self.ciphertext = ciphertext;
        self.cipherparams = [[Cipherparams alloc] initWithJSON:cipherparamsJson];
        self.kdf = [kdfStr lowercaseString];
        self.kdfparams = [[ScryptKdfparams alloc] initWithJSON:kdfparamsJson];
        self.mac = mac;
    }
    return self;
}

-(NSDictionary *)toJSON{
    return @{@"cipher":self.cipher,
             @"ciphertext":self.ciphertext,
             @"cipherparams":[self.cipherparams toJSON],
             @"kdf":self.kdf,
             @"kdfparams":[self.kdfparams toJSON],
             @"mac":self.mac,
             };
}

-(NSString *)cipherStr:(CipherType) cipherType{
    switch (cipherType) {
        case aes128Ctr:
            return @"aes-128-ctr";
            break;
        case aes128Cbc:
            return @"aes-128-cbc";
        default:
            break;
    }
}
-(Mode)aesMode:(CipherType)cipherType{
    switch (cipherType) {
        case aes128Ctr:
            return Mode_ctr;
            break;
        case aes128Cbc:
            return Mode_cbc;
    }
}


-(NSString *)derivedKey:(NSString *)password{ //根据密码 导出 key
    NSString *str = [self.cachedDerivedKey fetch:password];
    if (str) {
        return str;
    }else{
        str = [self.kdfparams derivedKey:password];
        return str;
    }
}
-(NSString *)cachedDerivedKey:(NSString *)password{
    NSString *cached = [self.cachedDerivedKey fetch:password];
    if(cached){
        return cached;
    }else{
        NSString *key = [self derivedKey:password];
        [self.cachedDerivedKey cache:password derivedKey:key];
        return key;
    }
}
-(void)clearDerivedKey{
    [self.cachedDerivedKey clear];
}

-(AES128 *)encryptor:(NSString *)key  nonce:(NSString *)nonce{
    return [self encryptor:key nonce:nonce AESMode:nil];
}
-(AES128 *)encryptor:(NSString *)key  nonce:(NSString *)nonce AESMode:(Mode)AESMode{
    if (!AESMode) {
        AESMode = Mode_ctr;
    }
    return [[AES128 alloc] initWithKey:key iv:nonce mode:AESMode padding:ccNoPadding];
}

//ciphertext -> private key
-(NSString *)privateKey:(NSString *)password{
    NSString *cipherKey = [[self derivedKey:password] substringToIndex:32];
    NSString *hexStr = [[[AES128 alloc] initWithKey:cipherKey iv:self.cipherparams.iv mode:[self aesMode:aes128Ctr] padding:ccNoPadding] decrypt:self.ciphertext];
    NSData *privateData = [NSData hexStringToData:hexStr];
    NSString *private = [[NSString alloc] initWithData:privateData encoding:NSUTF8StringEncoding];
    return private;
}
-(NSString *)macFrom:(NSString *)password{
    return [self macForDerivedKey:[self derivedKey:password]];
}
-(NSString *)macForDerivedKey:(NSString *)key{
    NSString *cipherKey = [key substringToIndex:32];
    NSString *macHex = [NSString stringWithFormat:@"%@%@", cipherKey, self.ciphertext];
    return [[[Keccak256_bridge alloc] init] encryptWithHex:macHex];//[[[Keccak256 alloc] init] encrypt:macHex];
}


@end

#pragma mark ---- Cipherparams
@implementation Cipherparams
-(instancetype)init{
    if (self = [super init]) {
        //TODO...
        self.iv = [[NSData random:16] dataToHexString];
    }
    return self;
}
-(instancetype)initWithJSON:(NSDictionary *)json{
    if (self = [super init]) {
        NSString *str = json[@"iv"];
        if (str) {
            self.iv = str;
        }else{
            self.iv = @"";
        }
    }
    return self;
}
-(NSDictionary *)toJSON{
    return @{@"iv":self.iv};
}
@end


#pragma mark ----
static int defalutN = 262144;

@interface ScryptKdfparams()
@property(nonatomic, assign) int dklen; //预期输出长度(以派生键的八位元为单位);满足dkLen≤(232 - 1)* hLen的正整数。
@property(nonatomic, assign) int n; //CPU/memory cost parameter.
@property(nonatomic, assign) int r; //RAM cost
@property(nonatomic, assign) int p; //CPU cost
@property(nonatomic, strong) NSString *salt;
@end

@implementation ScryptKdfparams

-(instancetype)initWithSalt:(NSString *)salt{
    if (self = [super init]) {
        self.dklen = 32;
        self.n = defalutN;
        self.r = 8;
        self.p = 1;
        if (salt) {
            self.salt = salt;
        }else{
            self.salt = [[NSData random:32] dataToHexString];
        }
    }
    return self;
}
-(instancetype)initWithJSON:(NSDictionary *)json{
    if (self = [super init]) {
        NSNumber *dklenNum = json[@"dklen"];
        NSNumber *nNum = json[@"n"];
        NSNumber *rNum = json[@"r"];
        NSNumber *pNum = json[@"p"];
        NSString *salt = json[@"salt"];
        if (!(dklenNum && nNum && rNum && pNum && salt)) {
            return nil;
        }
        int dklen = [dklenNum intValue];
        int n = [nNum intValue];
        int r = [rNum intValue];
        int p = [pNum intValue];
        if (dklen != 32 || n <=0 || r <= 0 || p <= 0 || [salt isEqualToString:@""]) {
            return nil;
        }
        self.dklen = dklen;
        self.n = n;
        self.r = r;
        self.p = p;
        self.salt = salt;
    }
    return self;
}

-(NSDictionary *)toJSON{
    return @{@"dklen":@(self.dklen),
             @"n":@(self.n),
             @"r":@(self.r),
             @"p":@(self.p),
             @"salt":self.salt,
             };
}
-(NSString *)derivedKey:(NSString *)password{
    return [[[Scrypt alloc] initWith:password salt:self.salt n:self.n r:self.r p:self.p] encrypt];
}

@end

#pragma mark -----
@interface CachedDerivedKey()
@property(nonatomic, strong) NSString *hashedPassword;
@property(nonatomic, strong) NSString *derivedKey;
@end

@implementation CachedDerivedKey
-(void)cache:(NSString *)password derivedKey:(NSString *)derivedKey{
    self.hashedPassword = [self hash:password];
    self.derivedKey = derivedKey;
}
-(void)clear{
    self.hashedPassword = @"";
    self.derivedKey = @"";
}

-(NSString *)fetch:(NSString *)password{
    if ([[self hash:password] isEqualToString:self.hashedPassword]) {
        return self.derivedKey;
    }else{
        return nil;
    }
}
-(NSString *)hash:(NSString *)password{
    CocoaSecurityResult *result_sha256 = [CocoaSecurity sha256:password];
   CocoaSecurityResult *result2_sha256 = [CocoaSecurity sha256:result_sha256.hex];
    return result2_sha256.hex;
}

@end
