//
//  NodeRegisterVC.h
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/7/17.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//
/**
 * 节点注册
 */
#import "ViewController.h"
#import "Node.h"
#import "BasicWallet.h"

NS_ASSUME_NONNULL_BEGIN

@interface NodeRegisterVC : ViewController
@property(nonatomic, strong) BasicWallet *wallet;
@property(nonatomic, strong) Node *node;
@end


#pragma mark ---- 信息view
@interface InfoView : UIView
@property(nonatomic, strong) UIImage *img;
@property(nonatomic, strong) UILabel *title;
@property(nonatomic, strong) UITextField *info;
@end

NS_ASSUME_NONNULL_END
