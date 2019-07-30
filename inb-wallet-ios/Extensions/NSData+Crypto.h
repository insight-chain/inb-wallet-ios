//
//  NSData+Crypto.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/3/31.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Crypto.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSData (Crypto)

//两个RFC-4880的格式的八位校验和, 所有的八位和，模65536
-(UInt16)checksum;

-(NSData *)md5;
-(NSData *)sha1;
-(NSData *)sha224;
-(NSData *)sha256;
-(NSData *)sha384;
-(NSData *)sha512;
//-(NSData *)sha3:(NSInteger)variant;
-(NSData *)crc32:(UInt32)seed reflect:(BOOL)reflect;
-(NSData *)crc32c:(UInt32)seed reflect:(BOOL)reflect;
-(NSData *)crc16:(UInt16)seed;

@end

NS_ASSUME_NONNULL_END
