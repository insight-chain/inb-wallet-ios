//
//  Enum.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/9.
//  Copyright © 2019 apple. All rights reserved.
//

#ifndef Enum_h
#define Enum_h

#import <UIKit/UIKit.h>
/**
 * 钱包首页功能
 */
typedef NS_ENUM(NSInteger, FunctionType){
    FunctionType_transfer = 101, //转账
    FunctionType_collection,   //收款
    FunctionType_node, //节点
    FunctionType_scan, //扫码
    FunctionType_vote, //投票
    FunctionType_record, //交易记录
    FunctionType_backup, //备份
};
/**
 * 导入钱包类型
 */
typedef NS_ENUM(NSInteger, ImportType){
    ImportType_private = 1, //私钥导入
    ImportType_mnemonic,    //助记词导入
};

typedef NS_ENUM(NSInteger, ChainType){
    chain_insight = 1,
    chain_eth     = 2, //"ETHEREUM"
    chain_btc     = 3, //"BITCOIN"
    chain_eos     = 4, //"EOS"
};
typedef NS_ENUM(NSInteger, SourceType) {
    source_newIdentity      = 0, //"NEW_IDENTITY"
    source_recoverdIdentity = 1, //"RECOVERED_IDENTITY"
    source_privateKey       = 2, //"PRIVATE"
    source_wif              = 3, //"WIF"
    source_keystore         = 4, //"KEYSTORE"
    source_mnemonic         = 5, //"MNEMONIC"
};
typedef NS_ENUM(NSInteger, DefaultVersion) {
    defaultVersion_btnMnemonicKeystore = 44,
    defaultVersion_identityKeystore = 1000,
    defaultVersion_eosKeystore = 10001,
};

typedef NS_ENUM(NSInteger, NetworType) {
    network_mainnet,
    network_testnet,
};
/** 交易类型 **/
typedef NS_ENUM(NSInteger, TradingType){ //1、转账 2、抵押 3、解抵押 4、投票
    tradingType_transfer = 1,
    tradingType_mortgage = 2,
    tradingType_unMortgage = 3,
    tradingType_vote = 4,
};
/** 服务器类型 **/
typedef NS_ENUM(NSInteger, RootNetType) {
    rootNet_production, //正式
    rootNet_test,
    rootNet_local,
    rootNet_
};
#endif /* Enum_h */
