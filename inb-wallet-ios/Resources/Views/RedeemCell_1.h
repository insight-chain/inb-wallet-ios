//
//  RedeemCell_1.h
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/9/2.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//
/**
 * 正在赎回cell
 */
#import <UIKit/UIKit.h>

typedef void(^ReceiveBlock)();

NS_ASSUME_NONNULL_BEGIN

@interface RedeemCell_1 : UITableViewCell

@property (nonatomic, assign) double value;//值
@property (nonatomic, assign) double time; //领取时间戳

@property (nonatomic, copy) ReceiveBlock receiveBlock;

@end

NS_ASSUME_NONNULL_END
