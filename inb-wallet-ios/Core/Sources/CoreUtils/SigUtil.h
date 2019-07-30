//
//  SigUtil.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/30.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SigUtil : NSObject

/**
 *  @return @{@"v":integer, @"r":String, @"s":String}
 */
+(NSDictionary *)personalSign:(NSString *)privateKey msgParams:(NSDictionary *)msgParams;
+(NSArray<NSDictionary *>*)batchEcsign:(NSString *)privateKey data:(NSArray<NSString *>*)data;
+(NSDictionary *)ecsignWith:(NSString *)privateKey data:(NSString *)data;
+(NSString *)ecrecover:(NSString *)signature recid:(uint32_t)recid msgHash:(NSString *)msgHash;
+(NSString *)hashPersonalMessage:(NSString *)msg;

+(NSString *)concatSigWithV:(uint32_t)v r:(NSString *)r s:(NSString *)s;
+(NSString *)concatSigWithV:(uint32_t)v rs:(NSString *)rs;

+(NSDictionary *)unpackSig:(NSString *)sig;
+(NSString *)calcIPFSIDFromKey:(BTCKey *)key;


@end

NS_ASSUME_NONNULL_END
