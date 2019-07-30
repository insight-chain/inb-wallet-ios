//
//  NodeInfoVC.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/6.
//  Copyright © 2019 apple. All rights reserved.
//
/**
 * 节点信息 控制器
 */
#import <UIKit/UIKit.h>
#import "Node.h"

NS_ASSUME_NONNULL_BEGIN

@class BasicWallet;

@interface NodeInfoVC : UIViewController
@property(nonatomic, strong) Node *node;

@property(nonatomic, strong) NSMutableArray *selectedNodes;
@property(nonatomic, assign) NSInteger totalNode; 
@property(nonatomic, strong) BasicWallet *wallet;
@end

NS_ASSUME_NONNULL_END
