//
//  IdentityValidator.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/6/1.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Identity;

NS_ASSUME_NONNULL_BEGIN

@interface IdentityValidator : NSObject

-(instancetype)initWithIdentifier:(NSString *)identifier;

-(Identity *)validate;
-(BOOL)isValid;

@end

NS_ASSUME_NONNULL_END
