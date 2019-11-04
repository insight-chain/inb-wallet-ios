//
//  TransferResultView.h
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/10/29.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TransferResultView : UIView
+(instancetype)resultFailedWithTitle:(NSString *)title message:(NSString *)message;
+(instancetype)resultSuccessLockWithTitle:(NSString *)title value:(double)value lcokNumber:(NSInteger)lockNumber;
+(instancetype)resultSuccessVoteWithTitle:(NSString *)title voteNumber:(NSInteger)voteNumber voteNames:(NSArray *)names;
+(instancetype)resultSuccessRedeemWithTitle:(NSString *)title value:(double)value;//赎回成功
+(instancetype)resultSuccessRewardWithTitle:(NSString *)title value:(double)value; //（锁仓、投票）奖励领取
+(instancetype)QRViewWithTitle:(NSString *)title value:(NSString *)value;//显示二维码
@end

NS_ASSUME_NONNULL_END
