//
//  SettingAboutUsVC.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/26.
//  Copyright © 2019 apple. All rights reserved.
//

#import "SettingAboutUsVC.h"
#import "SettingCell.h"

#import "SettingAboutUsHeaderView.h"

#define cellId @"settingCell"

@interface SettingAboutUsVC ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@end

@implementation SettingAboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    SettingAboutUsHeaderView *headerView = [[SettingAboutUsHeaderView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, 0)];
    self.tableView.tableHeaderView = headerView;
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:self.tableView];
    
}


#pragma mark ---- TableViewDataSource && Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([SettingCell class]) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellId];
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    }
    
    cell.hideSubTitle = YES;
    cell.hideAuxiliaryImg = YES;
    cell.hideSeperator = NO;
    if (indexPath.row == 0) {
        cell.title.text = NSLocalizedString(@"setting.aboutUs.protocal", @"使用协议与隐私条款");
    }else if(indexPath.row == 1){
        cell.title.text = NSLocalizedString(@"setting.aboutUs.website", @"官方网站");
    }else{
        cell.title.text = NSLocalizedString(@"setting.aboutUs.weChat", @"微信公众号");
        cell.hideSeperator = YES;
    }
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, AdaptedWidth(8))];
    view.backgroundColor = kColorBackground;
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return AdaptedWidth(8);
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark ----
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
