//
//  Secp256k1.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/23.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>


/** 椭圆曲线 **/
NS_ASSUME_NONNULL_BEGIN

@interface Secp256k1_Insight : NSObject

/**
 *  对 message进行 签名
 * return @{@"signature":NSString, @"recid":@(int)}
 */
-(NSDictionary *)signWithKey:(NSString *)key message:(NSString *)message;

/** 从signature和message 恢复公共秘钥 **/
-(NSString *)recover:(NSString *)signature message:(NSString *)message recid:(int)recid;
-(BOOL)verify:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
