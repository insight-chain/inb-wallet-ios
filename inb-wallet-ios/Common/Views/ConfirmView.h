//
//  ConfirmView.h
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/10/28.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 * 二次确认view
 */

typedef void(^CancelAction)(void);
typedef void(^ConfirmAction)(void);
NS_ASSUME_NONNULL_BEGIN

@interface ConfirmView : UIView

//创建订单
+(instancetype)transferConfirmWithTitle:(NSString *)title toAddr:(NSString *)toAddr value:(double)value note:(NSString *)note confirm:(ConfirmAction)confirm cancel:(CancelAction)cancel;
//创建锁仓
+(instancetype)lockConfirmWithTitle:(NSString *)title value:(double)value lockNumber:(NSInteger)lockNumber confirm:(ConfirmAction)confirm cancel:(CancelAction)cancel;
//创建赎回
+(instancetype)redeemConfirmWithTitle:(NSString *)title addr:(NSString *)addr value:(double)value confirm:(ConfirmAction)confirm cancel:(CancelAction)cancel;
//创建投票
+(instancetype)voteConfirmWithTitle:(NSString *)title nodeName:(NSArray *)names value:(NSInteger)value confirm:(ConfirmAction)confirm cancel:(CancelAction)cancel;
@end

#pragma mark ---- 转账view
@interface TransferView:UIView
@property (nonatomic, readonly) double viewHeight;

-(instancetype)initWithNumber:(double)number toAddr:(NSString *)toAddr note:(NSString *)note;
@end

#pragma mark ---- 锁仓view
@interface LockView:UIView
@property (nonatomic, readonly) double viewHeight;

-(instancetype)initWithNumber:(double)number lockNumber:(NSInteger)lockNumber;

@end

#pragma mark ---- 赎回view
@interface RedeemView:UIView
@property (nonatomic, readonly) double viewHeight;

-(instancetype)initWithNumber:(double)number addr:(NSString *)addr;

@end

#pragma mark ---- 投票view
@interface VoteView:UIView
@property (nonatomic, readonly) double viewHeight;

-(instancetype)initWithNodeNames:(NSArray *)names voteNumber:(NSInteger)voteNumber;

@end

NS_ASSUME_NONNULL_END
