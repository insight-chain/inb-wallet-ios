//
//  WalleInfoCPUView.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/3.
//  Copyright © 2019 apple. All rights reserved.
//
/**
 * CPU资源view
 */
#import <UIKit/UIKit.h>
@class WalletInfoViewModel;

typedef void(^AddMortgageBlock)(void);
typedef void(^ToMortgageRecordBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface WalletInfoCPUView : UIView

@property(nonatomic, strong) UILabel *remainingValue; //net 可用量
@property(nonatomic, strong) UILabel *totalValue; // net总量
@property(nonatomic, strong) UILabel *mortgageValue; // 抵押的INB量

@property(nonatomic, copy) AddMortgageBlock addMortgageBlock;
@property(nonatomic, copy) ToMortgageRecordBlock toMortgageBlock;

-(instancetype)initWithViewModel:(WalletInfoViewModel *)viewModel;

-(void)updataNet;
@end

NS_ASSUME_NONNULL_END
