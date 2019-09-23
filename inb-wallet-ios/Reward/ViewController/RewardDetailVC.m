//
//  RewardDetailVC.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/9/19.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "RewardDetailVC.h"

#import "TransferMessageCell.h"

#define cellId_1 @"messageType_1"

@interface RewardDetailVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *headerTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *headerValueLabel;

@end

@implementation RewardDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableHeaderView = self.headerView;
}

#pragma mark ---- UITableViewDelegate && Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TransferMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId_1];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:@"TransferMessageCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellId_1];
        cell = [tableView dequeueReusableCellWithIdentifier:cellId_1];
    }
    
    cell.showRightBtn = NO;
    
    if (indexPath.row == 0) {
        cell.typeName.text = @"付款地址";
        cell.value.text = @"0x95dfa123asdsar1edwada3erASfcdq23";
        cell.showRightBtn = YES;
        cell.rightBtnType = 1;
    }else if (indexPath.row == 1){
        cell.typeName.text = @"收款地址";
        cell.value.text = @"--";
        cell.showRightBtn = YES;
        cell.rightBtnType = 1;
    }else if(indexPath.row == 2){
        cell.typeName.text = @"抵押期限";
        cell.value.text = @"--";
    }else if(indexPath.row == 3){
        cell.typeName.text = @"七日年化";
        cell.value.text = @"--";
    }else if(indexPath.row == 4){
        cell.typeName.text = @"抵押日期";
        cell.value.text = @"--";
    }else if(indexPath.row == 5){
        cell.typeName.text = @"区块号";
        cell.value.text = @"--";
        cell.showRightBtn = YES;
        cell.rightBtnType = 1;
    }else if(indexPath.row == 6){
        cell.typeName.text = @"交易时间";
        cell.value.text = @"--";
    }else if(indexPath.row == 7){
        cell.typeName.text = @"交易号";
        cell.value.text = @"-";
        cell.showRightBtn = YES;
        cell.rightBtnType = 2;
        cell.showSeperatorView = NO;
    }
    
    return cell;
}

@end
