//
//  ETHMnemonicKeystore.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/23.
//  Copyright © 2019 apple. All rights reserved.
//

#import "Keystore.h"
#import "EncryptedMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface ETHMnemonicKeystore : PrivateKeyCrypto

@property(nonatomic, strong) EncryptedMessage *encMnemonic;
@property(nonatomic, strong) NSString *mnemonicPath;

-(instancetype)initWithPassword:(NSString *)password mnemonic:(NSString *)mnemonic path:(NSString *)path metadata:(WalletMeta *)metadata ID:(NSString *)ID;
-(instancetype)initJSON:(NSDictionary *)json;

-(NSDictionary *)toJSON;
-(NSDictionary *)serializeToMap;

-(NSString *)exportKeystore;

-(NSString *)decryptMnemonic:(NSString *)password;

@end

NS_ASSUME_NONNULL_END
