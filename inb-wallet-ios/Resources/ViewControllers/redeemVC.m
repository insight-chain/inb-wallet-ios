//
//  redeemVC.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/9/2.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "redeemVC.h"

#import "MortgageDetailVC.h"
#import "RedeemINBVC.h"

#import "RedeemCell_1.h"
#import "RedeemCell_2.h"
#import "PasswordInputView.h"

#import "LockModel.h"

#import "WalletManager.h"
#import "NetworkUtil.h"

#import "NSDate+DateString.h"

static NSString *cellId_1 = @"redeemCell_1";
static NSString *cellId_2 = @"redeemCell_2";

@interface redeemVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *redeems; //赎回中的数据
@property(nonatomic, strong) NSArray *stores; //锁仓数据

@property (nonatomic, assign) double redeemTime;
@property (nonatomic, assign) double redeemValue;

@property (nonatomic, assign) NSInteger currentBlockNumber;

@end

@implementation redeemVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NotificationCenter addObserver:self selector:@selector(redeemNoti:) name:NOTI_MORTGAGE_CHANGE object:nil];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self requestBlockHeight];
    [self request];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)request{
    __block __weak typeof(self) tmpSelf = self;
    
    NSString *url = [NSString stringWithFormat:@"%@account/search?address=%@", App_Delegate.explorerHost, [App_Delegate.selectAddr add0xIfNeeded]];
    [NetworkUtil getRequest:url params:@{} success:^(id  _Nonnull resonseObject) {
        NSLog(@"%@", resonseObject);
        double mortgagete = [resonseObject[@"mortgage"] doubleValue]; //抵押的INB
        double regular = [resonseObject[@"regular"] doubleValue]; //锁仓的INB
        NSArray *storeDTO = resonseObject[@"storeDTO"]; //锁仓
        
        NSMutableArray *arr = [LockModel mj_objectArrayWithKeyValuesArray:storeDTO];
        
        double mor = mortgagete - regular; //抵押锁仓INB - 锁仓INB
        if ( mor > 0) {
            LockModel *morM = [[LockModel alloc] init];
            morM.amount = [NSString stringWithFormat:@"%f", mor];
            morM.lockHeight = 0;
            morM.address = App_Delegate.selectAddr;
            [arr addObject:morM];
        }
        
        tmpSelf.stores = arr;
        
        /** 赎回中 **/
        double redeemValue = [resonseObject[@"redeemValue"] doubleValue]; //赎回中的INB
        int redeemBlock = [resonseObject[@"redeemStartHeight"] intValue];//赎回开始区块
        tmpSelf.redeems = @[@{@"redeemValue":@(redeemValue),
                            @"redeemBlock":@(redeemBlock),
                            }]; //正在赎回的数据
        
        [tmpSelf.tableView reloadData];
        
    } failed:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

//查询抵押数据 
-(void)requestMortagaData{
    __block __weak typeof(self) tmpSelf = self;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [NetworkUtil rpc_requetWithURL:delegate.rpcHost
                            params:@{@"jsonrpc":@"2.0",
                                     @"method":getAccountInfo_MethodName,
                                     @"params":@[[App_Delegate.selectAddr add0xIfNeeded]],
                                     @"id":@(67),
                                     } completion:^(id  _Nullable responseObject, NSError * _Nullable error) {
                                         
                                         if (error) {
                                             return ;
                                         }
                                         NSDictionary *result = responseObject[@"result"];
                                         if(result == nil || !result || [result isKindOfClass:[NSNull class]]){
                                             return;
                                         }
                                         
                                         NSString *regular = [NSString stringWithFormat:@"%@", result[@"Regular"]]; //锁仓的数据
                                         tmpSelf.redeems = result[@"Redeems"]; //正在赎回的数据
                                         NSDictionary *Resources = result[@"Resources"]; //抵押的数据
                                         NSDictionary *net = Resources[@"NET"];
                                         
                                         NSDecimalNumber *dd = [[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",net[@"MortgagteINB"]]] decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithString:regular]];
                                         
                                         NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:result[@"Stores"]];
                                         NSDictionary *netDic = @{@"Days":@(0),
                                                                  @"Value":[dd stringValue],
                                                                  };
                                         NSString *moeValue = [NSString stringWithFormat:@"%@", netDic[@"Value"]];
                                         if (![moeValue isEqualToString:@"0"]) {
                                             [tmpArr addObject:netDic];
                                         }
                                         tmpSelf.stores = tmpArr; //锁仓记录
                                         
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             [tmpSelf.tableView reloadData];
                                         });    
                                     }];
    
}
//获取当前块高度
-(void)requestBlockHeight{
    __block __weak typeof(self) tmpSelf = self;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [NetworkUtil rpc_requetWithURL:delegate.rpcHost
                            params:@{@"jsonrpc":@"2.0",
                                     @"method":blockNumber_MethodName,
                                     @"params":@[[App_Delegate.selectAddr add0xIfNeeded]],
                                     @"id":@(67),
                                     } completion:^(id  _Nullable responseObject, NSError * _Nullable error) {
                                         
                                         if (error) {
                                             return ;
                                         }
                                         
                                         NSString *str = responseObject[@"result"];
                                         const char *hexChar = [str cStringUsingEncoding:NSUTF8StringEncoding];
                                         int hexNumber;
                                         sscanf(hexChar, "%x", &hexNumber);
                                         tmpSelf.currentBlockNumber = hexNumber;
                                     }];
}
#pragma mark ---- Notification Action
-(void)redeemNoti:(NSNotification *)noti{
    [self request];
}

#pragma mark ----
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
                                NSDecimalNumber *bitVal = [val decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:kWei]];
                                _signResult = [WalletManager ethSignTransactionWithWalletID:walletID nonce:[_nonce stringValue] txType:TxType_rewardLock gasPrice:@"200000" gasLimit:@"21000" to:@"0x95aa18a055AB2017a0Cd3fB7D70f269C9B80092206" value:[bitVal stringValue] data:[[[NSString stringWithFormat:@"ReceiveLockedAward:%@", rewardNonce] hexString] add0xIfNeeded] password:password chainID:kChainID];
                                
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

//领取赎回
-(void)rewardRedemptionWithAddr:(NSString *)addr walletID:(NSString *)walletID password:(NSString *)password{
    __weak typeof(self) tmpSelf = self;
    __block __weak NSDecimalNumber *_nonce;
    
    __block TransactionSignedResult *_signResult;
    
    NSString *rpcHost = App_Delegate.rpcHost;
    //创建穿行队列
    dispatch_queue_t customQuue = dispatch_queue_create("receiveRedemp.network", DISPATCH_QUEUE_SERIAL);
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
                                NSDecimalNumber *bitVal = [val decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:kWei]];
                                _signResult = [WalletManager ethSignTransactionWithWalletID:walletID nonce:[_nonce stringValue] txType:TxType_receive gasPrice:@"200000" gasLimit:@"21000" to:@"0x95aa18a055AB2017a0Cd3fB7D70f269C9B80092206" value:[bitVal stringValue] data:@"" password:password chainID:kChainID];
                                
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

//计算收益
-(void)calculateEarnings:(double)lockNumber rate:(double)rate lastReceiveTime:(double)lastReceiveTime{
    //当前能解锁仓领取的钱数：
//    1.锁仓时间不到最后期限：（当前最新区块的时间-上次领取时间）/86400*年化（整年）/365*锁仓额度
//    2.锁仓时间超过最后期限：（（最后期限时间-上次领取时间）/86400*年化（整年）/365*锁仓额度）+锁仓额度
    
    int day = [NSDate getDifferenceByDate:lastReceiveTime];
    if(day > 7){
        //锁仓时间超过最后期限
        
    }else{
        
    }
    
}

#pragma mark ---- UItableViewDelegate && Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.redeems.count; //赎回中的
    }else{
        return self.stores.count; //锁仓数据
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        RedeemCell_1 *cell = [tableView dequeueReusableCellWithIdentifier:cellId_1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            UINib *nib = [UINib nibWithNibName:NSStringFromClass([RedeemCell_1 class]) bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:cellId_1];
            cell = [tableView dequeueReusableCellWithIdentifier:cellId_1];
        }
        
        NSDictionary *redemDic = self.redeems[indexPath.row];
        double redeemValue = [redemDic[@"redeemValue"] doubleValue];
        int redeemBlock = [redemDic[@"redeemBlock"] intValue];
        
        cell.value = redeemValue;
        [cell makeCurreentBlockNumber:self.currentBlockNumber startNumber:redeemBlock];
        __block __weak typeof(self) tmpSelf = self;
        cell.receiveBlock = ^{
            [PasswordInputView showPasswordInputWithConfirmClock:^(NSString * _Nonnull password) {
                __block __weak typeof(self) tmpSelf = self;
                [MBProgressHUD showHUDAddedTo:tmpSelf.view animated:YES];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    @try {
                        [self rewardRedemptionWithAddr:App_Delegate.selectAddr walletID:App_Delegate.selectWalletID password:password];
                    } @catch (NSException *exception) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MBProgressHUD hideHUDForView:tmpSelf.view animated:YES];
                            [MBProgressHUD showMessage:@"密码错误" toView:tmpSelf.view afterDelay:0.5 animted:YES];
                        });
                    } @finally {
                        
                    }
                });
            }];
        };
        return cell;
    }else{
        RedeemCell_2 *cell = [tableView dequeueReusableCellWithIdentifier:cellId_2];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            UINib *nib = [UINib nibWithNibName:NSStringFromClass([RedeemCell_2 class]) bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:cellId_2];
            cell = [tableView dequeueReusableCellWithIdentifier:cellId_2];
        }
        
        LockModel *lock = self.stores[indexPath.row];
        
        cell.model = lock;
        cell.currentBlockNumber = self.currentBlockNumber;
        
        NSInteger days = lock.days;
        double value_double = [lock.amount doubleValue];
        
        cell.mortgageValueLabel.text = [NSString stringWithFormat:@"%.4f", value_double];
        
        if(days == 0){
            cell.rewardBlock = ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    RedeemINBVC *redeemVC = [[RedeemINBVC alloc] init];
                    redeemVC.canTotal = value_double;
                    [self.navigationController pushViewController:redeemVC animated:YES];
                });
            };
        }else{
            cell.rewardBlock = ^{
                //领取奖励
                LockModel *model = self.stores[indexPath.row];
                [PasswordInputView showPasswordInputWithConfirmClock:^(NSString * _Nonnull password) {
                    __block __weak typeof(self) tmpSelf = self;
                    [MBProgressHUD showHUDAddedTo:tmpSelf.view animated:YES];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        @try {
                            [self rewardRedemptionWithAddr:App_Delegate.selectAddr walletID:App_Delegate.selectWalletID password:password];
                            [self rewardLockWithAddr:App_Delegate.selectAddr walletID:App_Delegate.selectWalletID nonce:[NSString stringWithFormat:@"%ld", (long)model.nonce] password:password];
                        } @catch (NSException *exception) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [MBProgressHUD hideHUDForView:tmpSelf.view animated:YES];
                                [MBProgressHUD showMessage:@"密码错误" toView:tmpSelf.view afterDelay:0.5 animted:YES];
                            });
                        } @finally {
                            
                        }
                    });
                }];
            };
        }
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    LockModel *model = self.stores[indexPath.row];
    
    MortgageDetailVC *detailVC = [[MortgageDetailVC alloc] initWithNibName:@"MortgageDetailVC" bundle:nil];
    detailVC.lockModel = model;
    [self.navigationController pushViewController:detailVC animated:NO];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 10)];
    view.backgroundColor = kColorBackground;
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0;
}
@end
