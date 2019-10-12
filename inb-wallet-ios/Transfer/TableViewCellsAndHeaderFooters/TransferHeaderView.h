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

#pragma mark ---- 节点投票的头
@interface TransferHeaderVoteView : UIView
@property(nonatomic, strong) UILabel *titleLabel; //节点投票
@property(nonatomic, strong) UILabel *infoLabel;  //投票的节点地址
@property (nonatomic, assign, readonly) double viewHeight;  //高度

-(instancetype)initWithTitle:(NSString *)title info:(NSString *)info;

@end

NS_ASSUME_NONNULL_END
