//
//  RewardVC.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/9/10.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "RewardVC.h"

#import "mortgageVC.h"
#import "VoteListVC.h"
#import "RewardRecordVC.h"
#import "MortgageDetailVC.h"
#import "RedeemINBVC.h"

#import "RedeemCell_2.h"
#import "RewardNoMortgageCell.h"

#import "TransferResultView.h"
#import "PasswordInputView.h"

#import "LockModel.h"
#import "WalletManager.h"
#import "TransactionSignedResult.h"
#import "NetworkUtil.h"
#import "MJRefresh.h"

static NSString *cellId_2 = @"redeemCell_2";
static NSString *cellId_3 = @"noMortgageCell";

@interface RewardVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UIImageView *headerBg;
@property (weak, nonatomic) IBOutlet UILabel *voteRewardValue;
@property (weak, nonatomic) IBOutlet UILabel *voteNumber;
@property (weak, nonatomic) IBOutlet UIButton *voteRewardBtn;
@property (weak, nonatomic) IBOutlet UILabel *vote_no_tip;
@property (weak, nonatomic) IBOutlet UIButton *goVoteBtn;

@property (nonatomic, strong) NSArray *stores; //抵押数据
@property (nonatomic, assign) NSInteger voteNumberValue; //投票数量
@property (nonatomic, assign) NSInteger lastReceiveVoteAwardHeight; //上次领取投票时块高度
@property (nonatomic, assign) double lastReceiveVoteAwardTime;//上次领取投票奖励的时间
@property (nonatomic, assign) NSInteger currentBlockNumber;//当前最新块高度

@property (weak, nonatomic) IBOutlet UILabel *allWaitToSendVoteReward;//全网待发放投票奖励的值
@property (weak, nonatomic) IBOutlet UILabel *rewardVoteStr;
@property (nonatomic, assign) double allWaitToSendVote; //全网待发放投票奖励
@property (nonatomic, assign) double allWaitToSendMorgage; //全网待发放抵押奖励

@property (nonatomic, strong) UIView *tableFooterView;
@property (nonatomic, strong) PasswordInputView *passwordInput;
@end

@implementation RewardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeNavigation];
    self.rewardVoteStr.text = NSLocalizedString(@"Resource.rewardType.vote", @"投票奖励");
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = kColorBackground;
    
    
    [self requestBlockHeight];
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self request];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    if(self.voteNumberValue > 0){ //参与过投票
        self.headerBg.image = [UIImage imageNamed:@"reward_vote_bg"];
        self.vote_no_tip.hidden = YES;
        self.goVoteBtn.hidden = YES;
        self.voteRewardValue.hidden = NO;
        self.voteNumber.hidden = NO;
        self.voteRewardBtn.hidden = NO;
    }else{
        self.headerBg.image = [UIImage imageNamed:@"reward_vote_no_bg"];
        self.vote_no_tip.hidden = NO;
        self.goVoteBtn.hidden = NO;
        self.voteRewardValue.hidden = YES;
        self.voteNumber.hidden = YES;
        self.voteRewardBtn.hidden = YES;
    }
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationItem.title = NSLocalizedString(@"wallet.reward", @"收益奖励");
}
-(void)makeNavigation{
    self.navigationItem.title = NSLocalizedString(@"wallet.reward", @"收益奖励");
    
    /** 导航栏返回按钮文字 **/
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];
    
    UIButton *rightBtn = [[UIButton alloc] init];
    [rightBtn setTitle:NSLocalizedString(@"reward.record.receive", @"领取记录") forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(toRecordAction:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
}

-(void)request{
    __block __weak typeof(self) tmpSelf = self;

    NSString *url = [NSString stringWithFormat:@"%@account/search?address=%@", App_Delegate.explorerHost, [App_Delegate.selectAddr add0xIfNeeded]];
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NetworkUtil getRequest:url params:@{} success:^(id  _Nonnull resonseObject) {
            NSLog(@"%@", resonseObject);
            [tmpSelf requestBlockHeight]; //请求最新快高度
            double mortgagete; //抵押的INB
            double regular; //锁仓的INB
            NSArray *storeDTO; //锁仓数组
            id oo = resonseObject[@"address"];
            if(!resonseObject[@"address"] || [resonseObject[@"address"] isKindOfClass:[NSNull class]]){
                mortgagete = 0;
                regular = 0;
                storeDTO = @[]; //锁仓
                
                tmpSelf.lastReceiveVoteAwardHeight = 0;
                tmpSelf.voteNumberValue = 0;
                
            }else{
                NSDictionary *res = resonseObject[@"res"];
                mortgagete = [res[@"mortgage"] doubleValue]; //抵押的INB
                regular = [resonseObject[@"regular"] doubleValue]; //锁仓的INB
                storeDTO = resonseObject[@"store"]; //锁仓
                
                tmpSelf.lastReceiveVoteAwardHeight = [resonseObject[@"lastReceiveVoteAwardHeight"] integerValue];
                tmpSelf.voteNumberValue = [resonseObject[@"voteNumber"] integerValue];
                
            }
            
            NSMutableArray *arr = [LockModel mj_objectArrayWithKeyValuesArray:storeDTO]?:@[].mutableCopy;
            
            double mor = mortgagete - regular;
            if ( mor > 0) {
                LockModel *morM = [[LockModel alloc] init];
                morM.amount = [NSString stringWithFormat:@"%f", mor];
                morM.lockHeight = 0;
                morM.address = App_Delegate.selectAddr;
//                [arr insertObject:morM atIndex:0];
            }
            
            tmpSelf.stores = arr;
            
            dispatch_group_leave(group);
        } failed:^(NSError * _Nonnull error) {
            dispatch_group_leave(group);
            NSLog(@"%@", error);
        }];
    });
    
    NSString *waitMorUrl = [NSString stringWithFormat:@"%@account/search?address=%@", App_Delegate.explorerHost, [@"0x9517110000000000000000000000000000000000" add0xIfNeeded]];
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NetworkUtil getRequest:waitMorUrl params:@{} success:^(id  _Nonnull resonseObject) {
            NSLog(@"%@", resonseObject);
            id oo = resonseObject[@"address"];
            if(!resonseObject[@"address"] || [resonseObject[@"address"] isKindOfClass:[NSNull class]]){
                tmpSelf.allWaitToSendMorgage = 0;
            }else{
                tmpSelf.allWaitToSendMorgage = [resonseObject[@"balance"] doubleValue]; //抵押的INB
            }
            dispatch_group_leave(group);
        } failed:^(NSError * _Nonnull error) {
            NSLog(@"%@", error);
            
            dispatch_group_leave(group);
        }];
    });
    
    NSString *waitVoteUrl = [NSString stringWithFormat:@"%@account/search?address=%@", App_Delegate.explorerHost, [@"0x9513510000000000000000000000000000000000" add0xIfNeeded]];
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NetworkUtil getRequest:waitVoteUrl params:@{} success:^(id  _Nonnull resonseObject) {
            NSLog(@"%@", resonseObject);
            id oo = resonseObject[@"address"];
            if(!resonseObject[@"address"] || [resonseObject[@"address"] isKindOfClass:[NSNull class]]){
                tmpSelf.allWaitToSendVote = 0;
            }else{
                tmpSelf.allWaitToSendVote = [resonseObject[@"balance"] doubleValue]; //抵押的INB
            }
            dispatch_group_leave(group);
        } failed:^(NSError * _Nonnull error) {
            NSLog(@"%@", error);
            
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
            NSLog(@"所有任务都完成了---wait----%.5f", self.allWaitToSendMorgage);
            tmpSelf.allWaitToSendVoteReward.text = [NSString stringWithFormat:@"%@ INB", [NSString changeNumberFormatter:[NSString stringWithFormat:@"%f",tmpSelf.allWaitToSendVote]]];
            [tmpSelf.tableView reloadData];
        });
    });
    
    
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

//点击资源信息
-(void)cpuResource{
    
    mortgageVC *firstVC = [[mortgageVC alloc] init];
    firstVC.navigationItem.title = NSLocalizedString(@"mortgage", @"抵押");
    firstVC.hidesBottomBarWhenPushed = YES;
    firstVC.mortgageConfirmBtn.hidden = NO;
    [self.navigationController pushViewController:firstVC animated:YES];
}

#pragma mark ---- UITableViewDelegate && Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.stores.count == 0){
        return 1;
    }else{
        return self.stores.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.stores.count == 0){
        RewardNoMortgageCell *norCell = [tableView dequeueReusableCellWithIdentifier:cellId_3];
        if (norCell == nil) {
            UINib *nib = [UINib nibWithNibName:NSStringFromClass([RewardNoMortgageCell class]) bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:cellId_3];
            norCell = [tableView dequeueReusableCellWithIdentifier:cellId_3];
        }
        __block __weak typeof(self) tmpSelf = self;
        norCell.goMortgage = ^{
            [tmpSelf cpuResource];
        };
        return norCell;
    }else{
    RedeemCell_2 *cell = [tableView dequeueReusableCellWithIdentifier:cellId_2];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([RedeemCell_2 class]) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellId_2];
        cell = [tableView dequeueReusableCellWithIdentifier:cellId_2];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    LockModel *model = self.stores[indexPath.row];
    cell.model = model;
    cell.currentBlockNumber = self.currentBlockNumber;
    
    if(model.days == 0){
        cell.rewardBlock = ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                RedeemINBVC *redeemVC = [[RedeemINBVC alloc] init];
                
                self.navigationController.navigationBar.topItem.title = @"";
                redeemVC.navigationItem.title = NSLocalizedString(@"redemption", @"赎回");
                redeemVC.canTotal =  [model.amount doubleValue];
                [self.navigationController pushViewController:redeemVC animated:YES];
            });
        };
    }else{
        cell.rewardBlock = ^{
            //领取奖励
            LockModel *model = self.stores[indexPath.row];
            self.passwordInput = [PasswordInputView showPasswordInputWithConfirmClock:^(NSString * _Nonnull password) {
                __block __weak typeof(self) tmpSelf = self;
                [MBProgressHUD showHUDAddedTo:App_Delegate.window animated:YES];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    @try {
                        [self rewardLockWithAddr:App_Delegate.selectAddr walletID:App_Delegate.selectWalletID nonce:model.hashStr password:password];
                    } @catch (NSException *exception) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MBProgressHUD hideHUDForView:App_Delegate.window animated:YES];
                            [MBProgressHUD showMessage:@"密码错误" toView:App_Delegate.window afterDelay:1 animted:YES];
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
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, 110)];
    view.backgroundColor = kColorBackground;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 100, 15)];
    label.text = NSLocalizedString(@"Resource.rewardType.mortgage",@"抵押奖励");
    label.textColor = kColorTitle;
    label.font = [UIFont boldSystemFontOfSize:17];
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(label.frame)+15, KWIDTH-(15*2), 60)];
    imgV.image = [UIImage imageNamed:@"all_mortgage_wait_bg"];
    
    UILabel *allStr = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(imgV.frame)+100, CGRectGetMinY(imgV.frame)+12, 150, 15)];
    allStr.textColor = kColorTitle;
    allStr.font = [UIFont systemFontOfSize:14];
    allStr.text = @"全网待领取抵押奖励";
    
    UILabel *valueL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(allStr.frame), CGRectGetMaxY(allStr.frame)+10, 200, 20)];
    valueL.textAlignment = NSTextAlignmentLeft;
    valueL.textColor = kColorBlue;
    valueL.font = [UIFont boldSystemFontOfSize:15];
    valueL.text = [NSString stringWithFormat:@"%@ INB", [NSString changeNumberFormatter:[NSString stringWithFormat:@"%f",self.allWaitToSendMorgage]]];
    
    [view addSubview:label];
    [view addSubview:imgV];
    [view addSubview:allStr];
    [view addSubview:valueL];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 110.0;
}
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 10)];
//    view.backgroundColor = kColorBackground;
//    return view;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 10;
//}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return self.tableFooterView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return self.tableFooterView.frame.size.height+10;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LockModel *model = self.stores[indexPath.row];
    
    if (model.days == 0) {
        return ;
    }
    
    MortgageDetailVC *detailVC = [[MortgageDetailVC alloc] initWithNibName:@"MortgageDetailVC" bundle:nil];
    detailVC.lockModel = model;
    [self.navigationController pushViewController:detailVC animated:NO];
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
                                    
                                    _signResult = [WalletManager ethSignTransactionWithWalletID:walletID nonce:[_nonce stringValue] txType:TxType_rewardLock gasPrice:@"200000" gasLimit:@"21000" to:App_Delegate.selectAddr value:[bitVal stringValue] data:[[[NSString stringWithFormat:@"%@", rewardNonce] hexString] add0xIfNeeded] password:password chainID:kChainID];
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
                                                                [TransferResultView resultFailedWithTitle:NSLocalizedString(@"receive.reward.lock.failed", @"锁仓抵押奖励领取失败") message:[error description]];
                                                                return ;
                                                            }
                                        if(responseObject[@"error"]){
                                                                                    [TransferResultView resultFailedWithTitle:NSLocalizedString(@"receive.reward.lock.failed", @"锁仓抵押奖励领取失败") message:responseObject[@"error"][@"message"]];
                                                                                    return ;
                                                                                }
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                [self.passwordInput hidePasswordInput];
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
//领取投票奖励
-(void)rewardVoteWithAddr:(NSString *)addr walletID:(NSString *)walletID password:(NSString *)password{
    __weak typeof(self) tmpSelf = self;
    __block __weak NSDecimalNumber *_nonce;
    
    __block TransactionSignedResult *_signResult;
    
    NSString *rpcHost = App_Delegate.rpcHost;
    //创建穿行队列
    dispatch_queue_t customQuue = dispatch_queue_create("rewardVote.nerwork", DISPATCH_QUEUE_SERIAL);
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
                                    
                                    _signResult = [WalletManager ethSignTransactionWithWalletID:walletID nonce:[_nonce stringValue] txType:TxType_rewardVote gasPrice:@"200000" gasLimit:@"21000" to:App_Delegate.selectAddr value:[bitVal stringValue] data:@"" password:password chainID:kChainID];
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
                                                            if (error || responseObject[@"error"]) {
                                                                [TransferResultView resultFailedWithTitle:NSLocalizedString(@"receive.reward.vote.failed", @"投票奖励领取失败") message:error?[error description]:responseObject[@"error"][@"message"]];
                                                                return ;
                                                            }
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                [self.passwordInput hidePasswordInput];
                                                                [TransferResultView resultSuccessRewardWithTitle:NSLocalizedString(@"receive.reward.vote.success", @"投票奖励领取成功") value:0];
                                                                [NotificationCenter postNotificationName:NOTI_MORTGAGE_CHANGE object:nil];
                                                                
                                                                [self.voteRewardBtn setTitle:[NSString stringWithFormat:@"领取成功"] forState:UIControlStateNormal];
                                                                
                                                                [self.tableView.mj_header beginRefreshing];
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
#pragma mark ---- Button Action
//领取奖励
- (IBAction)rewardAction:(UIButton *)sender {
    self.passwordInput = [PasswordInputView showPasswordInputWithConfirmClock:^(NSString * _Nonnull password) {
        __block __weak typeof(self) tmpSelf = self;
        [MBProgressHUD showHUDAddedTo:App_Delegate.window animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @try {
                //                            [self rewardRedemptionWithAddr:App_Delegate.selectAddr walletID:App_Delegate.selectWalletID password:password];
                [self rewardVoteWithAddr:App_Delegate.selectAddr walletID:App_Delegate.selectWalletID password:password];
            } @catch (NSException *exception) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:App_Delegate.window animated:YES];
                    [MBProgressHUD showMessage:@"密码错误" toView:App_Delegate.window afterDelay:1 animted:YES];
                });
            } @finally {
                
            }
        });
    }];
}
//去投票
- (IBAction)goVoteAction:(UIButton *)sender {
    VoteListVC *listVC = [[VoteListVC alloc] init];
    /** 导航栏返回按钮文字 **/
    self.navigationController.navigationBar.topItem.title = @"";
    
    listVC.wallet = self.wallet;
    listVC.navigationItem.title = NSLocalizedString(@"vote", @"投票");
    listVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:listVC animated:YES];
}

//查看领取记录
-(void)toRecordAction:(UIButton *)sender{
    RewardRecordVC *recordVC = [[RewardRecordVC alloc] init];
    recordVC.navigationItem.title = NSLocalizedString(@"reward.record.receive", @"领取记录");
    recordVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:recordVC animated:YES];
    
}



#pragma mark ---- setter && getter
-(void)setVoteNumberValue:(NSInteger)voteNumberValue{
    _voteNumberValue = voteNumberValue;
    if(_voteNumberValue > 0){ //参与过投票
        self.headerBg.image = [UIImage imageNamed:@"reward_vote_bg"];
        self.vote_no_tip.hidden = YES;
        self.goVoteBtn.hidden = YES;
        self.voteRewardValue.hidden = NO;
        self.voteNumber.hidden = NO;
        self.voteRewardBtn.hidden = NO;
    }else{
        self.headerBg.image = [UIImage imageNamed:@"reward_vote_no_bg"];
        self.vote_no_tip.hidden = NO;
        self.goVoteBtn.hidden = NO;
        self.voteRewardValue.hidden = YES;
        self.voteNumber.hidden = YES;
        self.voteRewardBtn.hidden = YES;
    }
    
    [self calulateReward:self.lastReceiveVoteAwardHeight lockedNumber:App_Delegate.isTest?200:(7*kDayNumbers) voteNumber:_voteNumberValue];
    self.voteNumber.text = [NSString stringWithFormat:@"已投票数量 %.0f", _voteNumberValue];
}

/**
 *  startBlockNumber 上次领取投票高度
 *  lockedNumber 期限高度
 */
-(void)calulateReward:(NSInteger)startBlockNumber lockedNumber:(NSInteger)lockedNumber voteNumber:(double)voteNumber{
//    前提：（当前区块高度-上次领投票奖励区块高度）/每天产生区块数>=7
//    本次领取奖励=（当前区块高度-上次领投票奖励区块高度）/每天产生区块数（24*60*60/2）*年化（9%）/365*已投票数
    
    NSInteger perDayBlock = kDayNumbers;//24*60*60/2; //每天产生的去块数
    double difDay = (self.currentBlockNumber - startBlockNumber) / (perDayBlock*1.0);

    
    
    if (self.currentBlockNumber >= (startBlockNumber+lockedNumber)) { // 当前区块高度 < 上次领取投票高度 + 期限区块高度
        //可以领取
        [self.voteRewardBtn setTitle:[NSString stringWithFormat:@"领取奖励"] forState:UIControlStateNormal];
        self.voteRewardBtn.userInteractionEnabled = YES;
        
        NSDecimalNumber *baseDec = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",((lockedNumber*1.0/kDayNumbers) * 0.09 / 365)]];
        NSDecimalNumber *rewardDec = [baseDec decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", voteNumber]]];
        self.voteRewardValue.text = [NSString stringWithFormat:@"%@ INB", [NSString changeNumberFormatter:rewardDec.stringValue]];
        
    }else{
        
        double dd = (startBlockNumber + lockedNumber - self.currentBlockNumber) / (kDayNumbers*1.0);
        NSInteger day = floor(dd);
        [self.voteRewardBtn setTitle:[NSString stringWithFormat:@"%d天后领取", day] forState:UIControlStateNormal];
        self.voteRewardBtn.userInteractionEnabled = NO;
        
        
        NSDecimalNumber *baseDec = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",((lockedNumber/kDayNumbers*1.0) * 0.09 / 365)]];
        NSDecimalNumber *rewardDec = [baseDec decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", voteNumber]]];
        self.voteRewardValue.text = [NSString stringWithFormat:@"%@ INB", [NSString changeNumberFormatter:rewardDec.stringValue]];
    }
    

}

-(UIView *)tableFooterView{
    if (_tableFooterView == nil) {
        _tableFooterView = [[UIView alloc] init];
        NSString *tipStr = [NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"tip.resource.reward_1", @"只有参与投票的用户才能领取投票收益"), NSLocalizedString(@"tip.resource.reward_2", @"所有收益奖励产生后需要手动领取，若不领取，则当前收益保留且新的收益不再生成。")];
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, KWIDTH-15*2, 60)];
        tipLabel.numberOfLines = 0;
        tipLabel.textColor = kColorAuxiliary2;
        tipLabel.font = [UIFont systemFontOfSize:13];
        tipLabel.text = tipStr;
//        CGRect bound = [tipStr boundingRectWithSize:CGSizeMake(KWIDTH-15*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:tipLabel.font} context:nil];
        CGSize labelSize = [tipLabel sizeThatFits:CGSizeMake(KWIDTH-15*2, MAXFLOAT)];
        CGFloat height = ceil(labelSize.height) +1;
        
        CGRect fr = tipLabel.frame;
        fr.size.height = height;
        [_tableFooterView addSubview:tipLabel];
        _tableFooterView.backgroundColor = kColorBackground;
        _tableFooterView.frame = CGRectMake(0, 0, KWIDTH, height+5);
    }
    return _tableFooterView;
}

@end
