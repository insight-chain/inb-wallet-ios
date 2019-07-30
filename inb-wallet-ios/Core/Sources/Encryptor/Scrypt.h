//
//  Scrypt.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/20.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Scrypt : NSObject

-(instancetype)initWith:(NSString *)password salt:(NSString *)salt n:(int)n r:(int)r p:(int)p;

-(NSString *)encrypt;

@end

NS_ASSUME_NONNULL_END
