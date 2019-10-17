//
//  MineVC.m
//  wallet
//
//  Created by apple on 2019/3/21.
//  Copyright © 2019 apple. All rights reserved.
//

#import "SettingVC.h"
#import "SettingCell.h"

#import "SettingSystemVC.h"
#import "SettingAboutUsVC.h"
#import "BasicWebViewController.h"

#import "UpdateView.h"
#import "NetworkUtil.h"

#define cellId @"settingCell"

@interface SettingVC ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;

@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
    
}

-(NSString *)getVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // app build版本
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    return [NSString stringWithFormat:@"V %@", app_Version];
    
}

#pragma mark ---- 跳转至safari下载
-(void)showSafari:(NSString *)downUrl{
    //    @"http://insightchain.io/app/introduction"
    NSString * urlStr = [NSString stringWithFormat:downUrl]; //[LocalData instance].config.appVersion.downloadUrl
    NSURL *url = [NSURL URLWithString:urlStr];
    if([[UIDevice currentDevice].systemVersion floatValue] >= 10.0){
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [[UIApplication sharedApplication] openURL:url options:@{}
                                     completionHandler:^(BOOL success) {
                                         NSLog(@"Open %d",success);
                                     }];
        } else {
            BOOL success = [[UIApplication sharedApplication] openURL:url];
            NSLog(@"Open  %d",success);
        }
        
    } else{
        bool can = [[UIApplication sharedApplication] canOpenURL:url];
        if(can){
            [[UIApplication sharedApplication] openURL:url];
        }
    }
    
}

#pragma mark ---- UITableViewDataSource && Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (0 == section) {
        return 0;//1;
    }else if (1 == section){
        return 2;
    }else if(2 == section){
        return 1;
    }else{
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([SettingCell class]) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellId];
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    }
    cell.hideSeperator = NO;
    
    if(indexPath.section == 0){
        if (indexPath.row == 0) {
            cell.title.text = NSLocalizedString(@"setting.system", @"系统设置");
            cell.auxiliaryImg.image = [UIImage imageNamed:@"setting_system"];
        }else if (indexPath.row == 1){
            cell.hideSeperator = YES;
            cell.title.text = NSLocalizedString(@"setting.invite", @"邀请好友");
            cell.auxiliaryImg.image = [UIImage imageNamed:@"setting_invite"];
        }
    }else if (indexPath.section == 1){
        if(indexPath.row == 0){
            cell.title.text = NSLocalizedString(@"setting.checkUpdate", @"检查更新");
            cell.auxiliaryImg.image = [UIImage imageNamed:@"setting_checkUpdate"];
            cell.subTitle.text = [self getVersion];
            cell.hideSubTitle = NO;
        }else if (indexPath.row == 1){
            cell.hideSeperator = YES;
            cell.title.text = NSLocalizedString(@"setting.help", @"帮助中心");
            cell.auxiliaryImg.image = [UIImage imageNamed:@"setting_help"];
        }
    }else if (indexPath.section == 2){
        cell.hideSeperator = YES;
        cell.title.text = NSLocalizedString(@"setting.aboutUs", @"关于我们");
        cell.auxiliaryImg.image = [UIImage imageNamed:@"setting_aboutUs"];
    }
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 1 || section == 0){
        return nil;
    }else{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, AdaptedWidth(8))];
        view.backgroundColor = kColorBackground;
        return view;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 1 || section == 0){
        return 0.0001;
    }else{
        return AdaptedWidth(8);
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    /** 导航栏返回按钮文字 **/
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            SettingSystemVC *systemSettingVC = [[SettingSystemVC alloc] init];
            systemSettingVC.navigationItem.title = NSLocalizedString(@"setting.system", @"系统设置");
            systemSettingVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:systemSettingVC animated:YES];
        }
    }else if (indexPath.section == 1){
        
        __block __weak typeof(self) tmpSelf = self;
        NSString *ho = App_Delegate.apiHost;
        [NetworkUtil getRequest:HTTP(hostUrl_211, @"wallet/version") params:@{@"appType":@(3)}success:^(id  _Nonnull resonseObject) {
            NSLog(@"检查更新---%@", resonseObject);
            NSDictionary *dic = resonseObject[@"data"];
            if(APP_VERSION != dic[@"versionName"] || APP_BUILD != dic[@"versionCode"]){
                [UpdateView showUpadate:dic[@"versionName"] intro:dic[@"releaseNote"] updateBlock:^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [tmpSelf showSafari:dic[@"downloadUrl"]];
                    });
                }];
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD showMessage:@"当前已是最新版本" toView:App_Delegate.window afterDelay:1 animted:YES];
                });
            }
            
        } failed:^(NSError * _Nonnull error) {
            NSLog(@"检查更新失败---%@",error);
        }];
        
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            SettingAboutUsVC *systemSettingVC = [[SettingAboutUsVC alloc] init];
            systemSettingVC.navigationItem.title = NSLocalizedString(@"setting.aboutUs", @"关于我们");
            systemSettingVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:systemSettingVC animated:YES];
        }
    }
}

#pragma mark ---- setter && getter
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, KHEIGHT) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kColorBackground;
    }
    return _tableView;
}

@end
