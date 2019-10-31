//
//  RedeemINBVC.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/9/10.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "RedeemINBVC.h"

#import "ConfirmView.h"
#import "PasswordInputView.h"
#import "TransactionSignedResult.h"
#import "WalletManager.h"
#import "NetworkUtil.h"

@interface RedeemINBVC ()
@property (nonatomic, strong) PasswordInputView *passwordInput;
@end

@implementation RedeemINBVC

- (void)viewDidLoad {
    [super viewDidLoad];
    /** View被导航栏遮挡问题的解决 **/
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
    [self makeNavi];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.canUseL.text = [NSString stringWithFormat:@"可赎回 %@ INB", [NSString changeNumberFormatter:[NSString stringWithFormat:@"%f", _canTotal]]];
}
-(void)makeNavi{
    
    /** 导航栏返回按钮文字 **/
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [rightBtn setTitle:NSLocalizedString(@"done", @"完成") forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

//解抵押
-(void)unMortgageAddr:(NSString *)addr walletID:(NSString *)walletID inbNumber:(NSString *)inbNumber password:(NSString *)password{
    __weak typeof(self) tmpSelf = self;
    __block __weak NSDecimalNumber *_nonce;
    
    __block TransactionSignedResult *_signResult;
    
    NSString *rpcHost = App_Delegate.rpcHost;

    //发送第一个请求
    [NetworkUtil rpc_requetWithURL:rpcHost
                                params:@{@"jsonrpc":@"2.0",
                                         @"method":nonce_MethodName,
                                         @"params":@[[addr add0xIfNeeded],@"latest"],@"id":@(1)}
                            completion:^(id  _Nullable responseObject, NSError * _Nullable error) {
                                if (error || responseObject[@"error"]) {
                                    [MBProgressHUD hideHUDForView:App_Delegate.window animated:YES];
                                    return ;
                                }
                                NSDictionary *dic = (NSDictionary *)responseObject;
                                _nonce = [dic[@"result"] decimalNumberFromHexString];
                                
                                NSDecimalNumber *val = [NSDecimalNumber decimalNumberWithString:inbNumber];
                                NSDecimalNumber *bitVal = [val decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:kWei]];
                                @try {
                                    _signResult = [WalletManager ethSignTransactionWithWalletID:walletID nonce:[_nonce stringValue] txType:TxType_unMortgage gasPrice:@"200000" gasLimit:@"21000" to:@"0x9518a055AB2017a0Cd3fB7D70f269C9B80092206" value:[bitVal stringValue] data:@"" password:password chainID:kChainID];
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [tmpSelf.passwordInput hidePasswordInput];
                                    });
                                    //发送第二个请求
                                    [NetworkUtil rpc_requetWithURL:rpcHost
                                                            params:@{@"jsonrpc":@"2.0",
                                                                     @"method":sendTran_MethodName,
                                                                     @"params":@[[_signResult.signedTx add0xIfNeeded]],
                                                                     @"id":@(67),
                                                                     }
                                                        completion:^(id  _Nullable responseObject, NSError * _Nullable error) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [MBProgressHUD hideHUDForView:App_Delegate.window animated:YES];
                                        });
                                                            
                                                            if (error || responseObject[@"error"]) {
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    [MBProgressHUD hideHUDForView:App_Delegate.window animated:YES];
                                                                    [MBProgressHUD showMessage:@"赎回失败" toView:App_Delegate.window afterDelay:1 animted:YES];
                                                                });
                                                                return ;
                                                            }
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                [self.passwordInput hidePasswordInput];
                                                                [MBProgressHUD hideHUDForView:App_Delegate.window animated:YES];
                                                                [MBProgressHUD showMessage:@"赎回请求发送成功" toView:App_Delegate.window afterDelay:1.5 animted:YES];
                                                                [NotificationCenter postNotificationName:NOTI_MORTGAGE_CHANGE object:nil];
//                                                               //延迟执行
                                                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                                    [self.navigationController popViewControllerAnimated:YES];
                                                                });
                                                            });
                                                            
                                                        }];
                                } @catch (NSException *exception) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [MBProgressHUD hideHUDForView:App_Delegate.window animated:YES];
                                        [MBProgressHUD showMessage:@"密码错误" toView:App_Delegate.window afterDelay:0.7 animted:YES];
                                    });
                                } @finally {
                                    
                                }
                                
                            }];
}

#pragma mark ---- Button Action
//取消输入
- (IBAction)cancelInputAction:(UIButton *)sender {
    self.inbTF.text = @"";
}
//完成
-(void)doneAction{
    if ([self.inbTF.text isEqualToString:@""] || !self.inbTF.text) {
        [MBProgressHUD showMessage:NSLocalizedString(@"message.tip.redemption.value.no", @"请输入赎回数量") toView:App_Delegate.window afterDelay:1.5 animted:YES];
        return;
    }
    __block double inbV = [self.inbTF.text doubleValue];
    if (inbV > self.canTotal) {
        [MBProgressHUD showMessage:NSLocalizedString(@"message.tip.redemption.value.overMax", @"输入INB数量超出可用值") toView:App_Delegate.window afterDelay:1.5 animted:YES];
        return;
    } 
    __block __weak typeof(self) tmpSelf = self;
    [self.view endEditing:YES];
    [ConfirmView redeemConfirmWithTitle:@"订单详情" addr:App_Delegate.selectAddr value:inbV confirm:^{
        tmpSelf.passwordInput = [PasswordInputView showPasswordInputWithConfirmClock:^(NSString * _Nonnull password) {
               [MBProgressHUD showHUDAddedTo:App_Delegate.window animated:YES];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                   [tmpSelf unMortgageAddr:App_Delegate.selectAddr walletID:App_Delegate.selectWalletID inbNumber:self.inbTF.text password:password];
                   
               });
           }];
    } cancel:^{
        
    }];
    
   
}


#pragma mark ----
-(void)setCanTotal:(double)canTotal{
    _canTotal = canTotal;
    
}
@end
