//
//  Hash.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/30.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Hash : NSObject

+(NSData *)hmacSHA256WithKey:(NSData *)key data:(NSData *)data;
+(NSData *)merkleRoot:(NSData *)cipherData;
@end

NS_ASSUME_NONNULL_END
