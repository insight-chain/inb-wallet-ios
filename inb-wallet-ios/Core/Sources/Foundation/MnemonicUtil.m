//
//  MnemonicUtil.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/23.
//  Copyright © 2019 apple. All rights reserved.
//

#import "MnemonicUtil.h"
#import "NSData+HexString.h"

@implementation MnemonicUtil
+(BTCMnemonic *)btnMnemonicFromEngWords:(NSString *)words{
    return [[BTCMnemonic alloc] initWithWords:[words componentsSeparatedByString:@" "] password:@"" wordListType:BTCMnemonicWordListTypeEnglish];
}
+(NSString *)generateMnemonic{
    NSData * entropy = [NSData random:16];
    NSArray *words = [[BTCMnemonic alloc] initWithEntropy:entropy password:@"" wordListType:BTCMnemonicWordListTypeEnglish].words;
    return [words componentsJoinedByString:@" "];
}
@end
