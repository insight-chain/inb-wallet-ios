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
#import "TransferResultView.h"
#import "PasswordInputView.h"

#import "LockModel.h"

#import "WalletManager.h"
#import "NetworkUtil.h"

#import "UIViewController+YNPageExtend.h"
#import "YNPageTableView.h"
#import "NSDate+DateString.h"

static NSString *cellId_1 = @"redeemCell_1";
static NSString *cellId_2 = @"redeemCell_2";

@interface redeemVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *redeems; //赎回中的数据
@property(nonatomic, strong) NSArray *stores; //锁仓数据

@property (nonatomic, assign) double redeemTime;
@property (nonatomic, assign) double redeemValue;

@property (nonatomic, assign) NSInteger currentBlockNumber;

@property (nonatomic, strong) PasswordInputView *passwordInput;
@end

@implementation redeemVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    [NotificationCenter addObserver:self selector:@selector(redeemNoti:) name:NOTI_MORTGAGE_CHANGE object:nil];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = kColorBackground;

    TableFooterView *footerView = [[TableFooterView alloc] init];
    self.tableView.tableFooterView = footerView;
    
    [self requestBlockHeight];
    [self request];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)request{
    __block __weak typeof(self) tmpSelf = self;
    
    [MBProgressHUD showHUDAddedTo:App_Delegate.window animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@account/search?address=%@", App_Delegate.explorerHost, [App_Delegate.selectAddr add0xIfNeeded]];
    [NetworkUtil getRequest:url params:@{} success:^(id  _Nonnull resonseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:App_Delegate.window animated:YES];
        });
        NSLog(@"%@", resonseObject);
        NSDictionary *res;
        double mortgagete;
        __block double regular;
        NSArray *storeDTO;
        
        double redeemValue;
        int redeemBlock;
        
        NSString *addr = resonseObject[@"address"];
        if (addr == nil || [addr isKindOfClass:[NSNull class]]) {
            res = @{};
            mortgagete = 0.0; //抵押的INB
            regular = 0.0; //锁仓的INB
            storeDTO = @[]; //锁仓
            
            redeemValue = 0; //赎回中的INB
            redeemBlock = 0;//赎回开始区块
            
        }else{
            res = resonseObject[@"res"];
            mortgagete = [res[@"mortgage"] doubleValue]; //抵押的INB总
            
            storeDTO = resonseObject[@"store"]; //锁仓
            
            /** 赎回中 **/
            redeemValue = [resonseObject[@"redeemValue"] doubleValue]; //赎回中的INB
            redeemBlock = [resonseObject[@"redeemStartHeight"] intValue];//赎回开始区块
        }
        
        
        NSMutableArray *arr = [LockModel mj_objectArrayWithKeyValuesArray:storeDTO]?:@[].mutableCopy;
        [arr enumerateObjectsUsingBlock:^(LockModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            regular += [obj.amount doubleValue];
        }];
        double mor = mortgagete - regular; //抵押锁仓INB - 锁仓INB
        if ( mor > 0) {
            LockModel *morM = [[LockModel alloc] init];
            morM.amount = [NSString stringWithFormat:@"%f", mor];
            morM.lockHeight = 0;
            morM.address = App_Delegate.selectAddr;
            [arr insertObject:morM atIndex:0];
        }
        
        tmpSelf.stores = arr;
        
        
        tmpSelf.redeems = @[@{@"redeemValue":@(redeemValue),
                            @"redeemBlock":@(redeemBlock),
                            }]; //正在赎回的数据
        
        [tmpSelf.tableView reloadData];
        
    } failed:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:App_Delegate.window animated:YES];
        });
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
-(void)rewardLockWithAddr:(NSString *)addr value:(double)value walletID:(NSString *)walletID nonce:(NSString *)rewardNonce password:(NSString *)password{
    __weak typeof(self) tmpSelf = self;
    __block __weak NSDecimalNumber *_nonce;
    
    __block TransactionSignedResult *_signResult;
    
    NSString *rpcHost = App_Delegate.rpcHost;
    //创建穿行队列
    dispatch_queue_t customQuue = dispatch_queue_create("rewardLock.nerwork", DISPATCH_QUEUE_SERIAL);
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
                                
                                NSDecimalNumber *val = [NSDecimalNumber decimalNumberWithString:@"0"];
                                NSDecimalNumber *bitVal = [val decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:kWei]];
                                @try {
                                    
                                    _signResult = [WalletManager ethSignTransactionWithWalletID:walletID nonce:[_nonce stringValue] txType:TxType_rewardLock gasPrice:@"200000" gasLimit:@"21000" to:App_Delegate.selectAddr value:[bitVal stringValue] data:[[NSString stringWithFormat:@"%@", rewardNonce] add0xIfNeeded] password:password chainID:kChainID];
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
                                                            
                                                            [MBProgressHUD hideHUDForView:App_Delegate.window animated:YES];
                                                            NSLog(@"%@", responseObject);
                                                            if (error) {
//                                                                [MBProgressHUD showMessage:@"领取锁仓奖励失败" toView:App_Delegate.window afterDelay:1.5 animted:YES];
                                                                [TransferResultView resultFailedWithTitle:NSLocalizedString(@"receive.reward.lock.failed", @"锁仓抵押奖励领取失败") message:[error description]];
                                                                return ;
                                                            }
                                        if(responseObject[@"error"]){
//                                            [MBProgressHUD showMessage:responseObject[@"error"][@"message"] toView:App_Delegate.window afterDelay:1.5 animted:YES];
                                            [TransferResultView resultFailedWithTitle:NSLocalizedString(@"receive.reward.lock.failed", @"锁仓抵押奖励领取失败") message:responseObject[@"error"][@"message"]];
                                            return ;
                                        }
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                [tmpSelf.passwordInput hidePasswordInput];
                                                                [TransferResultView resultSuccessRewardWithTitle:NSLocalizedString(@"receive.reward.lock.success", @"抵押锁仓奖励领取成功") value:0];
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
//
//
//        dispatch_semaphore_wait(semaphoreLock, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"任务完成");
        });
    });
}

//领取赎回
-(void)rewardRedemptionWithAddr:(NSString *)addr value:(double)value walletID:(NSString *)walletID password:(NSString *)password{
    __weak typeof(self) tmpSelf = self;
    __block __weak NSDecimalNumber *_nonce;
    
    __block TransactionSignedResult *_signResult;
    
    NSString *rpcHost = App_Delegate.rpcHost;
    //创建穿行队列
    dispatch_queue_t customQuue = dispatch_queue_create("receiveRedemp.network", DISPATCH_QUEUE_SERIAL);
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
                                
                                NSDecimalNumber *val = [NSDecimalNumber decimalNumberWithString:@"0"];
                                NSDecimalNumber *bitVal = [val decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:kWei]];
                                @try {
                                    _signResult = [WalletManager ethSignTransactionWithWalletID:walletID nonce:[_nonce stringValue] txType:TxType_receive gasPrice:@"200000" gasLimit:@"21000" to:@"0x9518a055AB2017a0Cd3fB7D70f269C9B80092206" value:[bitVal stringValue] data:@"" password:password chainID:kChainID];
                                    //发送第二个请求
                                    [NetworkUtil rpc_requetWithURL:rpcHost
                                                            params:@{@"jsonrpc":@"2.0",
                                                                     @"method":sendTran_MethodName,
                                                                     @"params":@[[_signResult.signedTx add0xIfNeeded]],
                                                                     @"id":@(67),
                                                                     }
                                                        completion:^(id  _Nullable responseObject, NSError * _Nullable error) {
                                        [tmpSelf.passwordInput hidePasswordInput];
                                                            [MBProgressHUD hideHUDForView:App_Delegate.window animated:YES];
                                                            NSLog(@"%@", responseObject);
                                                            if (error ) {
//                                                                [MBProgressHUD showMessage:@"领取赎回失败" toView:App_Delegate.window afterDelay:1.5 animted:YES];
                                                                [TransferResultView resultFailedWithTitle:NSLocalizedString(@"receive.redemption.failed", @"领取赎回失败") message:[error description]];
                                                                return ;
                                                            }
                                        if(responseObject[@"error"]){
                                            [MBProgressHUD showMessage:responseObject[@"error"][@"message"] toView:App_Delegate.window afterDelay:1.5 animted:YES];
                                            [TransferResultView resultFailedWithTitle:NSLocalizedString(@"receive.redemption.failed", @"领取赎回失败") message:responseObject[@"error"][@"message"]];
                                            return ;
                                        }
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                [tmpSelf.passwordInput hidePasswordInput];
                                                                [TransferResultView resultSuccessRewardWithTitle:NSLocalizedString(@"receive.redemption.success", @"领取赎回成功") value:value];
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
                                }
                                
                            }];
        
//        //相当于枷锁
//        dispatch_semaphore_wait(semaphoreLock, DISPATCH_TIME_FOREVER);
//
//
//        dispatch_semaphore_wait(semaphoreLock, DISPATCH_TIME_FOREVER);
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *redemDic = self.redeems[indexPath.row];
        double redeemValue = [redemDic[@"redeemValue"] doubleValue];
        int redeemBlock = [redemDic[@"redeemBlock"] intValue];
        
        cell.value = redeemValue;
        [cell makeCurreentBlockNumber:self.currentBlockNumber startNumber:redeemBlock];
        __block __weak typeof(self) tmpSelf = self;
        cell.receiveBlock = ^{
            tmpSelf.passwordInput = [PasswordInputView showPasswordInputWithConfirmClock:^(NSString * _Nonnull password) {
                __block __weak typeof(self) tmpSelf = self;
                [MBProgressHUD showHUDAddedTo:App_Delegate.window animated:YES];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    @try {
                        [self rewardRedemptionWithAddr:App_Delegate.selectAddr value:redeemValue walletID:App_Delegate.selectWalletID password:password];
                    } @catch (NSException *exception) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MBProgressHUD hideHUDForView:App_Delegate.window animated:YES];
                            [MBProgressHUD showMessage:@"密码错误" toView:App_Delegate.window afterDelay:0.7 animted:YES];
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
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        LockModel *lock = self.stores[indexPath.row];
        
        cell.model = lock;
        cell.currentBlockNumber = self.currentBlockNumber;
        
        NSInteger days = lock.days;
        double value_double = [lock.amount doubleValue];
        
//        cell.mortgageValueLabel.text = [NSString stringWithFormat:@"%.4f", value_double];
        __weak __block typeof(self) tmpSelf = self;
        if(days == 0){
            cell.rewardBlock = ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    RedeemINBVC *redeemVC = [[RedeemINBVC alloc] init];
                    redeemVC.title = NSLocalizedString(@"transfer.typeName.redemption.apply", @"抵押赎回");
                    redeemVC.canTotal = value_double;
                    [tmpSelf.navigationController pushViewController:redeemVC animated:YES];
                });
            };
        }else{
            cell.rewardBlock = ^{
                //领取奖励
                LockModel *model = self.stores[indexPath.row];
                tmpSelf.passwordInput = [PasswordInputView showPasswordInputWithConfirmClock:^(NSString * _Nonnull password) {
                    __block __weak typeof(self) tmpSelf = self;
                    [MBProgressHUD showHUDAddedTo:App_Delegate.window animated:YES];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        @try {
//                            [self rewardRedemptionWithAddr:App_Delegate.selectAddr walletID:App_Delegate.selectWalletID password:password];
                            [self rewardLockWithAddr:App_Delegate.selectAddr value:0 walletID:App_Delegate.selectWalletID nonce:model.hashStr password:password];
                        } @catch (NSException *exception) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [MBProgressHUD hideHUDForView:App_Delegate.window animated:YES];
                                [MBProgressHUD showMessage:@"密码错误" toView:App_Delegate.window afterDelay:0.7 animted:YES];
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
    
    if(indexPath.section == 0){
        return;
    }
    LockModel *model = self.stores[indexPath.row];
    
    if (model.days == 0) {
        return;
    }
    
    MortgageDetailVC *detailVC = [[MortgageDetailVC alloc] initWithNibName:@"MortgageDetailVC" bundle:nil];
    detailVC.navigationItem.title = NSLocalizedString(@"Resource.mortgage.detail", @"抵押详情");
    detailVC.lockModel = model;
    [self.navigationController pushViewController:detailVC animated:NO];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 20+20)];
        UILabel *morL = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 120, 20)];
        morL.textColor = kColorWithHexValue(0x333333);
        morL.font = [UIFont systemFontOfSize:16];
        morL.text = NSLocalizedString(@"Resource.redemptioning", @"正在赎回");
        
        [headerV addSubview:morL];
        return headerV;
    }else{
        
        UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 20)];
        UILabel *listL = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 120, 20)];
        listL.textColor = kColorWithHexValue(0x333333);
        listL.font = [UIFont systemFontOfSize:16];
        listL.text = NSLocalizedString(@"Resource.mortgageList", @"抵押列表");
        
        [headerV addSubview:listL];
        return headerV;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 20+20;
    }else{
        return 20;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 10)];
    view.backgroundColor = kColorBackground;
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[YNPageTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
    }
    return _tableView;
}
@end


#pragma mark --- tableFooterView

@interface TableFooterView ()
@property (nonatomic, strong) UILabel *tipLabel_1;
@property (nonatomic, strong) UILabel *tipLabel_2;
@property (nonatomic, strong) UILabel *tipLabel_3;
@property (nonatomic, strong) UILabel *tipLabel_4;
@end

@implementation TableFooterView

-(instancetype)init{
    if (self = [super init]) {
        self.tipLabel_1.text = NSLocalizedString(@"tip.resource.redemption_1", @"抵押提示文字");
        self.tipLabel_2.text = NSLocalizedString(@"tip.resource.redemption_2", @"抵押提示文字");
        self.tipLabel_3.text = NSLocalizedString(@"tip.resource.redemption_3", @"抵押提示文字");
        self.tipLabel_4.text = NSLocalizedString(@"tip.resource.redemption_4", @"抵押提示文字");
        
        [self addSubview:self.tipLabel_1];
        [self addSubview:self.tipLabel_2];
        [self addSubview:self.tipLabel_3];
        [self addSubview:self.tipLabel_4];
        [self makeConstrants];
        
        [self layoutIfNeeded];
        CGFloat height = CGRectGetMaxY(self.tipLabel_4.frame)+30;
        self.frame = CGRectMake(0, 0, KWIDTH, height);
    }
    return self;
}

-(void)makeConstrants{
    [self.tipLabel_1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).mas_offset(20);
        make.left.mas_equalTo(self).mas_offset(15);
        make.right.mas_equalTo(self).mas_offset(-15);
    }];
    [self.tipLabel_2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipLabel_1.mas_bottom).mas_offset(5);
        make.left.right.mas_equalTo(self.tipLabel_1);
    }];
    [self.tipLabel_3 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipLabel_2.mas_bottom).mas_offset(5);
        make.left.right.mas_equalTo(self.tipLabel_2);
    }];
    [self.tipLabel_4 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipLabel_3.mas_bottom).mas_offset(5
                                                                    );
        make.left.right.mas_equalTo(self.tipLabel_3);
    }];
}

-(UILabel *)tipLabel_1{
    if (_tipLabel_1 == nil) {
        _tipLabel_1 = [[UILabel alloc] init];
        _tipLabel_1.font = [UIFont systemFontOfSize:13];
        _tipLabel_1.textColor = kColorAuxiliary2;
        _tipLabel_1.lineBreakMode = NSLineBreakByCharWrapping;
        _tipLabel_1.numberOfLines = 0;
    }
    return _tipLabel_1;
}
-(UILabel *)tipLabel_2{
    if (_tipLabel_2 == nil) {
        _tipLabel_2 = [[UILabel alloc] init];
        _tipLabel_2.font = [UIFont systemFontOfSize:13];
        _tipLabel_2.textColor = kColorAuxiliary2;
        _tipLabel_2.lineBreakMode = NSLineBreakByCharWrapping;
        _tipLabel_2.numberOfLines = 0;
    }
    return _tipLabel_2;
}
-(UILabel *)tipLabel_3{
    if (_tipLabel_3 == nil) {
        _tipLabel_3 = [[UILabel alloc] init];
        _tipLabel_3.font = [UIFont systemFontOfSize:13];
        _tipLabel_3.textColor = kColorAuxiliary2;
        _tipLabel_3.lineBreakMode = NSLineBreakByCharWrapping;
        _tipLabel_3.numberOfLines = 0;
    }
    return _tipLabel_3;
}
-(UILabel *)tipLabel_4{
    if (_tipLabel_4 == nil) {
        _tipLabel_4 = [[UILabel alloc] init];
        _tipLabel_4.font = [UIFont systemFontOfSize:13];
        _tipLabel_4.textColor = kColorAuxiliary2;
        _tipLabel_4.lineBreakMode = NSLineBreakByCharWrapping;
        _tipLabel_4.numberOfLines = 0;
    }
    return _tipLabel_4;
}
@end
