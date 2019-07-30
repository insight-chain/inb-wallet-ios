//
//  VoteDetailVC.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/23.
//  Copyright © 2019 apple. All rights reserved.
//
/**
 * 投票详情
 */
#import <UIKit/UIKit.h>
#import "BasicWallet.h"

NS_ASSUME_NONNULL_BEGIN

@interface VoteDetailVC : UIViewController



@property(nonatomic, strong) NSMutableArray *selectedNode;
@property(nonatomic, assign) NSInteger totalNodeCount;
@property(nonatomic, strong) BasicWallet *wallet;
@end

NS_ASSUME_NONNULL_END
