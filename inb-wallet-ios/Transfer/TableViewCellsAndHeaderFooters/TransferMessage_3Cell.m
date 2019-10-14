//
//  TransferMessage_3Cell.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/10/10.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "TransferMessage_3Cell.h"

@implementation TransferMessage_3Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestuer)];
    [self.infoLabel addGestureRecognizer:tapGes];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

-(void)tapGestuer{
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    board.string = self.infoLabel.text;
    [MBProgressHUD showMessage:[NSString stringWithFormat:@"%@%@", NSLocalizedString(@"transfer.tradeNo.", @"交易号"),NSLocalizedString(@"message.tip.copy.success", @"复制成功")] toView:App_Delegate.window afterDelay:1.5 animted:YES];
}

@end
