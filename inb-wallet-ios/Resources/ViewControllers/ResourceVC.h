//
//  ResourceVC.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/8.
//  Copyright © 2019 apple. All rights reserved.
//
/**
 * 资源 VC
 */
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ResourceVC : UIViewController

@property(nonatomic, copy) NSString *walletID;
@property(nonatomic, strong) NSString *address;

@property(nonatomic, assign) double canUseNet; //net的可用量
@property(nonatomic, assign) double totalNet; // net的总量
@property(nonatomic, assign) double mortgageINB;//抵押的INB量

@end

NS_ASSUME_NONNULL_END
