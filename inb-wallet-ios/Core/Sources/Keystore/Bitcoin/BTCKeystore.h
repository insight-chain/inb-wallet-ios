//
//  BTCKeystore.h
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/6/28.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Keystore.h"
#import "Crypto.h"
#import "WalletMeta.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTCKeystore: Keystore <WIFCrypto>

//@property(nonatomic, copy) NSString *ID;
//@property(nonatomic, assign) int version;
//@property(nonatomic, copy) NSString *address;
//@property(nonatomic, strong) Crypto *crypto;
//@property(nonatomic, strong) WalletMeta *meta;

//Import with private key (WIF).
-(instancetype)initWithPassword:(NSString *)password wif:(NSString *)wif metadata:(WalletMeta *)metadata ID:(NSString *)ID;
-(instancetype)initWithJSON:(NSDictionary *)json;

-(NSString *)decryptWIF:(NSString *)password;
-(NSDictionary *)serializeToMap;

-(NSString *)dump;
-(NSDictionary *)toJSON;

@end

NS_ASSUME_NONNULL_END
