//
//  VoteDetailHeaderView.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/23.
//  Copyright © 2019 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VoteDetailHeaderView : UIView

@property(nonatomic, assign) double mortgageINB; //已抵押的INB
@property(nonatomic, assign) double balanceINB;  // 余额

@property(nonatomic, strong) UILabel *voteTotalValue; // 99.00

@property(nonatomic, copy) void(^addMortgageBlock)(double inbNumber);

@end

NS_ASSUME_NONNULL_END
