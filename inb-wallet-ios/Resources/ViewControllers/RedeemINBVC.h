//
//  RedeemINBVC.h
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/9/10.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//
/** 赎回抵押，输入INB数量 **/
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RedeemINBVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *inbTF;
@property (weak, nonatomic) IBOutlet UILabel *canUseL; //可赎回 100 INB

@property (nonatomic, assign) double canTotal; //可用

@end

NS_ASSUME_NONNULL_END
