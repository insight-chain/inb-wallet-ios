//
//  MnemonicUtil.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/23.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MnemonicUtil : NSObject
+(BTCMnemonic *)btnMnemonicFromEngWords:(NSString *)words;
+(NSString *)generateMnemonic;

@end

NS_ASSUME_NONNULL_END
