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

#pragma mark ---- set && getter
-(void)setModel:(LockModel *)model{
    _model = model;
    
    self.mortgageValueLabel.text = _model.amount;

    if(_model.days == 0){
        self.rewardLable.text = @"0 INB";
        self.rewardLable.text = @"0 INB";
        self.rate_7Label.text = @"0";
        [self.stateBtn setTitle:@"无抵押期限" forState:UIControlStateNormal];
        [self.stateBtn setBackgroundImage:[UIImage imageNamed:@"days_no_bg"] forState:UIControlStateNormal];
        [self.stateBtn setTitleColor:kColorWithHexValue(0xf5a623) forState:UIControlStateNormal];
        self.receiveTimeLabel.text = @"";
        [self.receiveBtn setTitle:@"赎回" forState:UIControlStateNormal];
        
    }else{
        [self.stateBtn setBackgroundImage:[UIImage imageNamed:@"days_bg"] forState:UIControlStateNormal];
        [self.stateBtn setTitleColor:kColorBlue forState:UIControlStateNormal];
        if (_model.days == 30){
            self.rate_7Label.text = [NSString stringWithFormat:@"%.2f", kRateReturn7_30];
            [self.stateBtn setTitle:@"30天" forState:UIControlStateNormal];
        }else if (_model.days == 90){
            self.rate_7Label.text = [NSString stringWithFormat:@"%.2f", kRateReturn7_90];
            [self.stateBtn setTitle:@"90天" forState:UIControlStateNormal];
        }else if (_model.days == 180){
            self.rate_7Label.text = [NSString stringWithFormat:@"%.2f", kRateReturn7_180];
            [self.stateBtn setTitle:@"180天" forState:UIControlStateNormal];
        }else if (_model.days == 360){
            self.rate_7Label.text = [NSString stringWithFormat:@"%.2f", kRateReturn7_360];
            [self.stateBtn setTitle:@"360天" forState:UIControlStateNormal];
        }else if (_model.days == 1){
            //测试
            self.rate_7Label.text = [NSString stringWithFormat:@"%.2f", kRateReturn7_30];
            [self.stateBtn setTitle:@"1天" forState:UIControlStateNormal];
        }
    }
    
}

/**
 * 计算收益
 * 开始锁仓块高度
 * 上次领取块高度
 */
-(double)calculateStrartBlock:(NSInteger)startNumber currentBlock:(NSInteger)currentNumber basic:(double)basicValue days:(NSInteger)days{
    NSInteger dif = currentNumber - startNumber;
    NSInteger sec = dif*2; //等价于多少秒
    NSInteger day = sec / (60*60*24); //有收益的天数
    
    double rate = 0;
    switch (days) {
        case 0:
            rate = 0;
            break;
        case 30:{
            rate = kRateReturn7_30;
            break;
        }
        case 90:{
            rate = kRateReturn7_90;
            break;
        }
        case 180:{
            rate = kRateReturn7_180;
            break;
        }
        case 360:{
            rate = kRateReturn7_360;
            break;
        }
        default:
            rate = kRateReturn7_30;
            break;
    }
    
//    double reward = basicValue * (rate/100.0/365) * day;
    //本次领取奖励=（当前区块高度-上次领投票奖励区块高度）/每天产生区块数（24*60*60/2）*年化（9%）/365
    double totalCan = dif/kDayNumbers*(rate/100)/365*basicValue;
    double reward = totalCan - [self.model.received doubleValue];

    return reward;
    
}

-(void)setCurrentBlockNumber:(NSInteger)currentBlockNumber{
    _currentBlockNumber = currentBlockNumber;
    
    double lastReceiveTime = self.model.lastReceivedTime;
    
    NSInteger difBlock = (_currentBlockNumber - (self.model.lastReceivedHeight+self.model.lockHeight));
    if(self.model.days == 0){
        self.rewardLable.text = @"0 INB";
        self.rewardLable.text = @"0 INB";
        self.rate_7Label.text = @"0";
        [self.stateBtn setTitle:@"无抵押期限" forState:UIControlStateNormal];
        [self.stateBtn setBackgroundImage:[UIImage imageNamed:@"days_no_bg"] forState:UIControlStateNormal];
        [self.stateBtn setTitleColor:kColorWithHexValue(0xf5a623) forState:UIControlStateNormal];
        self.receiveTimeLabel.text = @"";
        [self.receiveBtn setTitle:@"赎回" forState:UIControlStateNormal];
        
        self.model.reward = 0;
        
        return;
    }
    if(difBlock > 0){
        //到期
        [self.stateBtn setBackgroundImage:[UIImage imageNamed:@"days_no_bg"] forState:UIControlStateNormal];
        [self.stateBtn setTitle:@"抵押已到期" forState:UIControlStateNormal];
        [self.receiveBtn setTitle:@"领取" forState:UIControlStateNormal];
        
        double reward = [self calculateStrartBlock:self.model.startHeight currentBlock:self.model.startHeight+self.model.lockHeight basic:[self.model.amount doubleValue] days:self.model.days];
        self.model.reward = reward;
        self.model.remainingDays = 0; //可领取
        self.rewardLable.text = [NSString stringWithFormat:@"%.5f", reward+[self.model.amount doubleValue]];
        
    }else{
        NSInteger tim = self.model.lastReceivedHeight+(7*kDayNumbers) - _currentBlockNumber;
        double reward;
        if (tim <= 0) {
             reward = [self calculateStrartBlock:self.model.startHeight currentBlock:_currentBlockNumber basic:[self.model.amount doubleValue] days:self.model.days];
            //可以领取奖励
            self.receiveTimeLabel.text = @"";
            self.receiveBtn.userInteractionEnabled = YES;
            [self.receiveBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg_blue"] forState:UIControlStateNormal];
            [self.receiveBtn setTitle:@"领取收益" forState:UIControlStateNormal];
            
            self.model.remainingDays = 0;
        }else{
            
            
            reward = [self calculateStrartBlock:self.model.lastReceivedHeight currentBlock:self.model.lastReceivedHeight+(7*kDayNumbers) basic:[self.model.amount doubleValue] days:self.model.days];
            
            
            double dd = tim/(kDayNumbers*1.0);
            int day = ceil(dd);
            self.model.remainingDays = day;
            self.receiveTimeLabel.text = [NSString stringWithFormat:@"%d块≈%d天后领取", tim, day];
            self.receiveBtn.userInteractionEnabled = NO;
            [self.receiveBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg_lightBlue"] forState:UIControlStateNormal];
            [self.receiveBtn setTitle:@"请等待" forState:UIControlStateNormal];
        }
        
        self.model.reward = reward;
        self.rewardLable.text = [NSString stringWithFormat:@"%.5f", reward];
        
        
        
    }
}

@end
