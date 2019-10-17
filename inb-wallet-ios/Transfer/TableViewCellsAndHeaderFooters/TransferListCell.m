//
//  Transferself.m
//  test
//
//  Created by insightChain_iOS开发 on 2019/6/12.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "TransferListCell.h"
@interface TransferListCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstrain;

@end

@implementation TransferListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.typeLabel.layer.cornerRadius = 3;
    self.typeLabel.layer.borderWidth = 1;
    self.typeLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

-(void)setTransferModel:(TransferModel *)transferModel{
    _transferModel = transferModel;
    
    self.timeLabel.text = [NSDate timestampSwitchTime:_transferModel.timestamp/1000.0 formatter:@"yyyy-MM-dd HH:mm:ss"];
    [self makeContent:_transferModel];
}

-(void)makeContent:(TransferModel *)tranderModel{
    if(tranderModel.type == TxType_transfer && tranderModel.direction == 2){
        //转入
        self.addressLabel.text = tranderModel.from;
        self.typeLabel.text = @"收款";
        self.typeLabel.layer.borderColor = kColorBlue.CGColor;
        self.typeLabel.textColor = kColorBlue;
        self.valueLabel.text = [NSString stringWithFormat:@"+ %@ INB", [NSString changeNumberFormatter:[NSString stringWithFormat:@"%f",tranderModel.amount]]];
        self.infoLabel.text = [tranderModel.input stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }else if(tranderModel.type == TxType_transfer && tranderModel.direction == 1){
        //转出
        self.addressLabel.text = tranderModel.to;
        self.typeLabel.text = @"转账";
        self.typeLabel.layer.borderColor = kColorBlue.CGColor;
        self.typeLabel.textColor = kColorBlue;
        self.valueLabel.text = [NSString stringWithFormat:@"- %@ INB", [NSString changeNumberFormatter:[NSString stringWithFormat:@"%f",tranderModel.amount]]];
        self.infoLabel.text = tranderModel.input;
    }else if(tranderModel.type == TxType_moetgage || tranderModel.type == TxType_lock){
        //抵押 | 锁仓
        self.addressLabel.text = NSLocalizedString(@"transfer.typeName.mortgage", @"抵押资源");
        self.typeLabel.text = @"资源";
        self.typeLabel.layer.borderColor = kColorWithHexValue(0xf5a623).CGColor;
        self.typeLabel.textColor = kColorWithHexValue(0xf5a623);
        self.valueLabel.text = [NSString stringWithFormat:@"- %@ INB", [NSString changeNumberFormatter:[NSString stringWithFormat:@"%f",tranderModel.amount]]];
        if(tranderModel.type == TxType_lock){
            NSString *blockNumberStr = [tranderModel.input substringFromIndex:[tranderModel.input rangeOfString:@"days:"].length];
            NSDecimalNumber *blockDeci = [NSDecimalNumber decimalNumberWithString:blockNumberStr];
            NSInteger days = [self getDaysFromBlockNumber:blockNumberStr];
            double rate = [self rateFromDays:days];
            self.infoLabel.text = [NSString stringWithFormat:@"%.2f万区块 %.2f%%", [[blockDeci decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"10000"]] doubleValue], rate];
        }else{
            self.infoLabel.text = [NSString stringWithFormat:@""];
        }
        
        
    }else if(tranderModel.type == TxType_unMortgage){
        //赎回
        self.addressLabel.text = NSLocalizedString(@"transfer.typeName.redemption.apply", @"抵押赎回");
        self.typeLabel.text = @"资源";
        self.typeLabel.layer.borderColor = kColorWithHexValue(0xf5a623).CGColor;
        self.typeLabel.textColor = kColorWithHexValue(0xf5a623);
        self.valueLabel.text = [NSString stringWithFormat:@""];
        self.valueLabel.text = [NSString stringWithFormat:@"申请赎回%@ INB", [NSString changeNumberFormatter:[NSString stringWithFormat:@"%f",tranderModel.amount]]];
        self.infoLabel.text = @"";
    }else if(tranderModel.type == TxType_receive){
        //领取赎回
        self.addressLabel.text = NSLocalizedString(@"transfer.typeName.redemption.receive", @"领取赎回");
        self.typeLabel.text = @"资源";
        self.typeLabel.layer.borderColor = kColorWithHexValue(0xf5a623).CGColor;
        self.typeLabel.textColor = kColorWithHexValue(0xf5a623);
        self.valueLabel.text = [NSString stringWithFormat:@"+ %@ INB", [NSString changeNumberFormatter:[NSString stringWithFormat:@"%f",tranderModel.amount]]];
        self.infoLabel.text = tranderModel.input;
    }else if(tranderModel.type == TxType_rewardLock){
        //领取锁仓奖励
        self.addressLabel.text = NSLocalizedString(@"transfer.typeName.redemption.reward", @"领取抵押收益");
        self.typeLabel.text = @"资源";
        self.typeLabel.layer.borderColor = kColorWithHexValue(0xf5a623).CGColor;
        self.typeLabel.textColor = kColorWithHexValue(0xf5a623);
        self.valueLabel.text = [NSString stringWithFormat:@"+ %@ INB", [NSString changeNumberFormatter:[NSString stringWithFormat:@"%f",tranderModel.amount]]];
        self.infoLabel.text = @"";
    }else if(tranderModel.type == TxType_reResource){
        //领取资源
         self.addressLabel.text = NSLocalizedString(@"Resource.receive", @"领取资源");
        self.typeLabel.text = @"资源";
        self.typeLabel.layer.borderColor = kColorWithHexValue(0xf5a623).CGColor;
        self.typeLabel.textColor = kColorWithHexValue(0xf5a623);
        self.valueLabel.text = @"";
        self.infoLabel.text = @"";
    }else if(tranderModel.type == TxType_vote){
        //投票
        self.addressLabel.text = NSLocalizedString(@"transfer.typeName.vote", @"节点投票");
        self.typeLabel.text = NSLocalizedString(@"transfer.type.other",@"其他");
        self.typeLabel.layer.borderColor = kColorWithHexValue(0x03d0a2).CGColor;
        self.typeLabel.textColor = kColorWithHexValue(0x03d0a2);
        self.valueLabel.text = [tranderModel.input add0xIfNeeded];
        self.infoLabel.text = @"";
    }else if(tranderModel.type == TxType_rewardVote){
        //领取投票奖励
        self.addressLabel.text = NSLocalizedString(@"transfer.typeName.vote.reward", @"领取投票收益");;
        self.typeLabel.text = NSLocalizedString(@"transfer.type.other",@"其他");
        self.typeLabel.layer.borderColor = kColorWithHexValue(0x03d0a2).CGColor;
        self.typeLabel.textColor = kColorWithHexValue(0x03d0a2);
        self.valueLabel.text = [NSString stringWithFormat:@"+ %@ INB", [NSString changeNumberFormatter:[NSString stringWithFormat:@"%f",tranderModel.amount]]];
        self.infoLabel.text = tranderModel.input;
    }else if(tranderModel.type == TxType_updateNodeInfo){ //更新节点信息
        self.addressLabel.text = NSLocalizedString(@"transfer.typeName.node.update", @"更新节点");;
        self.typeLabel.text = NSLocalizedString(@"transfer.type.other",@"其他");
        self.typeLabel.layer.borderColor = kColorWithHexValue(0x03d0a2).CGColor;
        self.typeLabel.textColor = kColorWithHexValue(0x03d0a2);
        self.valueLabel.text = @"";
        self.infoLabel.text = @"";
    }else{
        NSLog(@"%@", tranderModel.type);
    }
    
    NSString *str = [self.infoLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([str isEqualToString:@""] || !str){
//        self.valueLabel.font = [UIFont systemFontOfSize:17];
        self.bottomConstrain.constant = 0;
    }else{
//        self.valueLabel.font = [UIFont systemFontOfSize:15];
        self.bottomConstrain.constant = 17;
    }
}

-(NSInteger)getDaysFromBlockNumber:(NSString *)blockStr{
    NSDecimalNumber *deci = [NSDecimalNumber decimalNumberWithString:blockStr];
    
    NSDecimalNumber *dayDeci = [deci decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld",kDayNumbers]]];
    return [dayDeci integerValue];
}
-(double)rateFromDays:(NSInteger)days{
    switch (days) {
        case 30:
            return kRateReturn7_30;
            break;
        case 90:{
            return kRateReturn7_90;
        }
        case 180:{
            return kRateReturn7_180;
        }
        case 360:{
            return kRateReturn7_360;
        }
        default:
            return 0;
            break;
    }
}

@end
