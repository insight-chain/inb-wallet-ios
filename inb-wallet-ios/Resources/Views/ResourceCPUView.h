//
//  ResourceCPUView.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/8.
//  Copyright © 2019 apple. All rights reserved.
//
/**
 *  CPU资源View
 */
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ResourceCPUView : UIView
@property(nonatomic, strong) UILabel *balanceValue; //NET 可用量
@property(nonatomic, strong) UILabel *totalValue;   // NET 总量
@property(nonatomic, strong) UILabel *mortgageValue; //抵押的INB值
@property(nonatomic, strong) UILabel *redemptionValue; //赎回的值

-(void)updataProgress; //更新进度条

@end

NS_ASSUME_NONNULL_END
