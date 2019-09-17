//
//  RedeemCell_2.h
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/9/2.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//
/**
 * 抵押列表cell
 */
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^RewardBlock)(void);

@interface RedeemCell_2 : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *rewardLable; // 抵押奖励
@property (weak, nonatomic) IBOutlet UILabel *receiveTimeLabel;//领取计时，24小时以为显示 "23小时候领取"

@property (weak, nonatomic) IBOutlet UIButton *receiveBtn; //领取按钮
@property (weak, nonatomic) IBOutlet UILabel *mortgageValueLabel;//抵押数量
@property (weak, nonatomic) IBOutlet UILabel *rate_7Label; //七日年化
@property (weak, nonatomic) IBOutlet UIButton *stateBtn; //状态

@property (nonatomic, copy) RewardBlock rewardBlock; //领取/赎回奖励

@end

NS_ASSUME_NONNULL_END
