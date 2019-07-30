//
//  SettingSystemVC.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/25.
//  Copyright © 2019 apple. All rights reserved.
//

#import "SettingSystemVC.h"
#import "SettingCell.h"
#import "SettingCell_2.h"

#define cellId  @"settingCell"
#define cellId2 @"settingCell_2"
@interface SettingSystemVC ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@end

@implementation SettingSystemVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:self.tableView];
    
}
#pragma mark ---- TableViewDataSource && Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 0;
    }else if (section == 1){
        return 2;
    }else{
        return 0;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
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
            cell.title.text = NSLocalizedString(@"setting.system.language", @"语言选择");
            cell.subTitle.text = @"简体中文";
            cell.hideSubTitle = NO;
        }else{
            cell.title.text = NSLocalizedString(@"setting.system.push", @"语言选择");
            cell.hideSeperator = YES;
        }
        return cell;
    }else if (indexPath.section == 1){
        SettingCell_2 *cell_2 = [tableView dequeueReusableCellWithIdentifier:cellId2];
        if (cell_2 == nil) {
            UINib *nib = [UINib nibWithNibName:NSStringFromClass([SettingCell_2 class]) bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:cellId2];
            cell_2 = [tableView dequeueReusableCellWithIdentifier:cellId2];
        }
        cell_2.hideSeperator = NO;
        if (indexPath.row == 0) {
            cell_2.title.text = NSLocalizedString(@"setting.system.lockOfApp", @"应用锁");
        }else if(indexPath.row == 1){
            cell_2.title.text = NSLocalizedString(@"seeting.system.TouchID", @"Touch ID");
            cell_2.hideSeperator = YES;
        }
        return cell_2;
    }else{
        return nil;
    }
    
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
