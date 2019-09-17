//
//  RedeemCell_2.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/9/2.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "RedeemCell_2.h"
@interface RedeemCell_2()

@end

@implementation RedeemCell_2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

#pragma mark ----
- (IBAction)toDetailAction:(UIButton *)sender {
}
//领取奖励
- (IBAction)rewardAction:(UIButton *)sender {
    if(self.rewardBlock){
        self.rewardBlock();
    }
}

@end
