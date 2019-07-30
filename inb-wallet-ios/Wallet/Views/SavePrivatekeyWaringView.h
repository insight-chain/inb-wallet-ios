//
//  SavePrivatekeyWaringView.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/24.
//  Copyright © 2019 apple. All rights reserved.
//
/**
 *  保存私钥 警告
 */
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SavePrivatekeyWaringView : UIView

+(void)showSaveWaringWith:(void(^)(void))konwBlock;

@end

NS_ASSUME_NONNULL_END
