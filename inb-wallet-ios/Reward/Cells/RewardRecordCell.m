//
//  RewardRecordCell.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/9/11.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "RewardRecordCell.h"

@implementation RewardRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(TransferModel *)model{
    _model = model;
    self.timeLabel.text = [NSDate timestampSwitchTime:_model.timestamp/1000 formatter:@"yyyy-MM-dd HH:mm"];
    self.amountLabel.text = [NSString stringWithFormat:@"+%.5f INB", _model.amount];
    if (_model.type == TxType_rewardLock) {
        self.typeLabel.text = @"锁仓收益";
    }else if(TxType_rewardVote == _model.type){
        self.typeLabel.text = @"投票收益";
    }
}

@end
