//
//  ETHKey.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/21.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ETHKey : NSObject
@property(nonatomic, strong) NSString *privateKey;//For user daily use, adress/privateKey, via path "m/44'/60'/0'/0/index"
@property(nonatomic, strong) NSString *address;

-(instancetype)initWithPrivateKey:(NSString *)privateKey;
-(instancetype)initWithSeed:(NSData *)seed path:(NSString *)path;
-(instancetype)initWithMnemonic:(NSString *)mnemonic path:(NSString *)path;

+(NSString *)mnemonicToAddress:(NSString *)menmonic path:(NSString *)path;
+(NSString *)pubToAddress:(NSData *)publicKey;

@end

NS_ASSUME_NONNULL_END
