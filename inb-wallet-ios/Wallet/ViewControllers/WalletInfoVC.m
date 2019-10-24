//
//  WalletInfoVC.m
//  wallet
//
//  Created by apple on 2019/3/21.
//  Copyright © 2019 apple. All rights reserved.
//

#import "WalletInfoVC.h"
#import "WalletDetailVC.h"
#import "RequestVC.h"
#import "WalletImportVC.h"
#import "WalletBackupVC.h"
#import "TransactionDetailVC.h"
#import "VoteListVC.h"
#import "RewardVC.h"

#import "redeemVC.h"
#import "TransferVC.h"
#import "ResourceVC.h"
#import "TransferListVC.h"
#import "NodeRegisterVC.h"
#import "WelcomVC.h"

#import "SuspendTopPausePageVC.h"

#import "WalletInfoViewModel.h"

#import "BasicWallet.h"
#import "Identity.h"

#import "SWQRCodeViewController.h"

#import "UIButton+Layout.h"

#import "WalletInfoFunctionView.h"
#import "WalletInfoCPUView.h"
#import "WalletAccountsListView.h"
#import "PasswordInputView.h"

#import "NetworkUtil.h"
#import "NSString+Extension.h"

#import "AppDelegate.h"
#import "NSData+HexString.h"

#import "MJRefresh.h"

@interface WalletInfoVC ()<UIScrollViewDelegate>

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIView *scrollContentView;

@property(nonatomic, strong) WalletInfo *wallet; //钱包信息

@property(nonatomic, strong) UIImageView *topBgImageView;
@property(nonatomic, strong) UILabel  *myAssets; //"我的资产"
@property(nonatomic, strong) UIButton *eyeBtn;   //显示/隐藏资产按钮
@property(nonatomic, strong) UILabel  *inbAssetsValue; //总资产(INB)
@property(nonatomic, strong) UILabel  *cnyAssetsValue; //CNY
@property(nonatomic, strong) WalletInfoFunctionView *functionView; //转账等功能按钮 容器
@property(nonatomic, strong) WalletInfoCPUView      *CPUView;      //CPU资源view

@property(nonatomic, strong) UIButton *walletDetailBtn; //钱包详情

@property(nonatomic, strong) WalletInfoViewModel    *viewModel;

@property(nonatomic, strong) UIButton *accountNameBtn;

@property(nonatomic, assign) double balance; //余额
@property(nonatomic, assign) double inbPrice; //inb当前价格
@property(nonatomic, assign) double canUseNet; //net的可用量
@property(nonatomic, assign) double totalNet; // net的总量
@property(nonatomic, assign) double mortgageINB;//抵押的INB量
@end

@implementation WalletInfoVC

-(instancetype)init{
    if (self = [super init]) {

    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.eyeBtn.selected = NO;
    
    [self initNavi];
    
    [NotificationCenter addObserver:self selector:@selector(addWalletNoti:) name:NOTI_ADD_WALLET object:nil];
    [NotificationCenter addObserver:self selector:@selector(addWalletNoti:) name:NOTI_DELETE_WALLET object:nil];
    [NotificationCenter addObserver:self selector:@selector(mortgageChangeNoti:) name:NOTI_MORTGAGE_CHANGE object:nil];
    [NotificationCenter addObserver:self selector:@selector(mortgageChangeNoti:) name:NOTI_BALANCE_CHANGE object:nil];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-kBottomBarHeight-kNavigationBarHeight)];
    
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever; //贯穿整个屏幕
    } else {
        // Fallback on earlier versions
        self.extendedLayoutIncludesOpaqueBars = YES; //扩展布局包含导航栏
        self.automaticallyAdjustsScrollViewInsets = NO; //不自动计算滚动视图的内容边距
    }
    self.scrollView.delegate = self;
    self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self queryAccountInfo];
        [self request];
    }];
    self.scrollContentView = [[UIView alloc] init];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollContentView];
    
    [self makeConstraints];
    
    [self.scrollContentView layoutIfNeeded];
    self.scrollContentView.frame = CGRectMake(0, 0, KWIDTH, CGRectGetMaxY(self.CPUView.frame)+5);
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.scrollContentView.frame));
    
    __weak typeof(self) tmpSelf = self;
    self.functionView.click = ^(FunctionType type) {
        switch (type) {
            case FunctionType_transfer:{
                dispatch_async(dispatch_get_main_queue(), ^{
//                    WalletImportVC *importVC = [[WalletImportVC alloc] init];
//                    importVC.navigationItem.title = @"导入";
//                    importVC.hidesBottomBarWhenPushed = YES;
//                    [tmpSelf.navigationController pushViewController:importVC animated:YES];
                    TransferVC *transferVC = [[TransferVC alloc] init];
                    transferVC.wallet = tmpSelf.selectedWallet;
                    transferVC.balance = tmpSelf.balance;
                    transferVC.navigationItem.title = NSLocalizedString(@"transfer", @"转账");
                    transferVC.hidesBottomBarWhenPushed = YES;
                    [tmpSelf.navigationController pushViewController:transferVC animated:YES];
                });
                break;
            }
            case FunctionType_collection:{
                dispatch_async(dispatch_get_main_queue(), ^{
                    RequestVC *requestVC = [[RequestVC alloc] init];
                    requestVC.addressStr = tmpSelf.selectedWallet.address;
                    requestVC.navigationItem.title = NSLocalizedString(@"collection", @"收款");
                    requestVC.hidesBottomBarWhenPushed = YES;
                    [tmpSelf.navigationController pushViewController:requestVC animated:YES];
                });
                break;
            }
            case FunctionType_node:{
                dispatch_async(dispatch_get_main_queue(), ^{
//                    SWQRCodeConfig *qrConfig = [[SWQRCodeConfig alloc] init];
//                    qrConfig.scannerType = SWScannerTypeBoth;
//                    
//                    SWQRCodeViewController *qrVC = [[SWQRCodeViewController alloc] init];
//                    qrVC.scanBlock = ^(BOOL success, NSString *value) {
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            
//                        });
//                    };
//                    qrVC.codeConfig = qrConfig;
//                    qrVC.hidesBottomBarWhenPushed = YES;
//                    [tmpSelf.navigationController pushViewController:qrVC animated:YES];
                    if(tmpSelf.mortgageINB < 10000){ 
                        [MBProgressHUD showMessage:@"抵押INB数量不足,请前往抵押" toView:tmpSelf.view afterDelay:1.5 animted:YES];
                    }else{
                        [MBProgressHUD showHUDAddedTo:tmpSelf.view animated:YES];
                        
                        NSString *url = [NSString stringWithFormat:@"%@node/info?address=%@", App_Delegate.explorerHost,[tmpSelf.selectedWallet.address add0xIfNeeded]];
                        [NetworkUtil getRequest:url
                                         params:@{}
                                        success:^(id  _Nonnull resonseObject) {
                                            
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                [MBProgressHUD hideHUDForView:tmpSelf.view animated:YES];
                                                NSArray *items = resonseObject[@"items"];
                                                Node *node;
                                                if(items.count > 0){
                                                   node = [Node mj_objectWithKeyValues:items[0]];
                                                }
                                                NodeRegisterVC *regisVC = [[NodeRegisterVC alloc] init];
                                                regisVC.wallet = tmpSelf.selectedWallet;
                                                regisVC.node = node;
                                                regisVC.title = @"节点信息";
                                                regisVC.hidesBottomBarWhenPushed = YES;
                                                [tmpSelf.navigationController pushViewController:regisVC animated:YES];
                                            });
                                            
                                        } failed:^(NSError * _Nonnull error) {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                [MBProgressHUD hideHUDForView:tmpSelf.view animated:YES];
                                            });
                                        }];
                        
                    }
                });
                break;
            }
            case FunctionType_vote:{
                dispatch_async(dispatch_get_main_queue(), ^{
                    VoteListVC *listVC = [[VoteListVC alloc] init];
                    listVC.wallet = tmpSelf.selectedWallet;
                    listVC.navigationItem.title = NSLocalizedString(@"transfer.vote", @"节点投票");
                    listVC.hidesBottomBarWhenPushed = YES;
                    [tmpSelf.navigationController pushViewController:listVC animated:YES];
                });
                break;
            }
            case FunctionType_record:{
                TransferListVC *tranferList = [[TransferListVC alloc] init];
                tranferList.address = tmpSelf.selectedWallet.address;
                tranferList.navigationItem.title = NSLocalizedString(@"transactionRecords", @"交易记录");
                tranferList.hidesBottomBarWhenPushed = YES;
                [tmpSelf.navigationController pushViewController:tranferList animated:YES];
                break;
            }
            case FunctionType_backup:{

                dispatch_async(dispatch_get_main_queue(), ^{
//                    [PasswordInputView showPasswordInputWithConfirmClock:^(NSString * _Nonnull password) {
//                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:tmpSelf.view animated:YES];
//                        hud.bezelView.color = [UIColor blackColor];
//                        hud.bezelView.alpha = 0.5;
//                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                                            @try {
//                                                NSString *private = [tmpSelf.selectedWallet privateKey:password];
//                                                NSString *menmonry = [tmpSelf.selectedWallet exportMnemonic:password];
//                                                dispatch_async(dispatch_get_main_queue(), ^{
//                                                    [MBProgressHUD hideHUDForView:tmpSelf.view animated:YES];
//                                                    WalletBackupVC *backupVC = [[WalletBackupVC alloc] init];
//                                                    backupVC.title = NSLocalizedString(@"backup", @"备份");
//                                                    backupVC.privateKey = private;
//                                                    backupVC.menmonryKey = menmonry;
//                                                    backupVC.name = tmpSelf.selectedWallet.name;
//                                                    backupVC.hidesBottomBarWhenPushed = YES;
//                                                    [tmpSelf.navigationController pushViewController:backupVC animated:YES];
//                                                });
//                                            } @catch (NSException *exception) {
//                                                if([exception.name isEqualToString:@"PasswordError"]){
//                                                    dispatch_async(dispatch_get_main_queue(), ^{
//                                                        [MBProgressHUD hideHUDForView:tmpSelf.view animated:YES];
//                                                        [MBProgressHUD showMessage:@"密码错误" toView:tmpSelf.view afterDelay:0.5 animted:YES];
//                                                    });
//                                                }
//                                            } @finally {
//
//                                            }
//
//                                        });
//                    }];
                });
                break;
                
            }
            case FunctionType_reward:{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    RewardVC *rewardVC = [[RewardVC alloc] init];
                    rewardVC.navigationItem.title = NSLocalizedString(@"wallet.reward", @"收益奖励");
                    rewardVC.wallet = tmpSelf.selectedWallet;
                    rewardVC.hidesBottomBarWhenPushed = YES;
                    [tmpSelf.navigationController pushViewController:rewardVC animated:YES];
                });
                break;
            }
                
            default:
                break;
        }
    };
    
//    self.inbAssetsValue.attributedText = self.viewModel.assets_inb;
//    self.cnyAssetsValue.text = self.viewModel.assets_cny;
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [NetworkUtil getRequest:HTTP(app.apiHost, inbPriceUrl) params:@{} success:^(id  _Nonnull resonseObject) {
        NSDictionary *responDic = (NSDictionary *)resonseObject;
        NSDictionary *data = responDic[@"data"];
        double price = [data[@"price"] doubleValue];
        double cnyPrice = [data[@"cnyPrice"] doubleValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(cnyPrice > 0){
                self.inbPrice = price ; // / cnyPrice;
            }else{
                self.inbPrice = 0;
            }
            [self updatePrice];
        });
        
        
    } failed:^(NSError * _Nonnull error) {
        
    }];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    //设置导航栏背景图片为一个空的image，这样就透明了
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    //去掉透明后导航栏下边的黑边
//    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}
-(void)viewWillDisappear:(BOOL)animated{
    //    如果不想让其他页面的导航栏变为透明 需要重置
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}
-(void)dealloc{
    [NotificationCenter removeObserver:self];
}

-(void)updatePrice{
    [self showBalance:self.eyeBtn.selected];
}

///////
-(void)makeConstraints{
    
    [self.scrollContentView addSubview:self.topBgImageView];
    [self.scrollContentView addSubview:self.walletDetailBtn];
    [self.scrollContentView addSubview:self.myAssets];
    [self.scrollContentView addSubview:self.eyeBtn];
    [self.scrollContentView addSubview:self.inbAssetsValue];
    [self.scrollContentView addSubview:self.cnyAssetsValue];
    [self.scrollContentView addSubview:self.functionView];
    [self.scrollContentView addSubview:self.CPUView];
    
    [self.topBgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_offset(AdaptedHeight(200));
    }];
    [self.myAssets mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.topBgImageView).mas_offset(-(AdaptedWidth(10)+self.eyeBtn.imageView.frame.size.width)/2.0);
        make.top.mas_equalTo(AdaptedHeight(15)); //kNavigationBarHeight
    }];
    [self.eyeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.myAssets);
        make.left.mas_equalTo(self.myAssets.mas_right).mas_offset(AdaptedWidth(0));
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(25);
    }];
    [self.walletDetailBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(AdaptedHeight(10));
        make.width.mas_equalTo(AdaptedWidth(75));
        make.height.mas_equalTo(AdaptedWidth(28));
    }];
    [self.inbAssetsValue mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.topBgImageView);
        make.top.mas_equalTo(self.myAssets.mas_bottom).mas_offset(AdaptedHeight(25));
    }];
    [self.cnyAssetsValue mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.inbAssetsValue);
        make.top.mas_equalTo(self.inbAssetsValue.mas_bottom).mas_offset(AdaptedHeight(15));
    }];
    [self.functionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.topBgImageView.mas_bottom).mas_offset(AdaptedHeight(15));
    }];
    [self.CPUView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.functionView.mas_bottom).mas_offset(AdaptedHeight(0));
        make.left.mas_equalTo(AdaptedWidth(16));
        make.right.mas_equalTo(-AdaptedWidth(16));
        make.height.mas_equalTo(self.CPUView.mas_width).multipliedBy((253.5)/359);
    }];
}
/** 设置状态栏的颜色，配合根控制器的 childViewControllerForStatusBarStyle 使用**/
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent; //UIStatusBarStyleDefault
}

-(void)initNavi{
    self.accountNameBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 170, 30)];
//    [self.accountNameBtn setTitle:@"vadgvadfgvasfd" forState:UIControlStateNormal];
    [self.accountNameBtn setImage:[UIImage imageNamed:@"dropDown"] forState:UIControlStateNormal];
    [self.accountNameBtn addTarget:self action:@selector(showAccountsList:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = self.accountNameBtn;
    
}

/** 查询抵押数据 **/
-(void)queryMortgage{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [NetworkUtil rpc_requetWithURL:delegate.rpcHost
                            params:@{@"jsonrpc":@"2.0",
                                     @"method":@"eth_getNet",
                                     @"params":@[[_selectedWallet.address add0xIfNeeded], @"latest"],
                                     @"id":@(67)}
                        completion:^(id  _Nullable responseObject, NSError * _Nullable error) {
                            //可用的的net
                            NSLog(@"可用Net: %@-%@",[responseObject  class],
                                  responseObject);
                            if (error) {
                                return ;
                            }
                            NSDecimalNumber *canNet = [responseObject[@"result"]  decimalNumberFromHexString];
                            NSDecimalNumber *d = [canNet decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"1024"]]; // 8*1024
                            
                            NSString *value = [d stringValue];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                self.canUseNet = [d doubleValue];
                                self.CPUView.remainingValue.text = [NSString stringWithFormat:@"%@kb",value];
                                
                            });
                        }];
    
    [NetworkUtil rpc_requetWithURL:delegate.rpcHost
                            params:@{@"jsonrpc":@"2.0",
                                     @"method":@"eth_getNetOfMortgageINB",
                                     @"params":@[[_selectedWallet.address add0xIfNeeded],@"latest"],
                                     @"id":@(67)}
                        completion:^(id  _Nullable responseObject, NSError * _Nullable error) {
                            //总量net
                            NSLog(@"抵押的INB数值: %@-%@",[responseObject  class],
                                  responseObject);
                            if (error) {
                                return ;
                            }
                            NSDecimalNumber *canNet = [responseObject[@"result"]  decimalNumberFromHexString];
                            NSDecimalNumber *d = [canNet decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:kWei]];
                            
                            NSString *value = [d stringValue];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                self.mortgageINB = [value doubleValue];
                                self.CPUView.mortgageValue.text = [NSString stringWithFormat:@"%@ INB", [NSString changeNumberFormatter:value]];
                                
                            });
                            
                        }];
}
/** 查询余额 **/
-(void)queryBalance{
    //查询余额
    NSString *url = [NSString stringWithFormat:@"https://api-ropsten.etherscan.io/api?module=account&action=balance&address=%@&tag=latest", [_selectedWallet.address add0xIfNeeded]]; //&apikey=SJMGV3C6S3CSUQQXC7CTQ72UCM966KD2XZ
    NSString *str = [NSString stringWithFormat:@"/api?module=account&action=balance&address=%@&tag=latest", [_selectedWallet.address add0xIfNeeded]];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [NetworkUtil rpc_requetWithURL:delegate.rpcHost
                            params:@{@"jsonrpc":@"2.0",
                                     @"method":@"eth_getBalance",
                                     @"params":@[[_selectedWallet.address add0xIfNeeded],@"latest"],
                                     @"id":@(1)}
                        completion:^(id  _Nullable responseObject, NSError * _Nullable error) {
                            if (error) {
                                return ;
                            }
                            NSDictionary *dic = (NSDictionary *)responseObject;
                            NSInteger ID = dic[@"id"];
                            NSString *jsonrpc = dic[@"jsonrpc"];
                            BigNumberTest *big = [BigNumberTest parse:dic[@"result"] padding:NO paddingLen:-1];
                            
                            
                            NSDecimalNumber *dec = [dic[@"result"] decimalNumberFromHexString];
                            NSString *str = [dec stringValue];
                            
                            NSDecimalNumber *d = [dec decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:kWei]];
                            
                            NSString *value = [d stringValue];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                self.balance = [value doubleValue];
                                [self updatePrice];
                            });
                            
                        }];
}
/** 查询用户信息 **/
-(void)queryAccountInfo{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSLog(@"地址：%@", self.selectedWallet.address);
    [NetworkUtil rpc_requetWithURL:delegate.rpcHost
                            params:@{@"jsonrpc":@"2.0",
                                     @"method":getAccountInfo_MethodName,
                                     @"params":@[[self.selectedWallet.address add0xIfNeeded]],
                                     @"id":@(67),
                                     } completion:^(id  _Nullable responseObject, NSError * _Nullable error) {
                                         [self.scrollView.mj_header endRefreshing];
                                         
                                         if (error) {
                                             return ;
                                         }
                                         
                                         NSDictionary *result = responseObject[@"result"];
                                         if(result == nil || !result || [result isKindOfClass:[NSNull class]]){
                                             return;
                                         }
                                         NSDecimalNumber *balanceBit = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",result[@"Balance"]]];
                                         if(!balanceBit || [balanceBit isEqualToNumber:NSDecimalNumber.notANumber]){
                                             balanceBit = [NSDecimalNumber decimalNumberWithString:@"0"];
                                         }
                                         NSDecimalNumber *balance = [balanceBit decimalNumberByDividingBy:unitINB];
                                         
                                         
                                         NSDictionary *NET = result[@"Res"];
                                         NSDecimalNumber *mortgagedINBBit = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",NET[@"Mortgage"]]];
                                         if(!mortgagedINBBit || [mortgagedINBBit isEqualToNumber:NSDecimalNumber.notANumber]){
                                             mortgagedINBBit = [NSDecimalNumber decimalNumberWithString:@"0"];
                                         }
                                         NSDecimalNumber *mortgagedINB = [mortgagedINBBit decimalNumberByDividingBy:unitINB]; //抵押的INB
                                         NSDecimalNumber *canuseNET = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",NET[@"Usable"]]]; //可用的NET
                                         if(!canuseNET || [canuseNET isEqualToNumber:NSDecimalNumber.notANumber]){
                                             canuseNET = [NSDecimalNumber decimalNumberWithString:@"0"];
                                         }
                                         NSDecimalNumber *usedNET = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",NET[@"Used"]]]; //已经使用的NET
                                         if(!usedNET || [usedNET isEqualToNumber:NSDecimalNumber.notANumber]){
                                             usedNET = [NSDecimalNumber decimalNumberWithString:@"0"];
                                         }
                                         canuseNET = [canuseNET decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"1024"]];
                                         usedNET = [usedNET decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"1024"]];
                                         NSDecimalNumber *totalNET = [canuseNET decimalNumberByAdding:usedNET]; //总抵押的NET
                                         
                                         
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             self.balance = [balance doubleValue];
                                             self.canUseNet = [canuseNET doubleValue];
                                             self.totalNet = [totalNET doubleValue];
                                             self.mortgageINB = [mortgagedINB doubleValue];
                                             
                                             
                                             self.CPUView.remainingValue.text = [NSString stringWithFormat:@"%@kb",canuseNET];
                                             self.CPUView.totalValue.text = [NSString stringWithFormat:@"%@kb",totalNET];
                                             self.CPUView.mortgageValue.text = [NSString stringWithFormat:@"%@ INB",[NSString changeNumberFormatter:[mortgagedINB stringValue]]];
                                             
                                             self.selectedWallet.mortgagedINB = [mortgagedINB doubleValue];
                                             self.selectedWallet.balanceINB = [balance doubleValue];
                                             [self.CPUView updataNet];
                                             [self updatePrice];
                                         });
                                         
                                     }];
}
/** 浏览器接口 查询账户信息 **/
-(void)request{
    __block __weak typeof(self) tmpSelf = self;
    
    NSString *url = [NSString stringWithFormat:@"%@account/search?address=%@", App_Delegate.explorerHost, [App_Delegate.selectAddr add0xIfNeeded]];
    [NetworkUtil getRequest:url params:@{} success:^(id  _Nonnull resonseObject) {
        NSLog(@"%@", resonseObject);
        [self.scrollView.mj_header endRefreshing];
        
        NSString *address = resonseObject[@"address"];
        
        NSDecimalNumber *balance; //余额
        NSDecimalNumber *mortgagedINB; //抵押的INB
        NSDecimalNumber *canuseNET; //可用的资源
        NSDecimalNumber *usedNET; //已使用的资源
        if (!address || [address isKindOfClass:[NSNull class]]) {
            balance = [NSDecimalNumber decimalNumberWithString:@"0"];
            mortgagedINB = [NSDecimalNumber decimalNumberWithString:@"0"];
            canuseNET = [NSDecimalNumber decimalNumberWithString:@"0"];
            usedNET = [NSDecimalNumber decimalNumberWithString:@"0"];
            
        }else{
            balance = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@", resonseObject[@"balance"]]];
            if(!balance || [balance isEqualToNumber:NSDecimalNumber.notANumber]){
                balance = [NSDecimalNumber decimalNumberWithString:@"0"];
            }
            
            NSDictionary *res = resonseObject[@"res"];
            mortgagedINB = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@", res[@"mortgage"]]]; //抵押的INB
            if(!mortgagedINB || [mortgagedINB isEqualToNumber:NSDecimalNumber.notANumber]){
                mortgagedINB = [NSDecimalNumber decimalNumberWithString:@"0"];
            }
            
            NSString *usableStr = [NSString stringWithFormat:@"%@",res[@"usable"]];
             canuseNET = [NSDecimalNumber decimalNumberWithString:usableStr];
            if(!canuseNET || [canuseNET isEqualToNumber:NSDecimalNumber.notANumber]){
                canuseNET = [NSDecimalNumber decimalNumberWithString:@"0"];
            }
            
            usedNET = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",res[@"used"]]];
            if(!usedNET || [usedNET isEqualToNumber:NSDecimalNumber.notANumber]){
                usedNET = [NSDecimalNumber decimalNumberWithString:@"0"];
            }
        }
        
        NSDecimalNumber *totalNET = [canuseNET decimalNumberByAdding:usedNET]; //总抵押的NET
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.balance = [balance doubleValue];
            self.canUseNet = [canuseNET doubleValue];
            self.totalNet = [totalNET doubleValue];
            self.mortgageINB = [mortgagedINB doubleValue];
            
            
            self.CPUView.remainingValue.text = [NSString stringWithFormat:@"%@ RES",canuseNET];
            self.CPUView.totalValue.text = [NSString stringWithFormat:@"%@ RES",totalNET];
            self.CPUView.mortgageValue.text = [NSString stringWithFormat:@"%@ INB",[NSString changeNumberFormatter:[mortgagedINB stringValue]]];
            
            self.selectedWallet.mortgagedINB = [mortgagedINB doubleValue];
            self.selectedWallet.balanceINB = [balance doubleValue];
            [self.CPUView updataNet];
            [self updatePrice];
        });
        
 
        
    } failed:^(NSError * _Nonnull error) {
        [self.scrollView.mj_header endRefreshing];
        [MBProgressHUD showMessage:@"网络请求失败" toView:App_Delegate.window afterDelay:1.5 animted:YES];
        NSLog(@"%@", error);
    }];
}

#pragma mark ---- 通知
-(void)addWalletNoti:(NSNotification *)noti{
    BasicWallet *wallet = noti.object;
    Identity *identi = [Identity currentIdentity];
    if(identi.wallets.count != 0){
        self.selectedWallet = [identi.wallets lastObject];
        self.wallets = identi.wallets;
        return ;
    }
    [self changeToCreate];
}

-(void)changeToCreate{
    WelcomVC *welcomVC = [[WelcomVC alloc] init];
    /** 导航栏背景色 **/
    [welcomVC.navigationController.navigationBar setBarTintColor:kColorBlue];
    welcomVC.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:AdaptedFontSize(16)};
    
    /** 导航栏返回按钮文字 **/
    welcomVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    welcomVC.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];
    
    welcomVC.title = @"";
    welcomVC.tabBarItem.image = [[UIImage imageNamed:@"tab_wallet_no"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//渲染模式初始化
    welcomVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_wallet_yes"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    welcomVC.tabBarItem.title = @"钱包";
    
    TabBarVC *tab = (TabBarVC *)self.tabBarController;
    CCNavigationController *navi = tab.viewControllers[0];
    [navi setViewControllers:@[welcomVC] animated:YES];
}

-(void)mortgageChangeNoti:(NSNotification *)noti{
//    [self queryBalance];
//    [self queryMortgage];
//    [self queryAccountInfo];
    [self request];
}
#pragma mark ---- UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    float y= scrollView.contentOffset.y;
    if(y > 35){
        //显示导航栏背景色
        //    如果不想让其他页面的导航栏变为透明 需要重置
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        //去掉透明后导航栏下边的黑线
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    }else{
        //导航栏背景色为透明
        //设置导航栏背景图片为一个空的image，这样就透明了
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        //去掉透明后导航栏下边的黑线
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
        
    }
   
    
//     //scrollView已经有拖拽手势，直接拿到scrollView的拖拽手势
//    UIPanGestureRecognizer *pan = scrollView.panGestureRecognizer;
//    //获取到拖拽的速度 >0 向下拖动 <0 向上拖动
//    CGFloat velocity = [pan velocityInView:scrollView].y;
//    if (velocity <- 5) { //向上拖动，隐藏导航栏
//        //    如果不想让其他页面的导航栏变为透明 需要重置
//        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//        //恢复黑线
//        [self.navigationController.navigationBar setShadowImage:nil];
//
//    }else if (velocity > 20) { //向下拖动，显示导航栏
//        //设置导航栏背景图片为一个空的image，这样就透明了
//        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//        //去掉透明后导航栏下边的黑边
//        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
//
//    }else if(velocity == 0){ //停止拖拽
//
//    }
}
#pragma mark ----
//点击资源信息
-(void)cpuResource{
//    ResourceVC *resourceVC = [[ResourceVC alloc] init];
//    resourceVC.address = self.selectedWallet.address;
//    resourceVC.canUseNet  = self.canUseNet;
//    resourceVC.totalNet = self.totalNet;
//    resourceVC.mortgageINB = self.mortgageINB;
//    resourceVC.navigationItem.title = NSLocalizedString(@"resource", @"资源");
//    resourceVC.hidesBottomBarWhenPushed = YES;
    
    SuspendTopPausePageVC *resourceVC = [SuspendTopPausePageVC suspendTopPausePageVC];
    resourceVC.address = self.selectedWallet.address;
    resourceVC.canUseNet  = self.canUseNet;
    resourceVC.totalNet = self.totalNet;
    resourceVC.mortgageINB = self.mortgageINB;
    resourceVC.navigationItem.title = NSLocalizedString(@"resource", @"资源");
    resourceVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:resourceVC animated:YES];
}
#pragma mark **** 按钮 Action
//显示/隐藏资产
-(void)showOrHidenAssetsAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    [self showBalance:sender.selected];
}

-(void)showBalance:(BOOL)isHiden{
    if(isHiden){
        //隐藏资产数字
        NSString *str = [NSString stringWithFormat:@"**** INB"];
        NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:AdaptedFontSize(30),
                                                                                                               NSForegroundColorAttributeName:[UIColor whiteColor]
                                                                                                               }];
        [mutStr setAttributes:@{NSFontAttributeName:AdaptedFontSize(20),
                                NSForegroundColorAttributeName:[UIColor whiteColor]
                                } range:[str rangeOfString:@"INB"]];
        self.inbAssetsValue.attributedText = mutStr;//self.viewModel.assets_inb_hiden;
        self.cnyAssetsValue.text = [NSString stringWithFormat:@"≈ $****"]; //self.viewModel.assets_cny_hiden;
    }else{
        NSString *numberStr = [NSString changeNumberFormatter:[NSString stringWithFormat:@"%.4f", self.balance]];
        //显示资产数字
        NSString *str = [NSString stringWithFormat:@"%@ INB", [NSString changeNumberFormatter:numberStr]];
        NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:AdaptedFontSize(30),
                                                                                                               NSForegroundColorAttributeName:[UIColor whiteColor]
                                                                                                               }];
        [mutStr setAttributes:@{NSFontAttributeName:AdaptedFontSize(20),
                                NSForegroundColorAttributeName:[UIColor whiteColor]
                                } range:[str rangeOfString:@"INB"]];
        self.inbAssetsValue.attributedText = mutStr;
        NSString *cnyNumberStr = [NSString changeNumberFormatter:[NSString stringWithFormat:@"%.2f", self.balance * self.inbPrice]];
        self.cnyAssetsValue.text = [NSString stringWithFormat:@"≈ $%@", cnyNumberStr];
    }
}

//钱包详情
-(void)walletDetailAction:(UIButton *)sender{
    WalletDetailVC *detailVC = [[WalletDetailVC alloc] init];
    detailVC.wallet = self.selectedWallet;
    detailVC.navigationItem.title = NSLocalizedString(@"walletDetail", @"钱包详情");
    detailVC.view.backgroundColor = [UIColor whiteColor];
    detailVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}
//显示账户列表
-(void)showAccountsList:(UIButton *)sender{
    __weak __block typeof(self) tmpSelf = self;
    WalletAccountsListView *listView = [WalletAccountsListView showAccountList:self.wallets selectAccount:self.selectedWallet clickBlock:^(int index) {
        tmpSelf.selectedWallet = tmpSelf.wallets[index];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showMessage:NSLocalizedString(@"tip.wallet.change", @"切换钱包成功") toView:self.view afterDelay:1 animted:YES];
            [[NSUserDefaults standardUserDefaults] setObject:_selectedWallet.walletID forKey:kUserDefaltKey_LastSelectedWalletID]; //记录上次选中的钱包
        });
    }];
    listView.addAccountBlock = ^{
        if(self.wallets.count >= kWalletsMaxNumber){
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showMessage:NSLocalizedString(@"tip.importWallet.maxNumber", @"钱包数量已达到最大值") toView:App_Delegate.window afterDelay:1 animted:YES];
            });
        }else{
            WalletImportVC *importVC = [[WalletImportVC alloc] init];
            importVC.hidesBottomBarWhenPushed = YES;
            [tmpSelf.navigationController pushViewController:importVC animated:YES];
        }
    };
}
#pragma mark **** getter
-(UIImageView *)topBgImageView{
    if (_topBgImageView == nil) {
        _topBgImageView = [[UIImageView alloc] init];
        _topBgImageView.image = [UIImage imageNamed:@"wallet_top_bg"];
    }
    return _topBgImageView;
}
-(WalletInfoFunctionView *)functionView{
    if (_functionView == nil) {
        _functionView = [[WalletInfoFunctionView alloc] init];
    }
    return _functionView;
}
-(UILabel *)myAssets{
    if (_myAssets == nil) {
        _myAssets = [[UILabel alloc] init];
        _myAssets.text = NSLocalizedString(@"myAssets", @"我的资产");
        _myAssets.textColor = [UIColor whiteColor];
        _myAssets.font = AdaptedFontSize(13);
    }
    return _myAssets;
}
-(UIButton *)eyeBtn{
    if (_eyeBtn == nil) {
        _eyeBtn = [[UIButton alloc] init];
        [_eyeBtn setImage:[UIImage imageNamed:@"eye_open"] forState:UIControlStateNormal];
        [_eyeBtn setImage:[UIImage imageNamed:@"eye_close"] forState:UIControlStateSelected];
        [_eyeBtn addTarget:self action:@selector(showOrHidenAssetsAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _eyeBtn;
}
-(UILabel *)inbAssetsValue{
    if (_inbAssetsValue == nil) {
        _inbAssetsValue = [[UILabel alloc] init];
        _inbAssetsValue.textColor = [UIColor whiteColor];
    }
    return _inbAssetsValue;
}
-(UILabel *)cnyAssetsValue{
    if (_cnyAssetsValue == nil) {
        _cnyAssetsValue = [[UILabel alloc] init];
        _cnyAssetsValue.font = AdaptedFontSize(15);
        _cnyAssetsValue.textColor = [UIColor whiteColor];
    }
    return _cnyAssetsValue;
}
-(WalletInfoCPUView *)CPUView{
    if (_CPUView == nil) {
        _CPUView = [[WalletInfoCPUView alloc] initWithViewModel:self.viewModel];
        _CPUView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cpuResource)];
        [_CPUView addGestureRecognizer:tap];
        __weak __block typeof(self) tmpSelf = self;
        _CPUView.addMortgageBlock = ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [tmpSelf cpuResource];
            });
        };
        _CPUView.toMortgageBlock = ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                redeemVC *vc2 = [[redeemVC alloc] init];
                vc2.navigationItem.title = NSLocalizedString(@"Resource.record", @"抵押记录");
                vc2.hidesBottomBarWhenPushed = YES;
                
                [self.navigationController pushViewController:vc2 animated:YES];
            });
        };
    }
    return _CPUView;
}

-(UIButton *)walletDetailBtn{
    if (_walletDetailBtn == nil) {
        _walletDetailBtn = [[UIButton alloc] init];
        UIImage *bgImg = [UIImage imageNamed:@"wallet_detail_bg"];
        bgImg = [bgImg resizableImageWithCapInsets:UIEdgeInsetsMake(0, bgImg.size.width-1, 0, 1) resizingMode:UIImageResizingModeStretch];
        [_walletDetailBtn setBackgroundImage:bgImg forState:UIControlStateNormal];
        UIImage *highlightImg = [UIImage imageNamed:@"wallet_detail_highlight_bg"];
        highlightImg = [highlightImg resizableImageWithCapInsets:UIEdgeInsetsMake(0, highlightImg.size.width-1, 0, 1) resizingMode:UIImageResizingModeStretch];
        [_walletDetailBtn setBackgroundImage:highlightImg forState:UIControlStateHighlighted];
        [_walletDetailBtn setTitle:NSLocalizedString(@"walletDetail", @"钱包详情") forState:UIControlStateNormal];
        _walletDetailBtn.titleLabel.font = AdaptedFontSize(12);
        [_walletDetailBtn setTitleColor:kColorBlue forState:UIControlStateNormal];
        [_walletDetailBtn addTarget:self action:@selector(walletDetailAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _walletDetailBtn;
}

-(void)setSelectedWallet:(BasicWallet *)selectedWallet{
    _selectedWallet = selectedWallet;
    
    App_Delegate.selectAddr     = _selectedWallet.address;
    App_Delegate.selectWalletID = _selectedWallet.walletID;
    
    [self.accountNameBtn setTitle:selectedWallet.imTokenMeta.name forState:UIControlStateNormal];
    [self.accountNameBtn rightImgleftTitle:5];
    
//    [self queryAccountInfo];
    [self request];
}

// 十六进制数字字符串转换为大数。
-(NSDecimalNumber *)stringFromHexString:(NSString *)hexString { //
    
    if ([hexString hasPrefix:@"0x"]) {
        hexString = [hexString substringFromIndex:2];
    }
    
    NSDecimalNumber *totalDecimalNumber = [NSDecimalNumber decimalNumberWithString:@"0"];
    int length = hexString.length;
    for (int i=length-1; i >= 0; i--) {
        NSString *str = [hexString substringWithRange:NSMakeRange(i, 1)];
        NSInteger v = (NSInteger)strtoul([str UTF8String], 0, 16);
        totalDecimalNumber = [totalDecimalNumber decimalNumberByAdding:[[[NSDecimalNumber alloc] initWithInt:v] decimalNumberByMultiplyingBy:[[NSDecimalNumber decimalNumberWithString:@"16"] decimalNumberByRaisingToPower:length-1-i]]];
    }
    return totalDecimalNumber;
    
    
}


- (NSData *)convertHexStrToData:(NSString *)str
{
    if (!str || [str length] == 0) {
        return nil;
    }
    
    if([str hasPrefix:@"0x"]){
        str = [str substringFromIndex:2];
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:20];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}

@end
