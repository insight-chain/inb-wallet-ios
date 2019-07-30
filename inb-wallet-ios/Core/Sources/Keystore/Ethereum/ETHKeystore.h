//
//  ETHKeystore.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/21.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Keystore.h"
#import "Crypto.h"
#import "WalletMeta.h"

NS_ASSUME_NONNULL_BEGIN

@interface ETHKeystore : PrivateKeyCrypto

//import from private key
-(instancetype)initWith:(NSString *)password privatedKey:(NSString *)privatedKey metadata:(WalletMeta *)metadata ID:(NSString *)ID;
-(instancetype)initWithJSON:(NSDictionary *)json;

-(NSDictionary *)serializeToMap;



@end

NS_ASSUME_NONNULL_END
