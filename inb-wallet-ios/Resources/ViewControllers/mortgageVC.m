//
//  mortgageVC.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/9/2.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "mortgageVC.h"

#import "ConfirmView.h"
#import "MortgageView.h"
#import "PasswordInputView.h"
#import "LXAlertView.h"

#import "WalletManager.h"
#import "TransactionSignedResult.h"

#import "UIViewController+YNPageExtend.h"
#import "YNPageTableView.h"

#import "NetworkUtil.h"

#define kFooterViewHeight 750

@interface mortgageVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) MortgageView *mortgageView;
@property (nonatomic, strong) PasswordInputView *passwordInput;
@end

@implementation mortgageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    __block __weak typeof(self) tmpSelf = self;
    
    self.mortgageView.confirmBlcok = ^(NSInteger type, NSString *netValue) {
        if([netValue isEqualToString:@""] || !netValue || [netValue isEqualToString:@"0"]){
            [MBProgressHUD showMessage:NSLocalizedString(@"message.tip.mortgage.inputValue", @"请选择抵押日期") toView:App_Delegate.window afterDelay:1.5 animted:YES];
            return ;
        }
        if (type < 0) {
            [MBProgressHUD showMessage:NSLocalizedString(@"message.tip.mortgage.choseDay",@"请选择抵押日期") toView:App_Delegate.window afterDelay:1.5 animted:YES];
            return ;
        }
        [tmpSelf.view endEditing:YES];
       
        [ConfirmView lockConfirmWithTitle:@"订单详情" value:[netValue doubleValue] lockNumber:type*kDayNumbers confirm:^{
                tmpSelf.passwordInput = [PasswordInputView showPasswordInputWithConfirmClock:^(NSString * _Nonnull password) {
                           
                           dispatch_async(dispatch_get_main_queue(), ^{
                               [MBProgressHUD showHUDAddedTo:App_Delegate.window animated:YES];
                           });
                           
                           @try {
                               if(type == 0){ //普通抵押
                                   [tmpSelf mortgageAddr:tmpSelf.address walletID:tmpSelf.walletID inbNumber:netValue password:password];
                               }else if(type == 30){ //锁仓30天
                                   NSInteger block = App_Delegate.isTest ? 30*kDayNumbers/1000 : 30*kDayNumbers;
                                   NSString *blockStr = [NSString stringWithFormat:@"%ld", block];
                                   [tmpSelf lockAddr:tmpSelf.address days:blockStr walletID:tmpSelf.walletID inbNumber:netValue password:password];
                               }else if (type == 90){
                                   NSInteger block = App_Delegate.isTest ? 90*kDayNumbers/1000 : 90*kDayNumbers;
                                   NSString *blockStr = [NSString stringWithFormat:@"%ld", block];
                                   [tmpSelf lockAddr:tmpSelf.address days:blockStr walletID:tmpSelf.walletID inbNumber:netValue password:password];
                               }else if (type == 180){
                                   NSInteger block = App_Delegate.isTest ? 180*kDayNumbers/1000 : 180*kDayNumbers;
                                   NSString *blockStr = [NSString stringWithFormat:@"%ld", block];
                                   [tmpSelf lockAddr:tmpSelf.address days:blockStr walletID:tmpSelf.walletID inbNumber:netValue password:password];
                               }else if (type == 360){
                                   NSInteger block = App_Delegate.isTest ? 360*kDayNumbers/1000 : 360*kDayNumbers;
                                   NSString *blockStr = [NSString stringWithFormat:@"%ld", block];
                                   [tmpSelf lockAddr:tmpSelf.address days:blockStr walletID:tmpSelf.walletID inbNumber:netValue password:password];
                               }else if(type == 1000){
                                   //测试
                                   NSInteger block = 1000;
                                   NSString *blockStr = [NSString stringWithFormat:@"%ld", block];
                                   [tmpSelf lockAddr:tmpSelf.address days:blockStr walletID:tmpSelf.walletID inbNumber:netValue password:password];
                               }
                               
                               
                           } @catch (NSException *exception) {
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   [MBProgressHUD hideHUDForView:App_Delegate.window animated:YES];
                                   [MBProgressHUD showMessage:@"密码错误" toView:App_Delegate.window afterDelay:0.7 animted:YES];
                               });
                           } @finally {
                               [MBProgressHUD hideHUDForView:App_Delegate.window animated:YES];
                           }
                           
                           
                       }];
        } cancel:^{
                
        }];
       
        
       
        
    };

    self.mortgageView.doubtBlock = ^{
        NSString *str = @"年化收益率是INB锁仓抵押按照365天计算的收益水平，是对抵押资产365天盈利水平的反映。\n\n举例:\n在抵押锁仓时选择129.6万≈30天抵押期限，年化收益率为0.5%，则表示从锁仓抵押成功开始算起，七天后的收益=抵押金额X年化率X（7/365），即锁仓抵押10000 INB，7天后获利0.9589 INB。\n\n温馨提示\n年化收益率并不固定，INB公链会根据情况做出改动。";
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str attributes: @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:kColorWithHexValue(0x333333)}];
        [attr setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]} range:[str rangeOfString:@"举例:"]];
        [attr setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]} range:[str rangeOfString:@"温馨提示"]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIButton *sender = [[UIButton alloc] init];
            LXAlertView * alertView = [[LXAlertView alloc] initTipsLongMessageAlert:sender titleContent:@"年化率" messageContent:attr certainButtonTitle:@"我知道了" certainFun:@"cancelAction"];
            alertView.delegateId = tmpSelf;
            [alertView showLXAlertViewWithFlag:0];
        });
    };
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];//消除group类型的空白
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, kFooterViewHeight)];
    [footerView addSubview:self.mortgageView];
    self.tableView.tableFooterView = footerView;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"--%@--%@", [self class], NSStringFromSelector(_cmd));
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"--%@--%@", [self class], NSStringFromSelector(_cmd));
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"--%@--%@", [self class], NSStringFromSelector(_cmd));
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"--%@--%@", [self class], NSStringFromSelector(_cmd));
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
//    dispatch_semaphore_t semaphoreLock = dispatch_semaphore_create(0);
    //添加任务
    dispatch_async(customQuue, ^{
        //发送第一个请求
        [NetworkUtil rpc_requetWithURL:rpcHost
                                params:@{@"jsonrpc":@"2.0",
                                         @"method":nonce_MethodName,
                                         @"params":@[[addr add0xIfNeeded],@"latest"],@"id":@(1)}
                            completion:^(id  _Nullable responseObject, NSError * _Nullable error) {
                                if (error) {
                                    [MBProgressHUD hideHUDForView:App_Delegate.window animated:YES];
                                    return ;
                                }
                                NSDictionary *dic = (NSDictionary *)responseObject;
                                _nonce = [dic[@"result"] decimalNumberFromHexString];
                                
                                NSDecimalNumber *val = [NSDecimalNumber decimalNumberWithString:inbNumber];
                                NSDecimalNumber *bitVal = [val decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:kWei]];
                                @try {
                                    _signResult = [WalletManager ethSignTransactionWithWalletID:walletID nonce:[_nonce stringValue] txType:TxType_moetgage gasPrice:@"200000" gasLimit:@"21000" to:@"0x9518a055AB2017a0Cd3fB7D70f269C9B80092206" value:[bitVal stringValue] data:@"" password:password chainID:kChainID];
                                    //发送第二个请求
                                    [NetworkUtil rpc_requetWithURL:rpcHost
                                                            params:@{@"jsonrpc":@"2.0",
                                                                     @"method":sendTran_MethodName,
                                                                     @"params":@[[_signResult.signedTx add0xIfNeeded]],
                                                                     @"id":@(67),
                                                                     }
                                                        completion:^(id  _Nullable responseObject, NSError * _Nullable error) {
                                                            
                                                            [MBProgressHUD hideHUDForView:App_Delegate.window animated:YES];
                                                            NSLog(@"%@", responseObject);
                                                            if (error || responseObject[@"error"]) {
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    [MBProgressHUD showMessage:NSLocalizedString(@"message.tip.mortgage.error", @"抵押失败") toView:App_Delegate.window afterDelay:1 animted:YES];
                                                                    return ;
                                                                });
                                                                return ;
                                                            }
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                [tmpSelf.passwordInput hidePasswordInput];
                                                                [MBProgressHUD showMessage:NSLocalizedString(@"message.tip.mortgage.success", @"抵押成功") toView:App_Delegate.window afterDelay:1 animted:YES];
                                                                [NotificationCenter postNotificationName:NOTI_MORTGAGE_CHANGE object:nil];
                                                            });
                                                            
//                                                            //dispatch_semaphore_signal发送一个信号，让信号总量加1,相当于解锁
//                                                            dispatch_semaphore_signal(semaphoreLock);
                                                        }];
                                } @catch (NSException *exception) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [MBProgressHUD hideHUDForView:App_Delegate.window animated:YES];
                                        [MBProgressHUD showMessage:@"密码错误" toView:App_Delegate.window afterDelay:0.7 animted:YES];
                                    });
                                    return;
                                } @finally {
                                    if(!_signResult){
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            return ;
                                        });
                                    }
                                    //dispatch_semaphore_signal发送一个信号，让信号总量加1,相当于解锁
//                                    dispatch_semaphore_signal(semaphoreLock);
                                }
                                
                                
                            }];
        
        //相当于枷锁
//        dispatch_semaphore_wait(semaphoreLock, DISPATCH_TIME_FOREVER);
//
//
//        dispatch_semaphore_wait(semaphoreLock, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"任务完成");
        });
    });
    
    
}
//锁仓
-(void)lockAddr:(NSString *)addr days:(NSString *)days walletID:(NSString *)walletID inbNumber:(NSString *)inbNumber password:(NSString *)password{
    
    if(self.lockingNumber >= 5){
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:App_Delegate.window animated:YES];
            [MBProgressHUD showMessage:NSLocalizedString(@"message.tip.mortgage.err.noNumber", @"锁仓抵押已满5次，无法继续抵押") toView:App_Delegate.window afterDelay:1.5 animted:YES];
        });
        return;
    }
    __weak typeof(self) tmpSelf = self;
    __block __weak NSDecimalNumber *_nonce;
    
    __block TransactionSignedResult *_signResult;
    
    NSString *rpcHost = App_Delegate.rpcHost;
    //创建穿行队列
    dispatch_queue_t customQuue = dispatch_queue_create("lock.nerwork", DISPATCH_QUEUE_SERIAL);
    //创建信号量并初始化总量为1
//    dispatch_semaphore_t semaphoreLock = dispatch_semaphore_create(0);
    
    
    //添加任务
    dispatch_async(customQuue, ^{
        //发送第一个请求
        [NetworkUtil rpc_requetWithURL:rpcHost
                                params:@{@"jsonrpc":@"2.0",
                                         @"method":nonce_MethodName,
                                         @"params":@[[addr add0xIfNeeded],@"latest"],@"id":@(1)}
                            completion:^(id  _Nullable responseObject, NSError * _Nullable error) {
                                if (error) {
                                    [MBProgressHUD hideHUDForView:App_Delegate.window animated:YES];
                                    return ;
                                }
                                NSDictionary *dic = (NSDictionary *)responseObject;
                                _nonce = [dic[@"result"] decimalNumberFromHexString];
                                
                                NSDecimalNumber *val = [NSDecimalNumber decimalNumberWithString:inbNumber];
                                NSDecimalNumber *bitVal = [val decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:kWei]];
                                @try {
                                    _signResult = [WalletManager ethSignTransactionWithWalletID:walletID nonce:[_nonce stringValue] txType:TxType_lock gasPrice:@"200000" gasLimit:@"21000" to:@"0x9518a055AB2017a0Cd3fB7D70f269C9B80092206" value:[bitVal stringValue] data:[[[NSString stringWithFormat:@"%@",days] hexString] add0xIfNeeded] password:password chainID:kChainID];
                                    //发送第二个请求
                                    [NetworkUtil rpc_requetWithURL:rpcHost
                                                            params:@{@"jsonrpc":@"2.0",
                                                                     @"method":sendTran_MethodName,
                                                                     @"params":@[[_signResult.signedTx add0xIfNeeded]],
                                                                     @"id":@(67),
                                                                     }
                                                        completion:^(id  _Nullable responseObject, NSError * _Nullable error) {
                                                            
                                                            [MBProgressHUD hideHUDForView:App_Delegate.window animated:YES];
                                                            NSLog(@"%@", responseObject);
                                                            if (error || responseObject[@"error"]) {
                                                                [MBProgressHUD showMessage:NSLocalizedString(@"message.tip.mortgage.error", @"抵押失败") toView:App_Delegate.window afterDelay:1 animted:YES];
                                                                return ;
                                                            }
                                        
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                [tmpSelf.passwordInput hidePasswordInput];
                                                                [MBProgressHUD showMessage:NSLocalizedString(@"message.tip.mortgage.success", @"抵押成功") toView:App_Delegate.window afterDelay:1 animted:YES];
                                                                [NotificationCenter postNotificationName:NOTI_MORTGAGE_CHANGE object:nil];
                                                            });
                                                            //dispatch_semaphore_signal发送一个信号，让信号总量加1,相当于解锁
//                                                            dispatch_semaphore_signal(semaphoreLock);
                                                        }];
                                    
                                } @catch (NSException *exception) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [MBProgressHUD hideHUDForView:App_Delegate.window animated:YES];
                                        [MBProgressHUD showMessage:@"密码错误" toView:App_Delegate.window afterDelay:0.7 animted:YES];
                                    });
                                    
                                } @finally {
                                    //dispatch_semaphore_signal发送一个信号，让信号总量加1,相当于解锁
//                                    dispatch_semaphore_signal(semaphoreLock);
                                    if(!_signResult){
                                        return ;
                                    }
                                }
                                
                            }];
        //相当于枷锁
//        dispatch_semaphore_wait(semaphoreLock, DISPATCH_TIME_FOREVER);
       
//        dispatch_semaphore_wait(semaphoreLock, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"任务完成");
        });
        
    });
}

#pragma mark ---- UITableViewDatasource && Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0.00001;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}


#pragma makr ----
-(MortgageView *)mortgageView{
    if (_mortgageView == nil) {
        _mortgageView = [[MortgageView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, kFooterViewHeight)];
    }
    return _mortgageView;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[YNPageTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
@end
