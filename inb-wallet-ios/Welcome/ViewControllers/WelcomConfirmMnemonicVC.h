//
//  WelcomConfirmMnemonicVC.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/30.
//  Copyright © 2019 apple. All rights reserved.
//
/**
 * 确认助记词VC
 */
#import <UIKit/UIKit.h>
#import "PassphraseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WelcomConfirmMnemonicVC : UIViewController
@property(nonatomic, strong) NSArray *menmonryWords;
@end

#pragma mark ---- ContetTopView
@interface ContentTopView: UIView
@property(nonatomic, strong) PassphraseView *contentView;
@end

NS_ASSUME_NONNULL_END
