//
//  Secp256k1.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/23.
//  Copyright © 2019 apple. All rights reserved.
//

#import "Secp256k1_Insight.h"
#import "NSData+HexString.h"
//#import "secp256k1.swift-umbrella.h"
#import "secp256k1.h"
#import "secp256k1_ecdh.h"
#import "secp256k1_recovery.h"

@interface Secp256k1_Insight()

@property(nonatomic, assign) int signatureLength;
@property(nonatomic, assign) int keyLength;

@end

@implementation Secp256k1_Insight

-(BOOL)verify:(NSString *)key{
    if (key.length != self.keyLength || ![self isHex:key]) {
        return NO;
    }
    
    secp256k1_context *context = secp256k1_context_create((UInt32)SECP256K1_CONTEXT_VERIFY);
    
    NSData *data = [NSData hexStringToData:key];
    if (data) {
        if (data.length == 32 && secp256k1_ec_seckey_verify(context, data.bytes) == 1) {
            secp256k1_context_destroy(context);
            return YES;
        }else{
            secp256k1_context_destroy(context);
            return NO;
        }
        
    }else{
        secp256k1_context_destroy(context);
        return NO;
    }
    
}

-(BOOL)isHex:(NSString *)str{
    if([str hasPrefix:@"0x"]){
        return [self isHex:[str substringFromIndex:2]];
    }
    
    if (str.length % 2 != 0) {
        return NO;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[A-Fa-f0-9]+$"];
    return [predicate evaluateWithObject:str];
}

-(int)signatureLength{
    return 64;
}

/**
 *  对 message进行 签名
 * return @{@"signature":NSString, @"recid":@(int)}
 */
-(NSDictionary *)signWithKey:(NSString *)key message:(NSString *)message{
    NSData *keyData = [self dataFromHexString:key]; 
    NSData *messageData = [self dataFromHexString:message];
    if (!(keyData && messageData)) {
        @throw Exception(@"Secp256k1", @"failureSignResult");
    }
    
    secp256k1_context *context = secp256k1_context_create((UInt32)(SECP256K1_CONTEXT_SIGN | SECP256K1_CONTEXT_VERIFY));
    
    if (secp256k1_ec_seckey_verify(context, keyData.bytes) != 1) {
        secp256k1_context_destroy(context);
        @throw Exception(@"Secp256k1", @"failureSignResult");
    }
    secp256k1_ecdsa_recoverable_signature sig;
    if(secp256k1_ecdsa_sign_recoverable(context, &sig, messageData.bytes, keyData.bytes, secp256k1_nonce_function_rfc6979, nil) == 0){
        secp256k1_context_destroy(context);
        @throw Exception(@"Secp256k1", @"failureSignResult");
    }
    NSMutableData *data = [NSMutableData dataWithLength:self.signatureLength];
    int recid;
    secp256k1_ecdsa_recoverable_signature_serialize_compact(context, data.mutableBytes, &recid, &sig);
    
    secp256k1_context_destroy(context);
    return @{@"signature":[data dataToHexString],
             @"recid":@(recid),
             };
}

/// Recover public key from signature and message.
/// - Parameter signature: Signature.
/// - Parameter message: Raw message before signing.
/// - Parameter recid: recid.
/// - Returns: Recoverd public key.
-(NSString *)recoverSignature:(NSString *)signature message:(NSString *)message recid:(int32_t)recid{
    NSData *signData = [self dataFromHexString:signature];
    NSData *messageData = [self dataFromHexString:message];
    if (!signature || !message) {
        return nil;
    }
    secp256k1_context *context = secp256k1_context_create((UInt32)(SECP256K1_CONTEXT_SIGN | SECP256K1_CONTEXT_VERIFY));
    
    secp256k1_ecdsa_recoverable_signature sig;
    secp256k1_ecdsa_recoverable_signature_parse_compact(context, &sig, signData.bytes, recid);
    
    secp256k1_pubkey publickKey;
    int32_t result = 0;
    result = secp256k1_ecdsa_recover(context, &publickKey, &sig, messageData.bytes);
    
    if (result == 0) {
        secp256k1_context_destroy(context);
        return nil;
    }
    
    int length = 65;
    NSMutableData *data = [NSMutableData dataWithLength:length];
    result = secp256k1_ec_pubkey_serialize(context, data.mutableBytes, &length, &publickKey, (UInt32)SECP256K1_EC_UNCOMPRESSED);
    if (result == 0) {
        secp256k1_context_destroy(context);
        return nil;
    }
    NSString *pubKeyStr = [data dataToHexString];
    secp256k1_context_destroy(context);
    return pubKeyStr;
    
}

/// Verify a key.
/// - Parameter key: Key in hex format.
/// - Returns: true if verified, otherwise return false.
-(BOOL)verifyKey:(NSString *)key{
    if (key.length != self.keyLength) {
        return NO;
    }
    secp256k1_context *context = secp256k1_context_create((UInt32)(SECP256K1_CONTEXT_VERIFY));
    
    NSData *data = [self dataFromHexString:key];
    if (!data) {
        secp256k1_context_destroy(context);
        return NO;
    }
    
    BOOL bbb = data.length == 32 && secp256k1_ec_seckey_verify(context, data.bytes) == 1;
    secp256k1_context_destroy(context);
    return bbb;
}


-(NSData *)dataFromHexString:(NSString *)hex{
    if ([hex hasPrefix:@"0x"]) {
        hex = [hex substringFromIndex:2];
    }
    return [NSData hexStringToData:hex];
}
@end
