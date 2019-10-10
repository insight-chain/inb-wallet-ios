//
//  mortgageVC.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/9/2.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "mortgageVC.h"

#import "MortgageView.h"
#import "PasswordInputView.h"

#import "WalletManager.h"
#import "TransactionSignedResult.h"
#import "NetworkUtil.h"

#define kFooterViewHeight 722

@interface mortgageVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) MortgageView *mortgageView;

@end

@implementation mortgageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __block __weak typeof(self) tmpSelf = self;
    
    self.mortgageView.confirmBlcok = ^(NSInteger type, NSString *netValue) {
        
        if (type < 0) {
            [MBProgressHUD showMessage:@"请选择抵押日期" toView:App_Delegate.window afterDelay:1.5 animted:YES];
            return ;
        }
        
        [PasswordInputView showPasswordInputWithConfirmClock:^(NSString * _Nonnull password) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *nn = [MBProgressHUD showHUDAddedTo:tmpSelf.view animated:YES];
                nn.bezelView.backgroundColor = kColorWithRGBA(0, 0, 0, 0.65);
            });
            
            @try {
                if(type == 0){ //普通抵押
                    [tmpSelf mortgageAddr:tmpSelf.address walletID:tmpSelf.walletID inbNumber:netValue password:password];
                }else if(type == 30){ //锁仓30天
                    NSInteger block = 30*kDayNumbers;
                    NSString *blockStr = [NSString stringWithFormat:@"%ld", block];
                    [tmpSelf lockAddr:tmpSelf.address days:blockStr walletID:tmpSelf.walletID inbNumber:netValue password:password];
                }else if (type == 90){
                    NSInteger block = 90*kDayNumbers;
                    NSString *blockStr = [NSString stringWithFormat:@"%ld", block];
                    [tmpSelf lockAddr:tmpSelf.address days:blockStr walletID:tmpSelf.walletID inbNumber:netValue password:password];
                }else if (type == 180){
                    NSInteger block = 180*kDayNumbers;
                    NSString *blockStr = [NSString stringWithFormat:@"%ld", block];
                    [tmpSelf lockAddr:tmpSelf.address days:blockStr walletID:tmpSelf.walletID inbNumber:netValue password:password];
                }else if (type == 360){
                    NSInteger block = 360*kDayNumbers;
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
                    [MBProgressHUD showMessage:@"密码错误" toView:App_Delegate.window afterDelay:0.7 animted:YES];
                });
            } @finally {
                [MBProgressHUD hideHUDForView:tmpSelf.view animated:YES];
            }
            
            
        }];
        
    };
    self.mortgageView.doubtBlock = ^{
        
    };
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];//消除group类型的空白
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, kFooterViewHeight)];
    [footerView addSubview:self.mortgageView];
    self.tableView.tableFooterView = footerView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
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
                                NSDecimalNumber *bitVal = [val decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:kWei]];
                                _signResult = [WalletManager ethSignTransactionWithWalletID:walletID nonce:[_nonce stringValue] txType:TxType_moetgage gasPrice:@"200000" gasLimit:@"21000" to:@"0x9518a055AB2017a0Cd3fB7D70f269C9B80092206" value:[bitVal stringValue] data:[[@"mortgageNet" hexString] add0xIfNeeded] password:password chainID:kChainID];
                                
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
                                NSDecimalNumber *bitVal = [val decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:kWei]];
                                _signResult = [WalletManager ethSignTransactionWithWalletID:walletID nonce:[_nonce stringValue] txType:TxType_lock gasPrice:@"200000" gasLimit:@"21000" to:@"0x9518a055AB2017a0Cd3fB7D70f269C9B80092206" value:[bitVal stringValue] data:[[[NSString stringWithFormat:@"days:%@",days] hexString] add0xIfNeeded] password:password chainID:kChainID];
                                
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

#pragma mark ---- UITableViewDatasource && Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
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

@end
