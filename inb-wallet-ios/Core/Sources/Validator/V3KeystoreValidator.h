//
//  V3KeystoreValidator.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/6/1.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface V3KeystoreValidator : NSObject
-(instancetype)initWithKeystore:(NSDictionary *)keystore;

-(BOOL)isValid;
-(NSDictionary *)validate;

@end

NS_ASSUME_NONNULL_END
