//
//  Keccak256.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/21.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Keccak256 : NSObject

-(instancetype)init;

-(NSString *)encrypt:(NSString *)hex;
-(NSString *)encryptData:(NSData *)data;
@end

NS_ASSUME_NONNULL_END
