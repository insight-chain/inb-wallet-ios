//
//  Mnemonic.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/22.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ETHMnemonic : NSObject
@property(nonatomic, strong) NSString *mnemonic;
@property(nonatomic, strong) NSString *seed;

-(instancetype)init;
-(instancetype)initWithMnemonic:(NSString *)mnemonic passphrase:(NSString *)passphrase;
-(instancetype)initWithSeed:(NSString *)seed;


+(NSString *)generate:(NSString *)seed;
+(NSString *)deterministicSeed:(NSString *)mnemonic passphrase:(NSString *)passphrase;
//strength: 可以被32整除
+(NSString *)generateSeed:(int)strength;

@end

NS_ASSUME_NONNULL_END
