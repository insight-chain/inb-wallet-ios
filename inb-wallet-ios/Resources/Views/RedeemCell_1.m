//
//  RedeemCell_1.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/9/2.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "RedeemCell_1.h"

#import "NSDate+DateString.h"

@interface RedeemCell_1()
@property (weak, nonatomic) IBOutlet UILabel *valueLabel; //赎回中的值
@property (weak, nonatomic) IBOutlet UIButton *tipBtn;  //提示

@end


@implementation RedeemCell_1

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark ---- Button Action
- (IBAction)btnAction:(UIButton *)sender {
    if(self.receiveBlock){
        self.receiveBlock();
    }
}

-(void)makeCurreentBlockNumber:(NSInteger)currentNumber startNumber:(NSInteger)startNumber{
    
    if(self.value <= 0){
        [self.tipBtn setTitle:[NSString stringWithFormat:@"暂无赎回"] forState:UIControlStateNormal];
        [self.tipBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg_lightBlue"] forState:UIControlStateNormal];
        self.tipBtn.userInteractionEnabled = NO;
        return;
    }
    if(currentNumber >= 3*(24*60*60) + startNumber){
        //可以领取
        [self.tipBtn setTitle:@"领取赎回" forState:UIControlStateNormal];
        [self.tipBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg_blue"] forState:UIControlStateNormal];
        self.tipBtn.userInteractionEnabled = YES;
    }else{
        int m = 3*(24*60*60)/2.0 + startNumber - currentNumber;
        int day = (m*2)/(24*60*60);
        int hour = (m*2)%(24*60*60);
        if (hour > 0) {
            day += 1;
        }
        [self.tipBtn setTitle:[NSString stringWithFormat:@"%d天后完成赎回", day] forState:UIControlStateNormal];
        [self.tipBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg_lightBlue"] forState:UIControlStateNormal];
        self.tipBtn.userInteractionEnabled = NO;
    }
}

#pragma mark ----
-(void)setValue:(double)value{
    _value = value;
    self.valueLabel.text = [NSString stringWithFormat:@"%.2f INB", _value];
}
-(void)setTime:(double)time{
    _time = time;
    NSInteger ind = [NSDate getDifferenceByDate:_time];
   
}
@end
