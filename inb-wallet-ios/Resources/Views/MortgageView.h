//
//  MortgageView.h
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/9/6.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^MortgageConfirmBlock)(NSInteger type, NSString *value);
typedef void(^DoubtBlock)(void);
@interface MortgageView : UIView
@property (weak, nonatomic) IBOutlet UILabel *rateL; //年化label
@property (weak, nonatomic) IBOutlet UITextField *netInputTF;
@property (weak, nonatomic) IBOutlet UIButton *days_Btn_0;
@property (weak, nonatomic) IBOutlet UILabel *days_blockNumber_0;
@property (weak, nonatomic) IBOutlet UILabel *days_time_0;
@property (weak, nonatomic) IBOutlet UIButton *days_Btn_30;
@property (weak, nonatomic) IBOutlet UILabel *days_blockNumber_30;
@property (weak, nonatomic) IBOutlet UILabel *days_time_30;

@property (weak, nonatomic) IBOutlet UIButton *days_Btn_90;
@property (weak, nonatomic) IBOutlet UILabel *days_blockNumber_90;
@property (weak, nonatomic) IBOutlet UILabel *days_time_90;

@property (weak, nonatomic) IBOutlet UIButton *days_Btn_180;
@property (weak, nonatomic) IBOutlet UILabel *days_blockNumber_180;
@property (weak, nonatomic) IBOutlet UILabel *days_time_180;

@property (weak, nonatomic) IBOutlet UIButton *days_Btn_360;
@property (weak, nonatomic) IBOutlet UILabel *days_blockNumber_360;
@property (weak, nonatomic) IBOutlet UILabel *days_time_360;

@property (nonatomic, copy) MortgageConfirmBlock confirmBlcok;
@property (nonatomic, copy) DoubtBlock doubtBlock;

@property (nonatomic, readonly, assign) NSInteger selectDays;

@end

NS_ASSUME_NONNULL_END
