//
//  LockModel.h
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/9/11.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//
/** 锁仓model **/
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LockModel : NSObject

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, strong) NSString *address;

@property (nonatomic, assign) NSInteger days;
@property (nonatomic, assign) NSInteger nonce;

@property (nonatomic, strong) NSString *received; //领取过d
@property (nonatomic, strong) NSString *amount;   //锁仓的值

@property (nonatomic, assign) double startTime;
@property (nonatomic, assign) double lastReceivedTime;
@property (nonatomic, assign) double timestamp;

@end

NS_ASSUME_NONNULL_END
