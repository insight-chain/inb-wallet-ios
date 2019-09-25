//
//  MortgageView.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/9/6.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "MortgageView.h"
@interface MortgageView()
@property (weak, nonatomic) IBOutlet UILabel *netStrL; // "NET抵押"
@property (weak, nonatomic) IBOutlet UIImageView *netTextFieldBg;
@property (weak, nonatomic) IBOutlet UILabel *rateStrL; //"年化"
@property (weak, nonatomic) IBOutlet UILabel *tipL_1;
@property (weak, nonatomic) IBOutlet UILabel *tipL_2;
@property (weak, nonatomic) IBOutlet UILabel *tipL_3;

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
    
    self.days_Btn_30.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.days_Btn_30.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.days_Btn_30 setTitle:@"30\n天" forState:UIControlStateNormal];
    
    self.days_Btn_90.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.days_Btn_90.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.days_Btn_90 setTitle:@"90\n天" forState:UIControlStateNormal];
    
    self.days_Btn_180.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.days_Btn_180.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.days_Btn_180 setTitle:@"180\n天" forState:UIControlStateNormal];
    
    self.days_Btn_360.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.days_Btn_360.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.days_Btn_360 setTitle:@"360\n天" forState:UIControlStateNormal];
}

#pragma mark ---- Button Action
//选择抵押天数
- (IBAction)daysSelectBtnAction:(UIButton *)sender {
    
    NSInteger tag = sender.tag;
    switch (tag) {
        case 0:{
            if (self.selectDays != 0) {
                [self.days_Btn_0 setBackgroundImage:[UIImage imageNamed:@"days_select_blue_bg"] forState:UIControlStateNormal];
                
                [self.days_Btn_30 setBackgroundImage:[UIImage imageNamed:@"days_select_gray_bg"] forState:UIControlStateNormal];
                [self.days_Btn_90 setBackgroundImage:[UIImage imageNamed:@"days_select_gray_bg"] forState:UIControlStateNormal];
                [self.days_Btn_180 setBackgroundImage:[UIImage imageNamed:@"days_select_gray_bg"] forState:UIControlStateNormal];
                [self.days_Btn_360 setBackgroundImage:[UIImage imageNamed:@"days_select_gray_bg"] forState:UIControlStateNormal];
                
                [self.days_Btn_0 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.days_Btn_30 setTitleColor:kColorBlue forState:UIControlStateNormal];
                [self.days_Btn_90 setTitleColor:kColorBlue forState:UIControlStateNormal];
                [self.days_Btn_180 setTitleColor:kColorBlue forState:UIControlStateNormal];
                [self.days_Btn_360 setTitleColor:kColorBlue forState:UIControlStateNormal];
                self.rateL.text = [NSString stringWithFormat:@"0%%"];
                self.selectDays = 0;
            }
            break;
        }
        case 30:{
            [self.days_Btn_0 setBackgroundImage:[UIImage imageNamed:@"days_select_gray_bg"] forState:UIControlStateNormal];
            [self.days_Btn_30 setBackgroundImage:[UIImage imageNamed:@"days_select_blue_bg"] forState:UIControlStateNormal];
            [self.days_Btn_90 setBackgroundImage:[UIImage imageNamed:@"days_select_gray_bg"] forState:UIControlStateNormal];
            [self.days_Btn_180 setBackgroundImage:[UIImage imageNamed:@"days_select_gray_bg"] forState:UIControlStateNormal];
            [self.days_Btn_360 setBackgroundImage:[UIImage imageNamed:@"days_select_gray_bg"] forState:UIControlStateNormal];
            
            [self.days_Btn_0 setTitleColor:kColorBlue forState:UIControlStateNormal];
            [self.days_Btn_30 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.days_Btn_90 setTitleColor:kColorBlue forState:UIControlStateNormal];
            [self.days_Btn_180 setTitleColor:kColorBlue forState:UIControlStateNormal];
            [self.days_Btn_360 setTitleColor:kColorBlue forState:UIControlStateNormal];
            
            self.rateL.text = [NSString stringWithFormat:@"%.2f%%", kRateReturn7_30];
            self.selectDays = 30;
            break;
        }
        case 90:{
            [self.days_Btn_0 setBackgroundImage:[UIImage imageNamed:@"days_select_gray_bg"] forState:UIControlStateNormal];
            [self.days_Btn_30 setBackgroundImage:[UIImage imageNamed:@"days_select_gray_bg"] forState:UIControlStateNormal];
            [self.days_Btn_90 setBackgroundImage:[UIImage imageNamed:@"days_select_blue_bg"] forState:UIControlStateNormal];
            [self.days_Btn_180 setBackgroundImage:[UIImage imageNamed:@"days_select_gray_bg"] forState:UIControlStateNormal];
            [self.days_Btn_360 setBackgroundImage:[UIImage imageNamed:@"days_select_gray_bg"] forState:UIControlStateNormal];
            
            [self.days_Btn_0 setTitleColor:kColorBlue forState:UIControlStateNormal];
            [self.days_Btn_30 setTitleColor:kColorBlue forState:UIControlStateNormal];
            [self.days_Btn_90 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.days_Btn_180 setTitleColor:kColorBlue forState:UIControlStateNormal];
            [self.days_Btn_360 setTitleColor:kColorBlue forState:UIControlStateNormal];
            
            self.rateL.text = [NSString stringWithFormat:@"%.2f%%", kRateReturn7_90];
            self.selectDays = 90;
            break;
        }
        case 180:{
            [self.days_Btn_0 setBackgroundImage:[UIImage imageNamed:@"days_select_gray_bg"] forState:UIControlStateNormal];
            [self.days_Btn_30 setBackgroundImage:[UIImage imageNamed:@"days_select_gray_bg"] forState:UIControlStateNormal];
            [self.days_Btn_90 setBackgroundImage:[UIImage imageNamed:@"days_select_gray_bg"] forState:UIControlStateNormal];
            [self.days_Btn_180 setBackgroundImage:[UIImage imageNamed:@"days_select_blue_bg"] forState:UIControlStateNormal];
            [self.days_Btn_360 setBackgroundImage:[UIImage imageNamed:@"days_select_gray_bg"] forState:UIControlStateNormal];
            
            [self.days_Btn_0 setTitleColor:kColorBlue forState:UIControlStateNormal];
            [self.days_Btn_30 setTitleColor:kColorBlue forState:UIControlStateNormal];
            [self.days_Btn_90 setTitleColor:kColorBlue forState:UIControlStateNormal];
            [self.days_Btn_180 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.days_Btn_360 setTitleColor:kColorBlue forState:UIControlStateNormal];
            
            self.rateL.text = [NSString stringWithFormat:@"%.2f%%", kRateReturn7_180];
            self.selectDays = 180;
            break;
        }
        case 360:{
            [self.days_Btn_0 setBackgroundImage:[UIImage imageNamed:@"days_select_gray_bg"] forState:UIControlStateNormal];
            [self.days_Btn_30 setBackgroundImage:[UIImage imageNamed:@"days_select_gray_bg"] forState:UIControlStateNormal];
            [self.days_Btn_90 setBackgroundImage:[UIImage imageNamed:@"days_select_gray_bg"] forState:UIControlStateNormal];
            [self.days_Btn_180 setBackgroundImage:[UIImage imageNamed:@"days_select_gray_bg"] forState:UIControlStateNormal];
            [self.days_Btn_360 setBackgroundImage:[UIImage imageNamed:@"days_select_blue_bg"] forState:UIControlStateNormal];
            
            [self.days_Btn_0 setTitleColor:kColorBlue forState:UIControlStateNormal];
            [self.days_Btn_30 setTitleColor:kColorBlue forState:UIControlStateNormal];
            [self.days_Btn_90 setTitleColor:kColorBlue forState:UIControlStateNormal];
            [self.days_Btn_180 setTitleColor:kColorBlue forState:UIControlStateNormal];
            [self.days_Btn_360 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            self.rateL.text = [NSString stringWithFormat:@"%.2f%%", kRateReturn7_360];
            self.selectDays = 360;
            break;
        }
        default:
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
}

@end
