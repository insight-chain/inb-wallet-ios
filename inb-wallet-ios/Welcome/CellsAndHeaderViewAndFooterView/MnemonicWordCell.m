//
//  MnemonicWordCell.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/29.
//  Copyright © 2019 apple. All rights reserved.
//

#import "MnemonicWordCell.h"

@implementation MnemonicWordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.wordLabel.layer.borderWidth = 1;
    self.wordLabel.layer.borderColor = kColorSeparate.CGColor;
    self.wordLabel.backgroundColor = kColorBackground;
    self.wordLabel.textColor = kColorAuxiliary2;
    self.wordLabel.layer.cornerRadius = 3.0;
    self.wordLabel.layer.masksToBounds = YES;
    
    self.clipsToBounds = NO;
}

@end
