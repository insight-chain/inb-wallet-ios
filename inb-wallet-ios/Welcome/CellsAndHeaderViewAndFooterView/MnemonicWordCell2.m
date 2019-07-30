//
//  MnemonicWordCell2.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/29.
//  Copyright © 2019 apple. All rights reserved.
//

#import "MnemonicWordCell2.h"

@implementation MnemonicWordCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    self.keyTextView.textContainerInset = UIEdgeInsetsMake(15, 10, 15, 10);
    self.keyTextView.textColor = kColorAuxiliary2;
    self.keyTextView.backgroundColor = kColorBackground;
    self.keyTextView.layer.borderWidth = 1.0;
    self.keyTextView.layer.borderColor = kColorSeparate.CGColor;
}

@end
