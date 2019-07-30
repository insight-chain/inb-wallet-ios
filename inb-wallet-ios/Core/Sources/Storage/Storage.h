
//
//  Storage.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/22.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Identity.h"
#import "BasicWallet.h"
#import "IdentityKeystore.h"
#import "Keystore.h"

NS_ASSUME_NONNULL_BEGIN

@protocol Storage <NSObject>

-(Identity *)tryLoadIdentity;
-(NSArray<BasicWallet *> *)loadWalletByIDs:(NSArray *)walletIDs;
-(BOOL)deleteWalletByID:(NSString *)walletID;
-(BOOL)cleanStorage;
-(BOOL)flushIdentity:(IdentityKeystore *)keystore;
-(BOOL)flushWallet:(Keystore *)keystore;

@end

NS_ASSUME_NONNULL_END
