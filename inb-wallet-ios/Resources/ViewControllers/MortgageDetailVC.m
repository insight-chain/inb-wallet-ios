//
//  MortgageDetailVC.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/9/10.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "MortgageDetailVC.h"

#import "TransferMessageCell.h"
#import "TransferFooterView.h"

#define cellId_1 @"messageType_1"

@interface MortgageDetailVC ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property(nonatomic, strong) TransferFooterView *tableFooter;

@property (weak, nonatomic) IBOutlet UILabel *morgageStrL; //抵押数量
@property (weak, nonatomic) IBOutlet UILabel *morgageValue; //抵押的值
@property (weak, nonatomic) IBOutlet UILabel *rewardStrL; //抵押收益
@property (weak, nonatomic) IBOutlet UILabel *rewardValue; //收益值
@property (weak, nonatomic) IBOutlet UIButton *rewardBtn; //领取按钮

@end

@implementation MortgageDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle  = UITableViewCellSelectionStyleNone;
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableFooter = [[TransferFooterView alloc] init];
    self.tableFooter.frame = CGRectMake(0, 0, KWIDTH, AdaptedWidth(202));
    self.tableView.tableFooterView = self.tableFooter;
    self.tableFooter.info = @"交易信息dfasfasfddasfas";
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
        cell.value.text = @"0x95dfasdad5485as4df5ads5asd5";
        cell.showRightBtn = YES;
        cell.rightBtnType = 1;
    }else if (indexPath.row == 1){
        cell.typeName.text = @"收款地址";
        cell.value.text = @"0x95dfasdad5485as4df5ads5asd5";
        cell.showRightBtn = YES;
        cell.rightBtnType = 1;
    }else if(indexPath.row == 2){
        cell.typeName.text = @"抵押期限";
        cell.value.text = @"360天";
    }else if(indexPath.row == 3){
        cell.typeName.text = @"七日年化";
        cell.value.text = @"5.64%";
    }else if(indexPath.row == 4){
        cell.typeName.text = @"抵押日期";
        cell.value.text = @"2019-05-30 12:25:00";
    }else if(indexPath.row == 5){
        cell.typeName.text = @"区块号";
        cell.value.text = @"fasfas5454512152";
        cell.showRightBtn = YES;
        cell.rightBtnType = 1;
    }else if(indexPath.row == 6){
        cell.typeName.text = @"交易时间";
        cell.value.text = @"2019-13-03 12:12:36";
    }else if(indexPath.row == 7){
        cell.typeName.text = @"交易号";
        cell.value.text = @"2019-13-03 12:12:36";
        cell.showRightBtn = YES;
        cell.rightBtnType = 2;
        cell.showSeperatorView = NO;
    }
    
    return cell;
}

#pragma mark ---- Button Action
//领取按钮
- (IBAction)rewardAction:(UIButton *)sender {
}

@end
