//
//  AES128.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/21.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, Mode){
    Mode_ctr = 0,
    Mode_cbc,
    
};

@interface AES128 : NSObject

-(instancetype)initWithKey:(NSString *)key iv:(NSString *)iv mode:(Mode)mode padding:(CCPadding)padding;

-(NSString *)encrypt:(NSString *)string;
-(NSString *)encryptHexString:(NSString *)hex;

-(NSString *)decrypt:(NSString *)hex;

@end

NS_ASSUME_NONNULL_END
