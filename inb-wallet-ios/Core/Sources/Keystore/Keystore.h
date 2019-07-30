//
//  Keystore.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/17.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Crypto.h"
#import "WalletMeta.h"

NS_ASSUME_NONNULL_BEGIN

@interface Keystore : NSObject
@property(nonatomic, strong) NSString *ID;
@property(nonatomic, assign) int       version;
@property(nonatomic, strong) NSString *address;
@property(nonatomic, strong) Crypto   *crypto;

@property(nonatomic, strong) WalletMeta *meta;

-(NSString *)dump; //转储
-(NSDictionary *)toJSON;
-(NSDictionary *)serializeToMap; //序列化
-(BOOL)verify:(NSString *)password;

-(NSDictionary *)getStardandJSON;
-(NSString *)decryptPrivateKey:(NSString *)password;
-(NSString *)prettyJSON:(NSDictionary *)json;

-(NSString *)exportToString;

+(NSString *)generateKeystoreId;

@end



#pragma mark ---- PrivateKeyCrypto
@interface PrivateKeyCrypto : Keystore

-(NSString *)decryptPrivateKey:(NSString *)passwod;

@end

@protocol WIFCrypto <NSObject>

-(NSString *)decryptWIF:(NSString *)password;

@end

NS_ASSUME_NONNULL_END
