//
//  PasswordInputView.h
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/6/17.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PasswordInputView : UIView

+(instancetype)showPasswordInputWithConfirmClock:(void(^)(NSString *password))confirmBlock;

-(void)hidePasswordInput;
@end

NS_ASSUME_NONNULL_END
