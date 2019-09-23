//
//  NetworkUtil.h
//  test
//
//  Created by insightChain_iOS开发 on 2019/6/11.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *cdnUrl_local = @"http://cdn.imalljoy.com/insight/config/local.json";
static NSString *cdnUrl_test = @"http://file.inbhome.com/insight/config/test.json";
static NSString *cdnUrl_production = @"http://cdn.imalljoy.com/insight/config/production.json";



static NSString *hostUrl_211 = @"http://192.168.1.211:8080/inb-api-version/";    //211
static NSString *hostUrl_production = @"http://api.insightchain.io/";    //正式服务器
static NSString *hostUrl_test = @"http://test.insightchain.io/api-test/";//测试服务器

static NSString *inbPriceUrl = @"coin/inb"; //INB最新价格

static NSString *rpcHost = @"http://192.168.1.183:6001"; //@"http://192.168.1.183:6001";

#define HTTP(host, path) [NSString stringWithFormat:@"%@%@", host, path]

static int kChainID = 903;//891;//1314520;

static NSString *getAccountInfo_MethodName = @"inb_getAccountInfo";
static NSString *sendTran_MethodName   = @"inb_sendRawTransaction";  //发送交易的 method
static NSString *mortgage_MethodName   = @"inb_mortgageRawNet";      //抵押的 method
static NSString *unMortgage_MethodName = @"inb_unMortgageRawNet";    //解抵押的method
static NSString *nonce_MethodName      = @"inb_getTransactionCount"; //获取当前的nonce 的 method
static NSString *blockNumber_MethodName= @"inb_blockNumber"; //获取当前区块高度

@interface NetworkUtil : NSObject

+(void)getRequest:(NSString *)urlStr params:(NSDictionary *)params success:(void(^)(id resonseObject))successBlock failed:(void(^)(NSError *error))failedBlock;
+(void)postRequest:(NSString *)urlStr params:(NSDictionary *)params success:(void(^)(id resonseObject))successBlock failed:(void(^)(NSError *error))failedBlock;


+(void)rpc_requetWithURL:(NSString *)url params:(NSDictionary *)params completion:(void(^)(id  _Nullable responseObject, NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
