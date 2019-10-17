//
//  SuspendTopPausePageVC.h
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/10/17.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "YNPageViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SuspendTopPausePageVC : YNPageViewController

@property(nonatomic, copy) NSString *walletID;
@property(nonatomic, strong) NSString *address;

@property(nonatomic, assign) double canUseNet; //net的可用量
@property(nonatomic, assign) double totalNet; // net的总量
@property(nonatomic, assign) double mortgageINB;//抵押的INB量

+ (instancetype)suspendTopPausePageVC;
@end

NS_ASSUME_NONNULL_END
