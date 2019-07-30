//
//  TransferHeaderView.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/18.
//  Copyright © 2019 apple. All rights reserved.
//
/**
 * 转账（收款、支付）
 */
#import <UIKit/UIKit.h>
#import "PaddingLabel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TransferHeaderView : UIView
@property(nonatomic, strong) UILabel *resultLabel; //“转账成功”
@property(nonatomic, strong) PaddingLabel *valueLabel;   //转账金额
@end

NS_ASSUME_NONNULL_END
