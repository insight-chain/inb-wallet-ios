//
//  RewardNoMortgageCell.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/10/30.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "RewardNoMortgageCell.h"
@interface RewardNoMortgageCell()
@property (weak, nonatomic) IBOutlet UILabel *noTipLabel;
@property (weak, nonatomic) IBOutlet UIButton *toMortgageBtn;

@end


@implementation RewardNoMortgageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.noTipLabel.text = NSLocalizedString(@"reward.noMortgage", @"您还没有锁仓抵押资源，暂无奖励");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (IBAction)toMortgageAction:(UIButton *)sender {
    if(self.goMortgage){
        self.goMortgage();
    }
}

@end
