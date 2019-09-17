//
//  ResourceVC.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/8.
//  Copyright © 2019 apple. All rights reserved.
//

#import "ResourceVC.h"

#import "WalletManager.h"
#import "PasswordInputView.h"
#import "ResourceCPUView.h"
#import "SliderBar.h"
#import "NetWorkUtil.h"

@interface ResourceVC ()

@property(nonatomic, strong) ResourceCPUView *cpuView;

@property(nonatomic, strong) UILabel *mortgageLabel; //抵押
@property(nonatomic, strong) UILabel *redemptionLabel; //赎回
@property(nonatomic, strong) UIImageView *cursorImg;//游标

@property(nonatomic, strong) UILabel *cpuMortgageLabel; //"CPU抵押"
@property(nonatomic, strong) UITextField *inbNumberTF;

@property(nonatomic, strong) UILabel *canRedemptionLabel; //"可赎回0.001 INB"

@property(nonatomic, strong) UILabel *tipLabel_1;
@property(nonatomic, strong) UILabel *tipLabel_2;
@property(nonatomic, strong) UILabel *tipLabel_3;

@property(nonatomic, strong) UIButton *confirmBtn; //确定

@property(nonatomic, assign) NSInteger selectedType; // 1-抵押，2-赎回
@end

@implementation ResourceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    /** View被导航栏遮挡问题的解决 **/
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
    [self makeConstraints];
    
  
    self.tipLabel_1.text = NSLocalizedString(@"tip.resource.mortgage_1", @"抵押提示文字");
    self.tipLabel_2.text = NSLocalizedString(@"tip.resource.mortgage_2", @"抵押提示文字");
    self.tipLabel_3.text = NSLocalizedString(@"tip.resource.mortgage_3", @"抵押提示文字");
 
    self.selectedType = 1; //默认是抵押
    self.mortgageLabel.textColor = kColorBlue;
    self.mortgageLabel.font = AdaptedBoldFontSize(16);
    self.canRedemptionLabel.text = @"";
    
    self.cpuView.balanceValue.text = [NSString stringWithFormat:@"%.5fkb",self.canUseNet];
    self.cpuView.totalValue.text = [NSString stringWithFormat:@"%.fkb", self.totalNet];
    self.cpuView.mortgageValue.text = [NSString stringWithFormat:@"%.2f INB", self.mortgageINB];
    
    [self.cpuView updataProgress]; //更新进度条图片
}
-(void)makeConstraints{
    [self.view addSubview:self.cpuView];
    [self.view addSubview:self.mortgageLabel];
    [self.view addSubview:self.redemptionLabel];
    [self.view addSubview:self.cursorImg];
    [self.view addSubview:self.cpuMortgageLabel];
    [self.view addSubview:self.inbNumberTF];
    [self.view addSubview:self.canRedemptionLabel];
    [self.view addSubview:self.tipLabel_1];
    [self.view addSubview:self.tipLabel_2];
    [self.view addSubview:self.tipLabel_3];
    [self.view addSubview:self.confirmBtn];
    
    [self.mortgageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.cpuView.mas_bottom).mas_offset(20-7);
        make.right.mas_equalTo(self.cpuView.mas_centerX).mas_offset(-35);
    }];
    [self.redemptionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mortgageLabel.mas_top);
        make.left.mas_equalTo(self.cpuView.mas_centerX).mas_offset(35);
    }];
    [self.cursorImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mortgageLabel.mas_bottom).mas_offset(5);
        make.left.right.mas_equalTo(self.mortgageLabel);
    }];
    [self.cpuMortgageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.cursorImg.mas_bottom).mas_offset(15);
        make.left.mas_equalTo(self.view).mas_offset(20);
    }];
    [self.inbNumberTF mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.cpuMortgageLabel.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(self.view).mas_offset(15);
        make.right.mas_equalTo(self.view).mas_offset(-15);
        make.height.mas_equalTo(45);
    }];
    [self.canRedemptionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.inbNumberTF.mas_bottom).mas_offset(5);
        make.left.mas_equalTo(25);
    }];
    [self.tipLabel_1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.inbNumberTF.mas_bottom).mas_offset(20);
        make.left.right.mas_equalTo(self.inbNumberTF);
    }];
    [self.tipLabel_2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipLabel_1.mas_bottom).mas_offset(15);
        make.left.right.mas_equalTo(self.tipLabel_1);
    }];
    [self.tipLabel_3 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipLabel_2.mas_bottom).mas_offset(15);
        make.left.right.mas_equalTo(self.tipLabel_2);
    }];
    [self.confirmBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipLabel_3.mas_bottom).mas_offset(30);
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(195);
        make.height.mas_equalTo(40);
    }];
}
#pragma mark ---- Button Action
//点击抵押
-(void)mortgageAction:(UITapGestureRecognizer *)gesture{
    self.canRedemptionLabel.text = @"";
    
    self.selectedType = 1; //默认是抵押
    self.mortgageLabel.textColor = kColorBlue;
    self.mortgageLabel.font = AdaptedBoldFontSize(16);
    self.redemptionLabel.textColor = kColorAuxiliary2;
    self.redemptionLabel.font = AdaptedFontSize(16);
    [self.tipLabel_1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.inbNumberTF.mas_bottom).mas_offset(20);
        make.left.right.mas_equalTo(self.inbNumberTF);
    }];
    [self.cursorImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mortgageLabel.mas_bottom).mas_offset(5);
        make.left.right.mas_equalTo(self.mortgageLabel);
    }];
//    [self.cursorImg updateConstraintsIfNeeded];
//    [self.cursorImg layoutIfNeeded];
    self.tipLabel_1.text = NSLocalizedString(@"tip.resource.mortgage_1", @"抵押提示文字");
    self.tipLabel_2.text = NSLocalizedString(@"tip.resource.mortgage_2", @"抵押提示文字");
    self.tipLabel_3.text = NSLocalizedString(@"tip.resource.mortgage_3", @"抵押提示文字");
}
//赎回
-(void)redemptionAction:(UITapGestureRecognizer *)gesture{
    
    self.canRedemptionLabel.text = [NSString stringWithFormat:@"可用余额 %.4f INB", self.mortgageINB];
    
    self.selectedType = 2; //默认是抵押
    self.mortgageLabel.textColor = kColorAuxiliary2;
    self.mortgageLabel.font = AdaptedFontSize(16);
    self.redemptionLabel.textColor = kColorBlue;
    self.redemptionLabel.font = AdaptedBoldFontSize(16);
    [self.tipLabel_1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.canRedemptionLabel.mas_bottom).mas_offset(15);
        make.left.right.mas_equalTo(self.inbNumberTF);
    }];
    [self.cursorImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.redemptionLabel.mas_bottom).mas_offset(5);
        make.left.right.mas_equalTo(self.redemptionLabel);
    }];
//    [self.cursorImg updateConstraintsIfNeeded];
//    [self.cursorImg layoutIfNeeded];
    self.tipLabel_1.text = NSLocalizedString(@"tip.resource.redemption_1", @"赎回提示文字");
    self.tipLabel_2.text = NSLocalizedString(@"tip.resource.redemption_2", @"赎回提示文字");
    self.tipLabel_3.text = NSLocalizedString(@"tip.resource.redemption_3", @"赎回提示文字");
}
//取消INB数量
-(void)cancelInbNumberAction:(UIButton *)sender{
    self.inbNumberTF.text = @"";
}
//确认
-(void)confirmAction:(UIButton *)sender{
//    if(self.selectedType == 1){ //抵押
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [PasswordInputView showPasswordInputWithConfirmClock:^(NSString * _Nonnull password) {
            __block __weak typeof(self) tmpSelf = self;
            [MBProgressHUD showHUDAddedTo:tmpSelf.view animated:YES];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                @try {
//                    TransactionSignedResult *signResult = [WalletManager inbMortgageWithWalletID:tmpSelf.walletID value:tmpSelf.inbNumberTF.text password:password chainID:891];
//                    [NetworkUtil rpc_requetWithURL:delegate.rpcHost params:@{@"jsonrpc":@"2.0",
//                                                                    @"method":@"eth_getTransactionCount",
//                                                                    @"params":@[[self.address add0xIfNeeded],@"latest"],@"id":@(1)}
//                                        completion:^(id  _Nullable responseObject, NSError * _Nullable error) {
//                                            if (error) {
//                                                [MBProgressHUD hideHUDForView:tmpSelf.view animated:YES];
//                                                return ;
//                                            }
//                                            NSDictionary *dic = (NSDictionary *)responseObject;
//                                            NSDecimalNumber *nonce = [dic[@"result"] decimalNumberFromHexString];
////                                            NSDecimalNumber *dd;
////                                            if([nonce integerValue] != 0){
////                                                 dd = [nonce decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:@"1"]];
////                                            }else{
////                                                dd = nonce;
////                                            }
//                                            NSDecimalNumber *val = [NSDecimalNumber decimalNumberWithString:tmpSelf.inbNumberTF.text];
//                                            NSDecimalNumber *bitVal = [val decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"1000000000000000000"]];
//                                            TransactionSignedResult *signResult = [WalletManager ethSignTransactionWithWalletID:tmpSelf.walletID nonce:[nonce stringValue] txType:self.selectedType == 1?TxType_moetgage:TxType_unMortgage gasPrice:@"200000" gasLimit:@"21000" to:@"0x95aa18a055AB2017a0Cd3fB7D70f269C9B80092206" value:[bitVal stringValue] data:[[self.selectedType == 1 ? @"mortgageNet":@"unmortgageNet" hexString] add0xIfNeeded] password:password chainID:kChainID];
//
//                                            [NetworkUtil rpc_requetWithURL:delegate.rpcHost
//                                                                    params:@{@"jsonrpc":@"2.0",
//                                                                             @"method":self.selectedType == 1 ? @"eth_mortgageRawNet":@"eth_unMortgageRawNet",
//                                                                             @"params":@[[signResult.signedTx add0xIfNeeded]],
//                                                                             @"id":@(67),
//                                                                             }
//                                                                completion:^(id  _Nullable responseObject, NSError * _Nullable error) {
//                                                                    [MBProgressHUD hideHUDForView:tmpSelf.view animated:YES];
//                                                                    NSLog(@"%@", responseObject);
//                                                                    if (error) {
//                                                                        return ;
//                                                                    }
//                                                                    dispatch_async(dispatch_get_main_queue(), ^{
//                                                                        [NotificationCenter postNotificationName:NOTI_MORTGAGE_CHANGE object:nil];
//                                                                    });
//                                                                }];
//                                        }];
                    
                    
//                    [self mortgageAddr:self.address walletID:tmpSelf.walletID inbNumber:tmpSelf.inbNumberTF.text password:password];
//                    [self lockAddr:self.address days:@"30" walletID:tmpSelf.walletID inbNumber:tmpSelf.inbNumberTF.text password:password];
                    
//                    [self unMortgageAddr:self.address walletID:tmpSelf.walletID inbNumber:tmpSelf.inbNumberTF.text password:password];
                    [self rewardLockWithAddr:self.address walletID:self.walletID nonce:@"2" password:password];
                  
                } @catch (NSException *exception) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:tmpSelf.view animated:YES];
                        [MBProgressHUD showMessage:@"密码错误" toView:tmpSelf.view afterDelay:0.5 animted:YES];
                    });
                    
                } @finally {
                    
                }
                
            });
        }];
        
        
       
//    }else{ //赎回
//        
//    }
}

#pragma Mark ---- FTranstion Type
//抵押
-(void)mortgageAddr:(NSString *)addr walletID:(NSString *)walletID inbNumber:(NSString *)inbNumber password:(NSString *)password{
    __weak typeof(self) tmpSelf = self;
    __block __weak NSDecimalNumber *_nonce;
    
    __block TransactionSignedResult *_signResult;
    
    NSString *rpcHost = App_Delegate.rpcHost;
    //创建穿行队列
    dispatch_queue_t customQuue = dispatch_queue_create("mortgage.nerwork", DISPATCH_QUEUE_SERIAL);
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
                                NSDecimalNumber *bitVal = [val decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"1000000000000000000"]];
                                _signResult = [WalletManager ethSignTransactionWithWalletID:walletID nonce:[_nonce stringValue] txType:TxType_moetgage gasPrice:@"200000" gasLimit:@"21000" to:@"0x95aa18a055AB2017a0Cd3fB7D70f269C9B80092206" value:[bitVal stringValue] data:[[@"mortgageNet" hexString] add0xIfNeeded] password:password chainID:kChainID];
                                
                                //dispatch_semaphore_signal发送一个信号，让信号总量加1,相当于解锁
                                dispatch_semaphore_signal(semaphoreLock);
                            }];
        //相当于枷锁
        dispatch_semaphore_wait(semaphoreLock, DISPATCH_TIME_FOREVER);
        
        //发送第二个请求
        [NetworkUtil rpc_requetWithURL:App_Delegate.rpcHost
                                params:@{@"jsonrpc":@"2.0",
                                         @"method":mortgage_MethodName,
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
//锁仓
-(void)lockAddr:(NSString *)addr days:(NSString *)days walletID:(NSString *)walletID inbNumber:(NSString *)inbNumber password:(NSString *)password{
    __weak typeof(self) tmpSelf = self;
    __block __weak NSDecimalNumber *_nonce;
    
    __block TransactionSignedResult *_signResult;
    
    NSString *rpcHost = App_Delegate.rpcHost;
    //创建穿行队列
    dispatch_queue_t customQuue = dispatch_queue_create("lock.nerwork", DISPATCH_QUEUE_SERIAL);
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
                                NSDecimalNumber *bitVal = [val decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"1000000000000000000"]];
                                _signResult = [WalletManager ethSignTransactionWithWalletID:walletID nonce:[_nonce stringValue] txType:TxType_lock gasPrice:@"200000" gasLimit:@"21000" to:@"0x95aa18a055AB2017a0Cd3fB7D70f269C9B80092206" value:[bitVal stringValue] data:[[[NSString stringWithFormat:@"days:%@",days] hexString] add0xIfNeeded] password:password chainID:kChainID];
                                
                                //dispatch_semaphore_signal发送一个信号，让信号总量加1,相当于解锁
                                dispatch_semaphore_signal(semaphoreLock);
                            }];
        //相当于枷锁
        dispatch_semaphore_wait(semaphoreLock, DISPATCH_TIME_FOREVER);
        
        //发送第二个请求
        [NetworkUtil rpc_requetWithURL:App_Delegate.rpcHost
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
                                NSDecimalNumber *bitVal = [val decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"1000000000000000000"]];
                                _signResult = [WalletManager ethSignTransactionWithWalletID:walletID nonce:[_nonce stringValue] txType:TxType_unMortgage gasPrice:@"200000" gasLimit:@"21000" to:@"0x95aa18a055AB2017a0Cd3fB7D70f269C9B80092206" value:[bitVal stringValue] data:[[@"unmortgageNet" hexString] add0xIfNeeded] password:password chainID:kChainID];
                                
                                //dispatch_semaphore_signal发送一个信号，让信号总量加1,相当于解锁
                                dispatch_semaphore_signal(semaphoreLock);
                            }];
        //相当于枷锁
        dispatch_semaphore_wait(semaphoreLock, DISPATCH_TIME_FOREVER);
        
        //发送第二个请求
        [NetworkUtil rpc_requetWithURL:App_Delegate.rpcHost
                                params:@{@"jsonrpc":@"2.0",
                                         @"method":unMortgage_MethodName,
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
//领取锁仓奖励
-(void)rewardLockWithAddr:(NSString *)addr walletID:(NSString *)walletID nonce:(NSString *)rewardNonce password:(NSString *)password{
    __weak typeof(self) tmpSelf = self;
    __block __weak NSDecimalNumber *_nonce;
    
    __block TransactionSignedResult *_signResult;
    
    NSString *rpcHost = App_Delegate.rpcHost;
    //创建穿行队列
    dispatch_queue_t customQuue = dispatch_queue_create("rewardLock.nerwork", DISPATCH_QUEUE_SERIAL);
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
                                
                                NSDecimalNumber *val = [NSDecimalNumber decimalNumberWithString:@"0"];
                                NSDecimalNumber *bitVal = [val decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"1000000000000000000"]];
                                _signResult = [WalletManager ethSignTransactionWithWalletID:walletID nonce:[_nonce stringValue] txType:TxType_rewardLock gasPrice:@"200000" gasLimit:@"21000" to:@"0x95aa18a055AB2017a0Cd3fB7D70f269C9B80092206" value:[bitVal stringValue] data:[[[NSString stringWithFormat:@"ReceiveLockedAward:%@", rewardNonce] hexString] add0xIfNeeded] password:password chainID:kChainID];
                                
                                //dispatch_semaphore_signal发送一个信号，让信号总量加1,相当于解锁
                                dispatch_semaphore_signal(semaphoreLock);
                            }];
        //相当于枷锁
        dispatch_semaphore_wait(semaphoreLock, DISPATCH_TIME_FOREVER);
        
        //发送第二个请求
        [NetworkUtil rpc_requetWithURL:App_Delegate.rpcHost
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
-(ResourceCPUView *)cpuView{
    if (_cpuView == nil) {
        _cpuView = [[ResourceCPUView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, 250)];
    }
    return _cpuView;
}
-(UILabel *)mortgageLabel{
    if (_mortgageLabel == nil) {
        _mortgageLabel = [[UILabel alloc] init];
        _mortgageLabel.text = NSLocalizedString(@"mortgage", @"抵押");
        _mortgageLabel.font = AdaptedFontSize(16);
        _mortgageLabel.textColor = kColorAuxiliary2;
        _mortgageLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mortgageAction:)];
        [_mortgageLabel addGestureRecognizer:tap];
    }
    return _mortgageLabel;
}
-(UILabel *)redemptionLabel{
    if (_redemptionLabel == nil) {
        _redemptionLabel = [[UILabel alloc] init];
        _redemptionLabel.text = NSLocalizedString(@"redemption", @"赎回");
        _redemptionLabel.textColor = kColorAuxiliary2;
        _redemptionLabel.font = AdaptedFontSize(16);
        _redemptionLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(redemptionAction:)];
        [_redemptionLabel addGestureRecognizer:tap];
    }
    return _redemptionLabel;
}
-(UIImageView *)cursorImg{
    if (_cursorImg == nil) {
        _cursorImg = [[UIImageView alloc] init];
        UIImage *img =[UIImage imageNamed:@"cursor_blue"];
        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height/2.0, img.size.width/2.0, img.size.height/2.0, img.size.width/2.0) resizingMode:UIImageResizingModeStretch];
        _cursorImg.image = img;
    }
    return _cursorImg;
}
-(UILabel *)cpuMortgageLabel{
    if (_cpuMortgageLabel == nil) {
        _cpuMortgageLabel = [[UILabel alloc] init];
        _cpuMortgageLabel.text = [NSString stringWithFormat:@"NET%@", NSLocalizedString(@"mortgage", @"抵押")];
        _cpuMortgageLabel.font = AdaptedFontSize(15);
        _cpuMortgageLabel.textColor = kColorTitle;
    }
    return _cpuMortgageLabel;
}
-(UITextField *)inbNumberTF{
    if (_inbNumberTF == nil) {
        _inbNumberTF = [[UITextField alloc] init];
        _inbNumberTF.font = AdaptedFontSize(15);
        _inbNumberTF.background = [UIImage imageNamed:@"textField_bg"];
        _inbNumberTF.textColor = kColorTitle;
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 45)];
        _inbNumberTF.leftViewMode = UITextFieldViewModeAlways;
        _inbNumberTF.leftView = leftView;
        
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5+25+5, 45)];
        UIButton *cancelBtn = [[UIButton alloc] init]; //取消
        [cancelBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelInbNumberAction:) forControlEvents:UIControlEventTouchUpInside];
        [rightView addSubview:cancelBtn];
        
        [cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(25);
            make.centerY.mas_equalTo(rightView);
            make.centerX.mas_equalTo(rightView);
        }];
        _inbNumberTF.rightViewMode = UITextFieldViewModeWhileEditing;
        _inbNumberTF.rightView = rightView;
        _inbNumberTF.keyboardType = UIKeyboardTypeDecimalPad;
        NSAttributedString *paceStr= [[NSAttributedString alloc] initWithString:NSLocalizedString(@"placeholder.inbNumber.input", @"请输INB数量") attributes:@{NSFontAttributeName:_inbNumberTF.font, NSForegroundColorAttributeName:kColorAuxiliary2}];
        _inbNumberTF.attributedPlaceholder = paceStr;
    }
    return _inbNumberTF;
}

-(UILabel *)tipLabel_1{
    if (_tipLabel_1 == nil) {
        _tipLabel_1 = [[UILabel alloc] init];
        _tipLabel_1.font = AdaptedFontSize(14);
        _tipLabel_1.textColor = kColorAuxiliary2;
        _tipLabel_1.lineBreakMode = NSLineBreakByCharWrapping;
        _tipLabel_1.numberOfLines = 0;
    }
    return _tipLabel_1;
}
-(UILabel *)tipLabel_2{
    if (_tipLabel_2 == nil) {
        _tipLabel_2 = [[UILabel alloc] init];
        _tipLabel_2.font = AdaptedFontSize(14);
        _tipLabel_2.textColor = kColorAuxiliary2;
        _tipLabel_2.lineBreakMode = NSLineBreakByCharWrapping;
        _tipLabel_2.numberOfLines = 0;
    }
    return _tipLabel_2;
}
-(UILabel *)tipLabel_3{
    if (_tipLabel_3 == nil) {
        _tipLabel_3 = [[UILabel alloc] init];
        _tipLabel_3.font = AdaptedFontSize(14);
        _tipLabel_3.textColor = kColorAuxiliary2;
        _tipLabel_3.lineBreakMode = NSLineBreakByCharWrapping;
        _tipLabel_3.numberOfLines = 0;
    }
    return _tipLabel_3;
}
-(UIButton *)confirmBtn{
    if (_confirmBtn == nil) {
        _confirmBtn = [[UIButton alloc] init];
        UIImage *img = [UIImage imageNamed:@"btn_bg_blue"];
        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height/2.0, img.size.width/2.0, img.size.height/2.0, img.size.width/2.0) resizingMode:UIImageResizingModeStretch];
        [_confirmBtn setBackgroundImage:img forState:UIControlStateNormal];
        [_confirmBtn setTitle:NSLocalizedString(@"determine", @"确定") forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font = AdaptedFontSize(15);
        [_confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}
-(UILabel *)canRedemptionLabel{
    if (_canRedemptionLabel == nil) {
        _canRedemptionLabel = [[UILabel alloc] init];
        _canRedemptionLabel.font = AdaptedFontSize(13);
        _canRedemptionLabel.textColor = kColorBlue;
    }
    return _canRedemptionLabel;
}
@end
