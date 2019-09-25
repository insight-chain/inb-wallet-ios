//
//  RedeemINBVC.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/9/10.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "RedeemINBVC.h"

#import "PasswordInputView.h"
#import "TransactionSignedResult.h"
#import "WalletManager.h"
#import "NetworkUtil.h"

@interface RedeemINBVC ()

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
    
    self.canUseL.text = [NSString stringWithFormat:@"可赎回 %.2f INB", _canTotal];
}
-(void)makeNavi{
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
    //创建穿行队列
    dispatch_queue_t customQuue = dispatch_queue_create("unMortgage.nerwork", DISPATCH_QUEUE_SERIAL);
    //创建信号量并初始化总量为1
    dispatch_semaphore_t semaphoreLock = dispatch_semaphore_create(0);
    
    
    
    //添加任务
    dispatch_async(customQuue, ^{
        //发送第一个请求
        [NetworkUtil rpc_requetWithURL:rpcHost
                                params:@{@"jsonrpc":@"2.0",
                                         @"method":nonce_MethodName,
                                         @"params":@[[addr add0xIfNeeded],@"latest"],@"id":@(1)}
                            completion:^(id  _Nullable responseObject, NSError * _Nullable error) {
                                if (error) {
                                    [MBProgressHUD hideHUDForView:tmpSelf.view animated:YES];
                                    return ;
                                }
                                NSDictionary *dic = (NSDictionary *)responseObject;
                                _nonce = [dic[@"result"] decimalNumberFromHexString];
                                
                                NSDecimalNumber *val = [NSDecimalNumber decimalNumberWithString:inbNumber];
                                NSDecimalNumber *bitVal = [val decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:kWei]];
                                _signResult = [WalletManager ethSignTransactionWithWalletID:walletID nonce:[_nonce stringValue] txType:TxType_unMortgage gasPrice:@"200000" gasLimit:@"21000" to:@"0x9518a055AB2017a0Cd3fB7D70f269C9B80092206" value:[bitVal stringValue] data:[[@"unmortgageNet" hexString] add0xIfNeeded] password:password chainID:kChainID];
                                
                                //dispatch_semaphore_signal发送一个信号，让信号总量加1,相当于解锁
                                dispatch_semaphore_signal(semaphoreLock);
                            }];
        //相当于枷锁
        dispatch_semaphore_wait(semaphoreLock, DISPATCH_TIME_FOREVER);
        
        //发送第二个请求
        [NetworkUtil rpc_requetWithURL:rpcHost
                                params:@{@"jsonrpc":@"2.0",
                                         @"method":sendTran_MethodName,
                                         @"params":@[[_signResult.signedTx add0xIfNeeded]],
                                         @"id":@(67),
                                         }
                            completion:^(id  _Nullable responseObject, NSError * _Nullable error) {
                                
                                [MBProgressHUD hideHUDForView:tmpSelf.view animated:YES];
                                NSLog(@"%@", responseObject);
                                if (error) {
                                    return ;
                                }
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [MBProgressHUD showMessage:@"赎回请求发送成功" toView:tmpSelf.view afterDelay:0.5 animted:YES];
                                    [NotificationCenter postNotificationName:NOTI_MORTGAGE_CHANGE object:nil];
                                });
                                
                                //dispatch_semaphore_signal发送一个信号，让信号总量加1,相当于解锁
                                dispatch_semaphore_signal(semaphoreLock);
                            }];
        dispatch_semaphore_wait(semaphoreLock, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"任务完成");
        });
    });
}

#pragma mark ---- Button Action
//取消输入
- (IBAction)cancelInputAction:(UIButton *)sender {
    self.inbTF.text = @"";
}
//完成
-(void)doneAction{
    
    __block double inbV = [self.inbTF.text doubleValue];
    if (inbV > self.canTotal) {
        [MBProgressHUD showMessage:@"输入INB数量超出可用值" toView:self.view afterDelay:0.5 animted:YES];
        return;
    } 
    __block __weak typeof(self) tmpSelf = self;
    [PasswordInputView showPasswordInputWithConfirmClock:^(NSString * _Nonnull password) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        });
        
        @try {
            [tmpSelf unMortgageAddr:App_Delegate.selectAddr walletID:App_Delegate.selectWalletID inbNumber:self.inbTF.text password:password];
        } @catch (NSException *exception) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showMessage:@"密码错误" toView:tmpSelf.view afterDelay:0.5 animted:YES];
            });
        } @finally {
            [MBProgressHUD hideHUDForView:tmpSelf.view animated:YES];
        }
        
    }];
    
    
    
//    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark ----
-(void)setCanTotal:(double)canTotal{
    _canTotal = canTotal;
    
}
@end
