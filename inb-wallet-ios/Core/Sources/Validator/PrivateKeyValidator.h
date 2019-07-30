//
//  PrivateKeyValidator.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/23.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface PrivateKeyValidator : NSObject

-(instancetype)initWithPrivateKey:(NSString *)privateKey chain:(ChainType)chain network:(Network )network requireCompressed:(BOOL)requireCompressed;

-(BOOL)isValid;
-(NSString *)validate;
-(NSString *)validateBtc;
-(NSString *)validateEth;
-(NSString *)validateEos;

@end

NS_ASSUME_NONNULL_END
