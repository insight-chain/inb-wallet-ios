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

//local,本地联调地址
static NSString *hostUrl_local = @"http://test.insightchain.io/api-test/";
static NSString *rpcUrl_local = @"http://192.168.1.184:6001";
static NSString *webUrl_local = @"http://explorertestapi.insightchain.io/#/";
static NSString *explorUrl_local = @"http://192.168.1.181:8383/v1/";

//正式服务器
static NSString *hostUrl_production_default = @"http://test.insightchain.io/api-test/";
static NSString *rpcUrl_production_default = @"http://192.168.1.185:6001";
static NSString *webUrl_production_default = @"http://explorer.insightchain.io/#/";
static NSString *explorUrl_production_default = @"http://explorer.insightchain.io/v1/";

//测试服务器
static NSString *hostUrl_test_default = @"http://test.insightchain.io/api-test/";//测试服务器
static NSString *rpcUrl_test_default = @"http://192.168.1.185:6001";
static NSString *webUrl_test_default = @"http://explorertestapi.insightchain.io/#/";
static NSString *explorUrl_test_default = @"http://explorertestapi.insightchain.io/v1/";

static NSString *inbPriceUrl = @"coin/inb"; //INB最新价格

#define HTTP(host, path) [NSString stringWithFormat:@"%@%@", host, path]

static int kChainID = 891;//903;//1314520;

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
