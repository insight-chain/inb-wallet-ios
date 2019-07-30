//
//  BIP44.h
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/6/28.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BIP44 : NSObject

+(NSString *)eth;
+(NSString *)ipfs;
+(NSString *)btcMainnet;
+(NSString *)btcTestnet;
+(NSString *)btcSegwitMainnet;
+(NSString *)btcSegwitTestnet;
+(NSString *)eos;

+(NSString *)pathFor:(Network)network segWit:(NSString *)segWit;

@end

NS_ASSUME_NONNULL_END
