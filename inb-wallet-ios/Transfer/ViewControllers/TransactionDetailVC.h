//
//  TransactionDetailVC.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/18.
//  Copyright © 2019 apple. All rights reserved.
//
/**
 *  交易详情 控制器
 */
#import <UIKit/UIKit.h>
#import "TransferModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TransactionDetailVC : UIViewController
@property(nonatomic, strong) TransferModel *tranferModel;
@end

NS_ASSUME_NONNULL_END
