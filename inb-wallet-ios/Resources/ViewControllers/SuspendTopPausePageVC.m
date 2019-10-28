//
//  SuspendTopPausePageVC.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/10/17.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "SuspendTopPausePageVC.h"
#import "SuspendTopPauseBaseTableViewVC.h"
#import "mortgageVC.h"
#import "redeemVC.h"

#import "ResourceCPUView.h"
#import "PasswordInputView.h"

#import "TransactionSignedResult.h"
#import "WalletManager.h"

#import "NetworkUtil.h"

@interface SuspendTopPausePageVC ()<YNPageViewControllerDelegate, YNPageViewControllerDataSource>
@property (nonatomic, strong) ResourceCPUView *cpuView;

@property (nonatomic, strong) NSDecimalNumber *startBlockNumber;
@property (nonatomic, strong) NSDecimalNumber *currentBlockNumber;
@property (nonatomic, assign) NSInteger lockingNumber; //正在锁仓的数量
@property (nonatomic, strong) PasswordInputView *passwordInput;
@end

@implementation SuspendTopPausePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestAccountInfo];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.cpuView.balanceValue.text = [NSString stringWithFormat:@"%d RES",(int)self.canUseNet];
    self.cpuView.totalValue.text = [NSString stringWithFormat:@"%d RES", (int)self.totalNet];
    self.cpuView.mortgageValue.text = [NSString stringWithFormat:@"%@ INB", [NSString changeNumberFormatter:[NSString stringWithFormat:@"%f", self.mortgageINB]]];
    
    mortgageVC *morVC = self.controllersM[0];
    morVC.address = self.address;
    morVC.walletID = self.walletID;
    
    __weak __block typeof(self) tmpSelf = self;
    self.cpuView.resetRes = ^{
        tmpSelf.passwordInput = [PasswordInputView showPasswordInputWithConfirmClock:^(NSString * _Nonnull password) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showHUDAddedTo:App_Delegate.window animated:YES];
            });
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [tmpSelf reqestResetResWithAddr:App_Delegate.selectAddr walletID:App_Delegate.selectWalletID password:password];
            });
        }];
    };
    [self.cpuView updataProgress]; //更新进度条图片
    
}
//请求账户信息
-(void)requestAccountInfo{
    __block __weak typeof(self) tmpSelf = self;
        //请求账户信息任务
        NSString *url = [NSString stringWithFormat:@"%@account/search?address=%@", App_Delegate.explorerHost, [App_Delegate.selectAddr add0xIfNeeded]];
        [NetworkUtil getRequest:url params:@{} success:^(id  _Nonnull resonseObject) {
            NSInteger startNumber;
            NSString *address = resonseObject[@"address"];
            double redeemValue; //赎回中的值
            if(address == nil || [address isKindOfClass:[NSNull class]]){
                startNumber = 0;
                
                tmpSelf.startBlockNumber = [NSDecimalNumber decimalNumberWithString:@"0"];
                redeemValue = 0;
            }else{
                NSDictionary *res = resonseObject[@"res"];
                startNumber = [res[@"height"] integerValue];
                tmpSelf.startBlockNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", startNumber]];
                redeemValue = [resonseObject[@"redeemValue"] doubleValue];
            }
            
            NSArray *store = resonseObject[@"store"];
//            mortgageVC *mo = tmpSelf.controllersM[0];
//            mo.lockingNumber = store.count;
            
            [tmpSelf reqestBlockHeight:^(id  _Nullable responseObject, NSError * _Nullable error) {
                NSLog(@"%@", responseObject);
                if (error) {
                    return ;
                }
                
                NSString *str = responseObject[@"result"];
                const char *hexChar = [str cStringUsingEncoding:NSUTF8StringEncoding];
                int hexNumber;
                sscanf(hexChar, "%x", &hexNumber);
                tmpSelf.currentBlockNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", hexNumber]];
                
                //同步栅栏任务，刷新UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if([self.startBlockNumber intValue] == 0){
                        [self.cpuView.resetBtn setTitle:@"暂无抵押资源" forState:UIControlStateNormal];
                        [self.cpuView.resetBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg_lightBlue"] forState:UIControlStateNormal];
                        self.cpuView.resetBtn.userInteractionEnabled = NO;
                        return;
                    }
                    
                    NSDecimalNumber *canResetNumber = [self.startBlockNumber decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", kDayNumbers]]];
                    NSComparisonResult result = [self.currentBlockNumber compare:canResetNumber];
                    
                    if (result == NSOrderedDescending || result == NSOrderedSame) {
                        //大于等于,
                        [self.cpuView.resetBtn setTitle:NSLocalizedString(@"Resource.receive", @"领取资源") forState:UIControlStateNormal];
                        [self.cpuView.resetBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg_blue"] forState:UIControlStateNormal];
                        self.cpuView.resetBtn.userInteractionEnabled = YES;
                    }else{
                        [self.cpuView.resetBtn setTitle:NSLocalizedString(@"Resource.noReceive",@"今日资源已领取") forState:UIControlStateNormal];
                        [self.cpuView.resetBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg_lightBlue"] forState:UIControlStateNormal];
                        self.cpuView.resetBtn.userInteractionEnabled = NO;
                    }
                    
                    self.cpuView.redemptionValue.text = [NSString stringWithFormat:@"%@ INB", [NSString changeNumberFormatter:[NSString stringWithFormat:@"%f", redeemValue]]];
                });
                
            }];
            
        } failed:^(NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
    
}
//获取最新快高度
-(void)reqestBlockHeight:(void(^)(id  _Nullable responseObject, NSError * _Nullable error))completion{
    
    [NetworkUtil rpc_requetWithURL:App_Delegate.rpcHost
                            params:@{@"jsonrpc":@"2.0",
                                     @"method":blockNumber_MethodName,
                                     @"params":@[[App_Delegate.selectAddr add0xIfNeeded]],
                                     @"id":@(67),
                                     } completion:^(id  _Nullable responseObject, NSError * _Nullable error) {
                                         completion(responseObject, error);
                                     }];
}
//领取资源
-(void)reqestResetResWithAddr:(NSString *)addr walletID:(NSString *)walletID password:(NSString *)password{
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
                                    _signResult = [WalletManager ethSignTransactionWithWalletID:walletID nonce:[_nonce stringValue] txType:TxType_reResource gasPrice:@"200000" gasLimit:@"21000" to:App_Delegate.selectAddr value:[bitVal stringValue] data:@"" password:password chainID:kChainID];
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
                                                                [MBProgressHUD showMessage:NSLocalizedString(@"message.tip.res.receive.failed", @"领取资源失败") toView:App_Delegate.window afterDelay:1 animted:YES];
                                                                return ;
                                                            }
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                [tmpSelf.passwordInput hidePasswordInput];
                                                                [MBProgressHUD showMessage:NSLocalizedString(@"message.tip.res.receive.success", @"领取资源成功") toView:App_Delegate.window afterDelay:1 animted:YES];
                                                                [NotificationCenter postNotificationName:NOTI_MORTGAGE_CHANGE object:nil];
                                                            });
                                                            
                                                        }];
                                } @catch (NSException *exception) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [MBProgressHUD hideHUDForView:App_Delegate.window animated:YES];
                                        [MBProgressHUD showMessage:@"密码错误" toView:App_Delegate.window afterDelay:0.7 animted:YES];
                                    });
                                    return;
                                } @finally {

                                    if(!_signResult){
                                        return ;
                                    }
                                }
                            }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"任务完成");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self requestAccountInfo];
            });
        });
    });
}

#pragma mark ---- Publick Func
+(instancetype)suspendTopPausePageVC{
    
    YNPageConfigration *configration = [YNPageConfigration defaultConfig];
    configration.pageStyle = YNPageStyleSuspensionTopPause;
    configration.headerViewCouldScale = YES;
    configration.showTabbar = NO;
    configration.showNavigation = YES;
    configration.scrollMenu = NO;
    configration.aligmentModeCenter = YES;
    configration.lineWidthEqualFontWidth = YES;
    configration.showBottomLine = NO;
    
    configration.itemFont = [UIFont systemFontOfSize:16];
    configration.selectedItemFont = [UIFont systemFontOfSize:16];
    configration.menuHeight = 40;
    configration.scrollViewBackgroundColor = kColorBackground;
    configration.itemMargin = 50;
    configration.selectedItemColor = kColorBlue;
    configration.normalItemColor = kColorAuxiliary;
    configration.lineColor = kColorBlue;
    
    SuspendTopPausePageVC *vc = [SuspendTopPausePageVC pageViewControllerWithControllers:[self getArrayVCs] titles:[self getArrayTitles] config:configration];
    vc.delegate = vc;
    vc.dataSource = vc;
    vc.pageIndex = 0;
    
    ResourceCPUView *cpuView = [[ResourceCPUView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, 290)];
    cpuView.backgroundColor = kColorBackground;
    cpuView.resetRes = ^{
        
    };
    vc.cpuView = cpuView;
    vc.headerView = cpuView;
    
    return vc;
}
+ (NSArray *)getArrayVCs {
    
    mortgageVC *firstVC = [[mortgageVC alloc] init];
    redeemVC *secondVC = [[redeemVC alloc] init];
    
    return @[firstVC, secondVC];
}
+ (NSArray *)getArrayTitles {
    return @[NSLocalizedString(@"mortgage",@"抵押"), NSLocalizedString(@"Resource.hasMortgage",@"已抵押")];
}

#pragma mark ---- YNPageViewControllerDataSource
-(UIScrollView *)pageViewController:(YNPageViewController *)pageViewController pageForIndex:(NSInteger)index{
    UIViewController *vc = pageViewController.controllersM[index];
    if(index == 0){
        return [(mortgageVC *)vc tableView];
    }else{
        return [(SuspendTopPauseBaseTableViewVC *)vc tableView];
    }
}
#pragma mark ---- YNPageViewControllerDelegate
-(void)pageViewController:(YNPageViewController *)pageViewController contentOffsetY:(CGFloat)contentOffsetY progress:(CGFloat)progress{
    
}
@end
