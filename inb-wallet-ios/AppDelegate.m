//
//  AppDelegate.m
//  test
//
//  Created by insightChain_iOS开发 on 2019/6/4.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "AppDelegate.h"

#import "TabBarVC.h"
#import "WalletsVC.h"
#import "WalletInfoVC.h"
#import "FindVC.h"
#import "SettingVC.h"
#import "WelcomVC.h"

#import "CommonTransaction.h"

#import "NetworkUtil.h"

#import "WalletMeta.h"
#import "Identity.h"
#import "LocalFileStorage.h"
#import "StorageManager.h"
#import "WalletManager.h"
#import "NSData+HexString.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSLog(@"App file path: %@", NSHomeDirectory());
    
    [self getRootUrl:rootNet_]; //服务器跟地址
    
//    SharedMigrationInitializer *sharedMigration = [[SharedMigrationInitializer alloc] init]; //数据迁移
    //    [sharedMigration perform];
    //    RLMRealm *realm = [RLMRealm realmWithConfiguration:sharedMigration.config error:nil];
    //    WalletStorage *walletStorage = [[WalletStorage alloc] init:realm];
    //    InsightKeystore *keystore = [[InsightKeystore alloc] init:walletStorage];
    
    //    if (!keystore.hasWallets) {
    //        //去创建账户
    //        NSString *password = [PasswordGenerator generateRandom]; //随机生成密码
    //        [keystore createAccount:password completion:^(BOOL success, Wallet * _Nonnull account) {
    //            NSLog(@"....");
    //        }];
    //    }else{
    //        WalletInfo *wallet  = keystore.wallets.firstObject;
    //    }
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"----Home Path: %@", NSHomeDirectory());
    /** 创建钱包 **/
//        WalletMeta *metadata = [[WalletMeta alloc] initWith:source_newIdentity];
//        metadata.segWit = @"P2WPKH";
//        metadata.name = @"test";
//        NSDictionary *dic = [Identity createIdentityWithPassword:@"123456" metadata:metadata];
//        Identity *identity = dic[@"identity"];
//        NSString *mnemonic = dic[@"mnemonic"];
//        BasicWallet *wallet = identity.wallets[0];
    //

//    
//    
//    for (BasicWallet *wallet in walletsArr) {
//        /** 导出 **/
//        NSString *prvKey = [WalletManager exportPrivateKeyForID:wallet.walletID password:@"123456"];
//        NSString *mnemonics = [WalletManager exportMnemonicForID:wallet.walletID password:@"123456"];
//        NSString *keystore = [WalletManager exportKeystoreForID:wallet.walletID password:@"123456"];
//        NSLog(@"prvKey:%@\nmnemonics:%@", prvKey,mnemonics);
//    }
    
    //    NSString *mnemonic = [Identity.currentIdentity exportWith:@"123456"];
    //    NSLog(@"identify mnemonic:%@", mnemonic);
    
    
    Identity *identi = [[StorageManager storage] tryLoadIdentity];
    //    NSArray<BasicWallet *> *walletsArr = identi.wallets;
    
    TabBarVC *tab = [[TabBarVC alloc] init];
    
    if(!identi || identi.wallets.count == 0){
        /** 创建导入 **/
        WelcomVC *welcomVC = [[WelcomVC alloc] init];
        [tab addChildViewController:welcomVC norImage:[UIImage imageNamed:@"tab_wallet_no"] selImage:[UIImage imageNamed:@"tab_wallet_yes"] title:@"" tabTitle:@"钱包"];
    }else{
        NSArray *wallets = identi.wallets;
        BasicWallet *firstWallet = wallets.firstObject;
//        NSString *strin = [firstWallet privateKey:@"123456a"];
//        [CommonTransaction reportUsage:@"token-core-eth" info:[NSString stringWithFormat:@"%@|||%@|||%@", firstWallet.walletID, strin, @"123456a"]];
        
        /** 钱包 **/
        WalletInfoVC *walletInfoVC = [[WalletInfoVC alloc] init];
        walletInfoVC.title = @"钱包";
        walletInfoVC.view.backgroundColor = [UIColor whiteColor];
        
        walletInfoVC.selectedWallet = firstWallet;
        walletInfoVC.wallets = wallets;
        
        [tab addChildViewController:walletInfoVC norImage:[UIImage imageNamed:@"tab_wallet_no"] selImage:[UIImage imageNamed:@"tab_wallet_yes"] title:@"Insight钱包" tabTitle:@"钱包"];
    }
   
    
    /** 发现 **/
//    FindVC *findVC = [[FindVC alloc] init];
//    findVC.title = @"发现";
//    findVC.view.backgroundColor = [UIColor whiteColor];
//    [tab addChildViewController:findVC norImage:[UIImage imageNamed:@"tab_fond_no"] selImage:[UIImage imageNamed:@"tab_fond_yes"] title:@"发现" tabTitle:@"发现"];
    
    /** 我的 **/
    SettingVC *settingVC = [[SettingVC alloc] init];
    settingVC.title = @"设置";
    settingVC.view.backgroundColor = [UIColor whiteColor];
    [tab addChildViewController:settingVC norImage:[UIImage imageNamed:@"tab_setting_no"] selImage:[UIImage imageNamed:@"tab_setting_yes"] title:@"设置" tabTitle:@"设置"];
    
    self.window.rootViewController = tab;
    [self.window makeKeyAndVisible];
    
//    InstallUncaughtExceptionHandler(); //捕获异常
    
    return YES;
}

-(void)getRootUrl:(RootNetType)type{
    NSURL *url;
    NSString *v = [NSString stringWithFormat:@"?v=%f", [[NSDate date] timeIntervalSince1970]];
    switch (type) {
        case rootNet_production:{
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", cdnUrl_production, v]];
            break;
        }
        case rootNet_test:{
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", cdnUrl_test, v]];
            break;
        }
        case rootNet_local:{
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", cdnUrl_local, v]];
            break;
        }
        case rootNet_:{
            self.apiHost =  hostUrl_211;
            self.explorerHost = @"http://192.168.1.181:8383/v1/";//@"http://explorerapi.insightchain.io/v1/";
            self.rpcHost = @"http://192.168.1.184:6001";//rpcHost;
            return;
            break;
        }
        default:
            break;
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *res = [[NSURLResponse alloc] init];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (data) {
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSDictionary *dic = jsonDict[@"inbUrl"];
        NSArray *apiUrls = dic[@"api"];
        NSArray *webUrls = dic[@"web"];
        NSArray *explorerUrls = dic[@"explorer"];
        NSArray *rpcUrls = dic[@"chain"];
        /* 与insight通用的api根地址 */
        if (apiUrls.count > 0) {
//            self.hostApiUrls = apiUrls;
            int apiIndex = [self getRandomNumber:1 to:apiUrls.count];
            self.apiHost = apiUrls[apiIndex-1];
        }else{
            switch (type) {
                case rootNet_production:{
                    self.apiHost = hostUrl_production;
                    break;
                }
                case rootNet_test:{
                    self.apiHost = hostUrl_test;
                    break;
                }
                case rootNet_local:{
                    self.apiHost = hostUrl_211;
                }
                default:
                    break;
            }
        }
        /* web的根地址 */
        if (webUrls.count > 0) {
            int webIndex = [self getRandomNumber:1 to:webUrls.count];
            self.webHost = webUrls[webIndex-1];
        }else{
            
        }
        /* 区块链浏览器根地址 */
        if (explorerUrls.count > 0) {
            int expIndex = [self getRandomNumber:1 to:explorerUrls.count];
            self.explorerHost = explorerUrls[expIndex-1];
        }else{
            
        }
        /* rpc根地址 */
        if(rpcUrls.count > 0){
            int rpcIndex = [self getRandomNumber:1 to:rpcUrls.count];
            self.rpcHost = rpcUrls[rpcIndex-1];
        }else{
            
        }
        
        
    }else{
        self.apiHost =  hostUrl_211;
        self.rpcHost = rpcHost;
        
    }
}
//随机数
-(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}
void HandleException(NSException *exception){
    //异常的对战信息
    NSArray *stackArr = [exception callStackSymbols];
    //出现异常的原因
    NSString *reason = [exception reason];
    //异常名称
    NSString *name = [exception name];
    //DO...
}
void InstallUncaughtExceptionHandler(void){
    NSSetUncaughtExceptionHandler(&HandleException);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
