//
//  ResourcePageViewController.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/9/3.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "ResourcePageViewController.h"
#import "mortgageVC.h"
#import "redeemVC.h"
#import "BaseTableViewVC.h"

#import "PasswordInputView.h"
#import "ResourceCPUView.h"

#import "TransactionSignedResult.h"
#import "WalletManager.h"
#import "MJRefresh.h"
#import "NetworkUtil.h"
#define daysBlockNumber ((5*60)/2)   //预估一天产生的块

@interface ResourcePageViewController ()<PageViewControllerDataSource, PageViewControllerDelegate, YNPageViewControllerDelegate, YNPageViewControllerDataSource>

@property (nonatomic, strong) ResourceCPUView *cpuView;

@property (nonatomic, strong) NSDecimalNumber *startBlockNumber;
@property (nonatomic, strong) NSDecimalNumber *currentBlockNumber;

@end

@implementation ResourcePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self request];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.cpuView.balanceValue.text = [NSString stringWithFormat:@"%d RES",(int)self.canUseNet];
    self.cpuView.totalValue.text = [NSString stringWithFormat:@"%d RES", (int)self.totalNet];
    self.cpuView.mortgageValue.text = [NSString stringWithFormat:@"%.2f INB", self.mortgageINB];
    self.cpuView.resetRes = ^{
        
        [PasswordInputView showPasswordInputWithConfirmClock:^(NSString * _Nonnull password) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showHUDAddedTo:App_Delegate.window animated:YES];
            });
            [self reqestResetResWithAddr:App_Delegate.selectAddr walletID:App_Delegate.selectWalletID password:password];
        }];
    };
    [self.cpuView updataProgress]; //更新进度条图片
}


-(void)request{
    
    __block __weak typeof(self) tmpSelf = self;
        //请求账户信息任务
        NSString *url = [NSString stringWithFormat:@"%@account/search?address=%@", App_Delegate.explorerHost, [App_Delegate.selectAddr add0xIfNeeded]];
        [NetworkUtil getRequest:url params:@{} success:^(id  _Nonnull resonseObject) {
            NSLog(@"%@", resonseObject);
            NSString *address = resonseObject[@"address"];
            if (address) {
                NSDictionary *res = resonseObject[@"res"];
                NSInteger startNumber = [res[@"height"] integerValue];
                tmpSelf.startBlockNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", startNumber]];
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
                        NSDecimalNumber *canResetNumber = [self.startBlockNumber decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", daysBlockNumber]]];
                        NSComparisonResult result = [self.currentBlockNumber compare:canResetNumber];
                        if (result == NSOrderedDescending || result == NSOrderedSame) {
                            //大于等于,
                            [self.cpuView.resetBtn setTitle:@"领取资源" forState:UIControlStateNormal];
                            [self.cpuView.resetBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg_blue"] forState:UIControlStateNormal];
                            self.cpuView.resetBtn.userInteractionEnabled = YES;
                        }else{
                            [self.cpuView.resetBtn setTitle:@"已领取资源" forState:UIControlStateNormal];
                            [self.cpuView.resetBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg_lightBlue"] forState:UIControlStateNormal];
                            self.cpuView.resetBtn.userInteractionEnabled = NO;
                        }
                    });
                    
                }];
            }else{
                tmpSelf.startBlockNumber = [NSDecimalNumber decimalNumberWithString:@"0"];
            }
        } failed:^(NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
    
}
-(void)reqestBlockHeight:(void(^)(id  _Nullable responseObject, NSError * _Nullable error))completion{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [NetworkUtil rpc_requetWithURL:delegate.rpcHost
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
                                    [MBProgressHUD hideHUDForView:App_Delegate.window animated:YES];
                                    return ;
                                }
                                NSDictionary *dic = (NSDictionary *)responseObject;
                                _nonce = [dic[@"result"] decimalNumberFromHexString];
                                
                                NSDecimalNumber *val = [NSDecimalNumber decimalNumberWithString:@"0"];
                                NSDecimalNumber *bitVal = [val decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:kWei]];
                                _signResult = [WalletManager ethSignTransactionWithWalletID:walletID nonce:[_nonce stringValue] txType:TxType_reResource gasPrice:@"200000" gasLimit:@"21000" to:App_Delegate.selectAddr value:[bitVal stringValue] data:@"" password:password chainID:kChainID];
                                
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
                                
                                [MBProgressHUD hideHUDForView:App_Delegate.window animated:YES];
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
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self request];
            });
        });
    });
}

+(NSArray *)getArrayVCs{
    mortgageVC *vc1 = [[mortgageVC alloc] init];
    redeemVC *vc2 = [[redeemVC alloc] init];

    vc1.tableView.backgroundColor = kColorBackground;
    vc1.address = App_Delegate.selectAddr;
    vc1.walletID = App_Delegate.selectWalletID;
    

    vc2.tableView.backgroundColor = kColorBackground;
    return @[vc1, vc2];
}
+(NSArray *)getArrayTitles{
    return @[@"抵押", @"已抵押"];
}

#pragma mark ---- PageViewControllerDelegate


+(instancetype)suspendTopPausePageVC{
    YNPageConfigration *configration = [YNPageConfigration defaultConfig];
    configration.pageStyle = YNPageStyleSuspensionTopPause;
    configration.headerViewCouldScale = YES;
    configration.showTabbar = NO;
    configration.showNavigation = YES;
    configration.scrollMenu = NO;
    configration.itemMargin = 50;
    configration.aligmentModeCenter = YES;
    configration.lineWidthEqualFontWidth = YES;
    configration.showBottomLine = NO;
    configration.selectedItemColor = kColorBlue;
    configration.normalItemColor = kColorAuxiliary;
    configration.lineColor = kColorBlue;
    
    ResourcePageViewController *vc = [ResourcePageViewController pageViewControllerWithControllers:[self getArrayVCs] titles:[self getArrayTitles] config:configration];
    vc.dataSource = vc;
    vc.delegate = vc;
    
    ResourceCPUView *cpuView = [[ResourceCPUView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, 290)];
    cpuView.resetRes = ^{
        
    };
    vc.cpuView = cpuView;
    vc.headerView = cpuView;
    
    vc.pageIndex = 1;
    
    __weak typeof(ResourcePageViewController *) weakVC = vc;
    
    vc.bgScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        NSInteger refreshPage = weakVC.pageIndex;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (refreshPage == 1) {
                /// 取到之前的页面进行刷新 pageIndex 是当前页面
                redeemVC *vc2 = weakVC.controllersM[refreshPage];
                [vc2 request];
                [vc2.tableView reloadData];
            }
            [weakVC.bgScrollView.mj_header endRefreshing];
            
        });
    }];
    return vc;
}
#pragma mark - YNPageViewControllerDataSource
- (UIScrollView *)pageViewController:(YNPageViewController *)pageViewController pageForIndex:(NSInteger)index {
    UIViewController *vc = pageViewController.controllersM[index];
    return [(BaseTableViewVC *)vc tableView];
}

#pragma mark - YNPageViewControllerDelegate
- (void)pageViewController:(YNPageViewController *)pageViewController
            contentOffsetY:(CGFloat)contentOffset
                  progress:(CGFloat)progress {
    NSLog(@"--- contentOffset = %f,    progress = %f", contentOffset, progress);
}


@end
