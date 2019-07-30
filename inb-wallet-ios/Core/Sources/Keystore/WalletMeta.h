//
//  WalletMeta.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/17.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

static NSString *key = @"insightTokenMeta";

@interface WalletMeta : NSObject

@property(nonatomic, strong) NSString *key; //"imTokenMeta"
@property(nonatomic, strong) NSString *mode; //

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *passwordHint; //密码提示
@property(nonatomic, assign) ChainType chainType;
@property(nonatomic, strong) NSString *chain;
@property(nonatomic, assign) SourceType sourceType;
@property(nonatomic, strong) NSString *source; //""
@property(nonatomic, strong) NSString *segWit;

@property(nonatomic, assign) double    timestamp;
@property(nonatomic, strong) NSString *version;
@property(nonatomic, strong) NSArray<NSString*> *backup;
@property(nonatomic, assign) Network network;

@property(nonatomic, assign) BOOL isSegWit;
@property(nonatomic, assign) BOOL isMainnet;

-(instancetype)initWith:(SourceType)source;
-(instancetype)initWith:(ChainType)chain source:(SourceType )source network:(Network)network;
-(instancetype)initWithChainStr:(NSString *)chainStr sourceStr:(NSString *)sourceStr;
-(instancetype)initWithJSON:(NSDictionary *)json;

-(WalletMeta *)mergeMetaName:(NSString *)name chainType:(ChainType)chainType;
-(NSDictionary *)toJSON;


+(NSString *)getKey;

+(NSString *)getSourceStr:(SourceType)type;
+(SourceType)getSourceType:(NSString *)str;
+(ChainType)getChainType:(NSString *)str;
+(NSString *)getChainStr:(ChainType) chain;

@end

NS_ASSUME_NONNULL_END
