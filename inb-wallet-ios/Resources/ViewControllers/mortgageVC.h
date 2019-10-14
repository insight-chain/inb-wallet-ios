//
//  mortgageVC.h
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/9/2.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//
/**
 * 抵押
 */
#import "BaseTableViewVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface mortgageVC : BaseTableViewVC

@property(nonatomic, copy) NSString *walletID;
@property(nonatomic, copy) NSString *address;
@property (nonatomic, assign) NSInteger lockingNumber; //正在锁仓的数量
@end




NS_ASSUME_NONNULL_END


