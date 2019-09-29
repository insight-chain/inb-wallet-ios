//
//  TransferModel.h
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/7/8.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//
/**
 * 交易数据模型
 */
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TransferModel : NSObject
@property(nonatomic, strong) NSString *blockNumber; //区块号
@property(nonatomic, strong) NSString *blockHash;   //区块hash
@property (nonatomic, assign) NSInteger blockId;


@property(nonatomic, strong) NSString *tradingHash; //交易hash
@property(nonatomic, assign) double timestamp; // 交易创建时间
@property(nonatomic, strong) NSString *from;        //发送地址
@property(nonatomic, strong) NSString *to;          //接收地址
@property(nonatomic, assign) double amount;         //交易数值
@property(nonatomic, strong) NSString *input;       //数据
@property(nonatomic, strong) NSString *bindwith;    //消耗net
@property(nonatomic, assign) TxType type;              //交易类型：1、转账 2、抵押 3、解抵押 4、投票
@property(nonatomic, assign) int direction;         //当前地址交易方向：1、为from 2、为to
@property(nonatomic, assign) int status;            //交易状态：1、成功 2、失败

@property (nonatomic, strong) NSArray *transactionLog; //内联交易数组

@end


@interface InlineTransfer:NSObject
@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) double amount;
@property (nonatomic, strong) NSString *blockHash;
@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSString *to;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, assign) BOOL removed;
@property (nonatomic, assign) double timestamp;

@property (nonatomic, strong) NSString *inlineTransactionHash;
@property (nonatomic, strong) NSString *transactionHash;

@property (nonatomic, assign) NSInteger transactionIndex;
@property (nonatomic, assign) NSInteger transactionType;

@end

NS_ASSUME_NONNULL_END
