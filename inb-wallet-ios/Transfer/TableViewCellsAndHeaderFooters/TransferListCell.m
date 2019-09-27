//
//  Transferself.m
//  test
//
//  Created by insightChain_iOS开发 on 2019/6/12.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "TransferListCell.h"

@implementation TransferListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setTransferModel:(TransferModel *)transferModel{
    _transferModel = transferModel;
    
    self.timeLabel.text = [NSDate timestampSwitchTime:_transferModel.timestamp/1000.0 formatter:@"yyyy-MM-dd HH:mm"];
    self.infoLabel.text = _transferModel.input;
    
    self.typeLabel.layer.cornerRadius = 3;
    self.typeLabel.layer.borderWidth = 1;
    
    [self makeContent:_transferModel];
}

-(void)makeContent:(TransferModel *)tranderModel{
    if(tranderModel.type == TxType_transfer && tranderModel.direction == 2){
        //转入
        self.addressLabel.text = tranderModel.from;
        self.typeLabel.text = @" 收款 ";
        self.typeLabel.layer.borderColor = kColorBlue.CGColor;
        self.valueLabel.text = [NSString stringWithFormat:@"+ %.4f INB", tranderModel.amount];
    }else if(tranderModel.type == TxType_transfer && tranderModel.direction == 1){
        //转出
        self.addressLabel.text = tranderModel.to;
        self.typeLabel.text = @" 转账 ";
        self.typeLabel.layer.borderColor = kColorBlue.CGColor;
        self.valueLabel.text = [NSString stringWithFormat:@"- %.4f INB", tranderModel.amount];
    }else if(tranderModel.type == TxType_vote){
        //投票
        self.addressLabel.text = tranderModel.to;
        self.typeLabel.text = @" 投票 ";
        self.typeLabel.layer.borderColor = kColorBlue.CGColor;
        self.valueLabel.text = [NSString stringWithFormat:@"- %.4f INB", tranderModel.amount];
    }else if(tranderModel.type == TxType_moetgage){
        self.addressLabel.text = tranderModel.to;
        self.typeLabel.text = @" 抵押 ";
        self.typeLabel.layer.borderColor = kColorBlue.CGColor;
        self.valueLabel.text = [NSString stringWithFormat:@"- %.4f INB", tranderModel.amount];
    }else if(tranderModel.type == TxType_unMortgage){
        self.addressLabel.text = tranderModel.to;
        self.typeLabel.text = @" 赎回 ";
        self.typeLabel.layer.borderColor = kColorBlue.CGColor;
        self.valueLabel.text = [NSString stringWithFormat:@"+ %.4f INB", tranderModel.amount];
    }else if (tranderModel.type == TxType_lock){
        self.addressLabel.text = tranderModel.from;
        self.typeLabel.text = @" 锁仓 ";
        self.typeLabel.layer.borderColor = kColorBlue.CGColor;
        self.valueLabel.text = [NSString stringWithFormat:@"- %.4f INB", tranderModel.amount];
    }else if(tranderModel.type == TxType_receive){
        self.addressLabel.text = tranderModel.from;
        self.typeLabel.text = @" 领取赎回 ";
        self.typeLabel.layer.borderColor = kColorBlue.CGColor;
        self.valueLabel.text = [NSString stringWithFormat:@"+ %.4f INB", tranderModel.amount];
    }else if(tranderModel.type == TxType_rewardLock){
        self.addressLabel.text = tranderModel.from;
        self.typeLabel.text = @" 锁仓奖励 ";
        self.typeLabel.layer.borderColor = kColorBlue.CGColor;
        self.valueLabel.text = [NSString stringWithFormat:@"+ %.4f INB", tranderModel.amount];
    }else if(tranderModel.type == TxType_rewardVote){
        self.addressLabel.text = tranderModel.from;
        self.typeLabel.text = @" 投票奖励 ";
        self.typeLabel.layer.borderColor = kColorBlue.CGColor;
        self.valueLabel.text = [NSString stringWithFormat:@"+ %.4f INB", tranderModel.amount];
    }
}

@end
