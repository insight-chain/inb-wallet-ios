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

#pragma mark ----
-(void)setValue:(double)value{
    _value = value;
    self.valueLabel.text = [NSString stringWithFormat:@"%.2f INB", _value];
}
-(void)setTime:(double)time{
    _time = time;
    NSInteger ind = [NSDate getDifferenceByDate:_time];
    if(ind > 3){
        //可以领取
        [self.tipBtn setTitle:@"领取赎回" forState:UIControlStateNormal];
        [self.tipBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg_blue"] forState:UIControlStateNormal];
        self.tipBtn.userInteractionEnabled = YES;
    }else{
        [self.tipBtn setTitle:[NSString stringWithFormat:@"%ld天后完成赎回", (long)ind] forState:UIControlStateNormal];
        [self.tipBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg_lightBlue"] forState:UIControlStateNormal];
        self.tipBtn.userInteractionEnabled = NO;
    }
}
@end
