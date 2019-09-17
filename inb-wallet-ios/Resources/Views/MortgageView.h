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

@interface MortgageView : UIView
@property (weak, nonatomic) IBOutlet UILabel *rateL; //七日年化label
@property (weak, nonatomic) IBOutlet UITextField *netInputTF;
@property (weak, nonatomic) IBOutlet UIButton *days_Btn_0;
@property (weak, nonatomic) IBOutlet UIButton *days_Btn_30;
@property (weak, nonatomic) IBOutlet UIButton *days_Btn_90;
@property (weak, nonatomic) IBOutlet UIButton *days_Btn_180;
@property (weak, nonatomic) IBOutlet UIButton *days_Btn_360;

@property (nonatomic, copy) MortgageConfirmBlock confirmBlcok;

@end

NS_ASSUME_NONNULL_END
