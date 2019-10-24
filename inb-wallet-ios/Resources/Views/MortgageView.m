//
//  MortgageView.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/9/6.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "MortgageView.h"
@interface MortgageView()
@property (weak, nonatomic) IBOutlet UILabel *netStrL; // "RES抵押"
@property (weak, nonatomic) IBOutlet UIImageView *netTextFieldBg;
@property (weak, nonatomic) IBOutlet UILabel *rateStrL; //"年化"
@property (weak, nonatomic) IBOutlet UILabel *tipL_1;
@property (weak, nonatomic) IBOutlet UILabel *tipL_2;
@property (weak, nonatomic) IBOutlet UILabel *tipL_3;
@property (weak, nonatomic) IBOutlet UILabel *tipL_4;

@property (nonatomic, assign) NSInteger selectDays;
@end

@implementation MortgageView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"MortgageView" owner:self options:nil] lastObject];
    if (self) {
        self.frame = frame;
        
        self.netInputTF.placeholder = @"请输入INB数量";
        
        self.selectDays = -1;
        
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.days_blockNumber_30.text = [NSString stringWithFormat:NSLocalizedString(@"Resource.mortgage.block", @"%@万区块高度"),[NSString stringWithFormat:@"%.2f", (kDayNumbers*30)/10000.0]];
    self.days_time_30.text = [NSString stringWithFormat:NSLocalizedString(@"Resource.mortgage.day", @"锁仓期 ≈ %d天"),30];
    
    self.days_blockNumber_90.text = [NSString stringWithFormat:NSLocalizedString(@"Resource.mortgage.block", @"%@万区块高度"),[NSString stringWithFormat:@"%.2f", (kDayNumbers*90)/10000.0]];
    self.days_time_90.text = [NSString stringWithFormat:NSLocalizedString(@"Resource.mortgage.day", @"锁仓期 ≈ %d天"),90];
    
    self.days_blockNumber_180.text = [NSString stringWithFormat:NSLocalizedString(@"Resource.mortgage.block", @"%@万区块高度"),[NSString stringWithFormat:@"%.2f", (kDayNumbers*180)/10000.0]];
    self.days_time_180.text = [NSString stringWithFormat:NSLocalizedString(@"Resource.mortgage.day", @"锁仓期 ≈ %d天"),180];
    
    self.days_blockNumber_360.text = [NSString stringWithFormat:NSLocalizedString(@"Resource.mortgage.block", @"%@万区块高度"),[NSString stringWithFormat:@"%.2f", (kDayNumbers*360)/10000.0]];
    self.days_time_360.text = [NSString stringWithFormat:NSLocalizedString(@"Resource.mortgage.day", @"锁仓期 ≈ %d天"),360];
    
    self.days_blockNumber_0.text = NSLocalizedString(@"Resource.mortgage.noDay", @"无抵押期限");
    self.days_time_0.text = @"";
    
    self.tipL_1.text = NSLocalizedString(@"tip.resource.mortgage_1", @"抵押提示文字");
    self.tipL_2.text = NSLocalizedString(@"tip.resource.mortgage_2", @"抵押提示文字");
    self.tipL_3.text = NSLocalizedString(@"tip.resource.mortgage_3", @"抵押提示文字");
    self.tipL_4.text = NSLocalizedString(@"tip.resource.mortgage_4", @"抵押提示文字");
    
}

#pragma mark ---- Button Action
//选择抵押天数
- (IBAction)daysSelectBtnAction:(UIButton *)sender {
    
    NSInteger tag = sender.tag;
    switch (tag) {
        case 0:{
            if (self.selectDays != 0) {
                [self.days_Btn_0 setBackgroundImage:[UIImage imageNamed:@"btn_round_blue"] forState:UIControlStateNormal];
                self.days_blockNumber_0.textColor = [UIColor whiteColor];
                self.days_time_0.textColor = [UIColor whiteColor];
                
                [self.days_Btn_30 setBackgroundImage:[UIImage imageNamed:@"btn_round_gray"] forState:UIControlStateNormal];
                self.days_blockNumber_30.textColor = kColorAuxiliary2;
                self.days_time_30.textColor = kColorAuxiliary2;
                
                [self.days_Btn_90 setBackgroundImage:[UIImage imageNamed:@"btn_round_gray"] forState:UIControlStateNormal];
                self.days_blockNumber_90.textColor = kColorAuxiliary2;
                self.days_time_90.textColor = kColorAuxiliary2;
                
                [self.days_Btn_180 setBackgroundImage:[UIImage imageNamed:@"btn_round_gray"] forState:UIControlStateNormal];
                self.days_blockNumber_180.textColor = kColorAuxiliary2;
                self.days_time_180.textColor = kColorAuxiliary2;
                
                [self.days_Btn_360 setBackgroundImage:[UIImage imageNamed:@"btn_round_gray"] forState:UIControlStateNormal];
                self.days_blockNumber_360.textColor = kColorAuxiliary2;
                self.days_time_360.textColor = kColorAuxiliary2;
                
                
                self.rateL.text = [NSString stringWithFormat:@"0%%"];
                self.selectDays = 0;
            }
            break;
        }
        case 30:{
            [self.days_Btn_0 setBackgroundImage:[UIImage imageNamed:@"btn_round_gray"] forState:UIControlStateNormal];
            self.days_blockNumber_0.textColor = kColorAuxiliary2;
            self.days_time_0.textColor = kColorAuxiliary2;
            
            [self.days_Btn_30 setBackgroundImage:[UIImage imageNamed:@"btn_round_blue"] forState:UIControlStateNormal];
            self.days_blockNumber_30.textColor = [UIColor whiteColor];
            self.days_time_30.textColor = [UIColor whiteColor];
            
            [self.days_Btn_90 setBackgroundImage:[UIImage imageNamed:@"btn_round_gray"] forState:UIControlStateNormal];
            self.days_blockNumber_90.textColor = kColorAuxiliary2;
            self.days_time_90.textColor = kColorAuxiliary2;
            
            [self.days_Btn_180 setBackgroundImage:[UIImage imageNamed:@"btn_round_gray"] forState:UIControlStateNormal];
            self.days_blockNumber_180.textColor = kColorAuxiliary2;
            self.days_time_180.textColor = kColorAuxiliary2;
            
            [self.days_Btn_360 setBackgroundImage:[UIImage imageNamed:@"btn_round_gray"] forState:UIControlStateNormal];
            self.days_blockNumber_360.textColor = kColorAuxiliary2;
            self.days_time_360.textColor = kColorAuxiliary2;
            
            self.rateL.text = [NSString stringWithFormat:@"%.1f%%", kRateReturn7_30];
            self.selectDays = 30;
            break;
        }
        case 90:{
            [self.days_Btn_0 setBackgroundImage:[UIImage imageNamed:@"btn_round_gray"] forState:UIControlStateNormal];
            self.days_blockNumber_0.textColor = kColorAuxiliary2;
            self.days_time_0.textColor = kColorAuxiliary2;
            
            [self.days_Btn_30 setBackgroundImage:[UIImage imageNamed:@"btn_round_gray"] forState:UIControlStateNormal];
            self.days_blockNumber_30.textColor = kColorAuxiliary2;
            self.days_time_30.textColor = kColorAuxiliary2;
            
            [self.days_Btn_90 setBackgroundImage:[UIImage imageNamed:@"btn_round_blue"] forState:UIControlStateNormal];
            self.days_blockNumber_90.textColor = [UIColor whiteColor];
            self.days_time_90.textColor = [UIColor whiteColor];
            
            [self.days_Btn_180 setBackgroundImage:[UIImage imageNamed:@"btn_round_gray"] forState:UIControlStateNormal];
            self.days_blockNumber_180.textColor = kColorAuxiliary2;
            self.days_time_180.textColor = kColorAuxiliary2;
            
            [self.days_Btn_360 setBackgroundImage:[UIImage imageNamed:@"btn_round_gray"] forState:UIControlStateNormal];
            self.days_blockNumber_360.textColor = kColorAuxiliary2;
            self.days_time_360.textColor = kColorAuxiliary2;
            
            self.rateL.text = [NSString stringWithFormat:@"%.1f%%", kRateReturn7_90];
            self.selectDays = 90;
            break;
        }
        case 180:{
            [self.days_Btn_0 setBackgroundImage:[UIImage imageNamed:@"btn_round_gray"] forState:UIControlStateNormal];
            self.days_blockNumber_0.textColor = kColorAuxiliary2;
            self.days_time_0.textColor = kColorAuxiliary2;
            
            [self.days_Btn_30 setBackgroundImage:[UIImage imageNamed:@"btn_round_gray"] forState:UIControlStateNormal];
            self.days_blockNumber_30.textColor = kColorAuxiliary2;
            self.days_time_30.textColor = kColorAuxiliary2;
            
            [self.days_Btn_90 setBackgroundImage:[UIImage imageNamed:@"btn_round_gray"] forState:UIControlStateNormal];
            self.days_blockNumber_90.textColor = kColorAuxiliary2;
            self.days_time_90.textColor = kColorAuxiliary2;
            
            [self.days_Btn_180 setBackgroundImage:[UIImage imageNamed:@"btn_round_blue"] forState:UIControlStateNormal];
            self.days_blockNumber_180.textColor = [UIColor whiteColor];
            self.days_time_180.textColor = [UIColor whiteColor];
            
            [self.days_Btn_360 setBackgroundImage:[UIImage imageNamed:@"btn_round_gray"] forState:UIControlStateNormal];
            self.days_blockNumber_360.textColor = kColorAuxiliary2;
            self.days_time_360.textColor = kColorAuxiliary2;
            
            self.rateL.text = [NSString stringWithFormat:@"%.1f%%", kRateReturn7_180];
            self.selectDays = 180;
            break;
        }
        case 360:{
            [self.days_Btn_0 setBackgroundImage:[UIImage imageNamed:@"btn_round_gray"] forState:UIControlStateNormal];
            self.days_blockNumber_0.textColor = kColorAuxiliary2;
            self.days_time_0.textColor = kColorAuxiliary2;
            
            [self.days_Btn_30 setBackgroundImage:[UIImage imageNamed:@"btn_round_gray"] forState:UIControlStateNormal];
            self.days_blockNumber_30.textColor = kColorAuxiliary2;
            self.days_time_30.textColor = kColorAuxiliary2;
            
            [self.days_Btn_90 setBackgroundImage:[UIImage imageNamed:@"btn_round_gray"] forState:UIControlStateNormal];
            self.days_blockNumber_90.textColor = kColorAuxiliary2;
            self.days_time_90.textColor = kColorAuxiliary2;
            
            [self.days_Btn_180 setBackgroundImage:[UIImage imageNamed:@"btn_round_gray"] forState:UIControlStateNormal];
            self.days_blockNumber_180.textColor = kColorAuxiliary2;
            self.days_time_180.textColor = kColorAuxiliary2;
            
            [self.days_Btn_360 setBackgroundImage:[UIImage imageNamed:@"btn_round_blue"] forState:UIControlStateNormal];
            self.days_blockNumber_360.textColor = [UIColor whiteColor];
            self.days_time_360.textColor = [UIColor whiteColor];
            
            self.rateL.text = [NSString stringWithFormat:@"%.1f%%", kRateReturn7_360];
            self.selectDays = 360;
            break;
        }
        default:
            [self.days_Btn_0 setBackgroundImage:[UIImage imageNamed:@"btn_round_gray"] forState:UIControlStateNormal];
            self.days_blockNumber_0.textColor = kColorAuxiliary2;
            self.days_time_0.textColor = kColorAuxiliary2;
            
            [self.days_Btn_30 setBackgroundImage:[UIImage imageNamed:@"btn_round_gray"] forState:UIControlStateNormal];
            self.days_blockNumber_30.textColor = kColorAuxiliary2;
            self.days_time_30.textColor = kColorAuxiliary2;
            
            [self.days_Btn_90 setBackgroundImage:[UIImage imageNamed:@"btn_round_gray"] forState:UIControlStateNormal];
            self.days_blockNumber_90.textColor = kColorAuxiliary2;
            self.days_time_90.textColor = kColorAuxiliary2;
            
            [self.days_Btn_180 setBackgroundImage:[UIImage imageNamed:@"btn_round_gray"] forState:UIControlStateNormal];
            self.days_blockNumber_180.textColor = kColorAuxiliary2;
            self.days_time_180.textColor = kColorAuxiliary2;
            
            [self.days_Btn_360 setBackgroundImage:[UIImage imageNamed:@"btn_round_gray"] forState:UIControlStateNormal];
            self.days_blockNumber_360.textColor = kColorAuxiliary2;
            self.days_time_360.textColor = kColorAuxiliary2;
            self.selectDays = 1000; //表示测试
            break;
    }
}

//确认
- (IBAction)confirmBtnAction:(UIButton *)sender {
    
    if (self.confirmBlcok) {
        self.confirmBlcok(self.selectDays, self.netInputTF.text);
    }
    
}
//取消输入
- (IBAction)netTFCancelBtnAction:(UIButton *)sender {
    self.netInputTF.text = @"";
}
//疑问
- (IBAction)doubltBtnAction:(UIButton *)sender {
    if(self.doubtBlock){
        self.doubtBlock();
    }
}


@end
