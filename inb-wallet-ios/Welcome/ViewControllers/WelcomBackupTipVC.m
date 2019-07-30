//
//  WelcomBackupTipVC.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/28.
//  Copyright © 2019 apple. All rights reserved.
//

#import "WelcomBackupTipVC.h"
#import "WelcomBackupVC.h"
#import "WalletManager.h"
#import "Identity.h"

@interface WelcomBackupTipVC ()
@property (weak, nonatomic) IBOutlet UILabel *tipLabel_1;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel2;
@property (weak, nonatomic) IBOutlet UIButton *backupBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@end

@implementation WelcomBackupTipVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.topConstraint.constant = kNavigationBarHeight+30;
    
    self.tipLabel_1.text = NSLocalizedString(@"backup.tip_1", @"妥善备份钱包才能保障您的资产安全。卸载程序或删除钱包后，您需要备份文件来恢复钱包");
    self.tipLabel2.text = NSLocalizedString(@"backup.tip_2", @"请在四周无人、确保没有摄像头的安全环境下进行备份");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark ---- Button Action

- (IBAction)backupAction:(UIButton *)sender {
    /** 导航栏返回按钮文字 **/
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];
    
//    Identity *identity = [Identity currentIdentity];
//    NSArray<BasicWallet *> *wallets = identity.wallets;
//    BasicWallet *wallet = wallets[0];
    
    __weak __block typeof(self) tmpSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *mnemonry = [WalletManager exportMnemonicForID:tmpSelf.wallet.walletID password:self.password];
        NSString *privateKey = [WalletManager exportPrivateKeyForID:tmpSelf.wallet.walletID password:self.password];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:tmpSelf.view animated:YES];
            WelcomBackupVC *backupVC = [[WelcomBackupVC alloc] init];
            backupVC.navigationItem.title = NSLocalizedString(@"backupWallet", @"备份钱包");
            backupVC.memonry = mnemonry;
            backupVC.privateKey = privateKey;
            [tmpSelf.navigationController pushViewController:backupVC animated:YES];
        });
    });
    
}
@end
