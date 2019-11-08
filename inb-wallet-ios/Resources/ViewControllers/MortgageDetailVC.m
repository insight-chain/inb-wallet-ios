//
//  MortgageDetailVC.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/9/10.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "MortgageDetailVC.h"

#import "TransferMessageCell.h"
#import "TransferMessage_3Cell.h"
#import "TransferFooterView.h"

#import "BasicWebViewController.h"
#import "NetworkUtil.h"

#define cellId_1 @"messageType_1"
#define cellId_3 @"messageType_3"

@interface MortgageDetailVC ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property(nonatomic, strong) TransferFooterView *tableFooter;

@property (weak, nonatomic) IBOutlet UILabel *morgageStrL; //抵押数量
@property (weak, nonatomic) IBOutlet UILabel *morgageValue; //抵押的值
@property (weak, nonatomic) IBOutlet UILabel *rewardStrL; //抵押收益
@property (weak, nonatomic) IBOutlet UILabel *rewardValue; //收益值
@property (weak, nonatomic) IBOutlet UIButton *rewardBtn; //领取按钮

@property (nonatomic, assign) NSInteger currentBlockNumber; //当前块高度

@end

@implementation MortgageDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /** 导航栏返回按钮文字 **/
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];
    
    self.tableView.separatorStyle  = UITableViewCellSelectionStyleNone;
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableFooter = [[TransferFooterView alloc] init];
    self.tableFooter.frame = CGRectMake(0, 0, KWIDTH, AdaptedWidth(202));
    self.tableView.tableFooterView = self.tableFooter;
    self.tableFooter.info = self.lockModel.hashStr;
    
    self.morgageValue.text = [NSString stringWithFormat:@"%@ INB",[NSString changeNumberFormatter:self.lockModel.amount]];
    self.rewardValue.text = [NSString stringWithFormat:@"%@ INB",[NSString changeNumberFormatter:[NSString stringWithFormat:@"%f",self.lockModel.reward]]];
    
    if(self.lockModel.days == 0){
        [self.rewardBtn setTitle:NSLocalizedString(@"redemption", @"赎回") forState:UIControlStateNormal];
    }else{
        NSInteger da = self.lockModel.remainingDays;
        if (da <= 0) {
             [self.rewardBtn setTitle:@"领取" forState:UIControlStateNormal];
        }else{
            [self.rewardBtn setTitle:[NSString stringWithFormat:@"%d天后领取", da] forState:UIControlStateNormal];
        }
    }
}

//获取当前块高度
-(void)requestBlockHeight{
    __block __weak typeof(self) tmpSelf = self;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [NetworkUtil rpc_requetWithURL:delegate.rpcHost
                            params:@{@"jsonrpc":@"2.0",
                                     @"method":blockNumber_MethodName,
                                     @"params":@[[App_Delegate.selectAddr add0xIfNeeded]],
                                     @"id":@(67),
                                     } completion:^(id  _Nullable responseObject, NSError * _Nullable error) {
                                         
                                         if (error) {
                                             return ;
                                         }
                                         
                                         NSString *str = responseObject[@"result"];
                                         const char *hexChar = [str cStringUsingEncoding:NSUTF8StringEncoding];
                                         int hexNumber;
                                         sscanf(hexChar, "%x", &hexNumber);
                                         tmpSelf.currentBlockNumber = hexNumber;
                                     }];
}
//七日年化
-(double)rateFor7day{
    switch (self.lockModel.days) {
        case 0:
            return 0;
        case 30:
            return kRateReturn7_30;
        case 90:
            return kRateReturn7_90;
        case 180:
            return kRateReturn7_180;
        case 360:
            return kRateReturn7_360;
        default:
            return 0;
    }
}
//抵押期限
-(NSInteger)daysForTime{
    switch (self.lockModel.days) {
        case 0:
            return 0;
        case 30:
            return 30;
        case 90:
            return 90;
        case 180:
            return 180;
        case 360:
            return 360;
        default:
            return 0;
    }
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
    TransferMessage_3Cell *cell_3 = [tableView dequeueReusableCellWithIdentifier:cellId_3];
    if(cell_3 == nil){
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([TransferMessage_3Cell class]) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellId_3];
        cell_3 = [tableView dequeueReusableCellWithIdentifier:cellId_3];
    }
    cell_3.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.showRightBtn = NO;
    cell.value.textColor = kColorTitle;
    if (indexPath.row == 0) {
        cell.typeName.text = @"付款地址";
        cell.value.text = [self.lockModel.address add0xIfNeeded];
        cell.showRightBtn = YES;
        cell.rightBtnType = 1;
    }else if (indexPath.row == 1){
        cell.typeName.text = @"收款地址";
        cell.value.text = @"--";
        cell.showRightBtn = YES;
        cell.rightBtnType = 1;
    }else if(indexPath.row == 2){
        cell.typeName.text = @"抵押期限";
        cell.value.text = [NSString stringWithFormat:@"%ld块 ≈%ld天", (long)self.lockModel.lockHeight, (long)self.lockModel.days];
    }else if(indexPath.row == 3){
        cell.typeName.text = @"年化";
        cell.value.text = [NSString stringWithFormat:@"%.1f%%", [self rateFor7day]];
    }else if(indexPath.row == 4){
        cell.typeName.text = @"开始块高度"; //@"抵押日期";
        cell.value.text = [NSString stringWithFormat:@"%ld", self.lockModel.startHeight];//@"--";
    }else if(indexPath.row == 5){
        cell.typeName.text = @"结束块高度"; //@"交易时间";
        cell.value.text = [NSString stringWithFormat:@"%ld", self.lockModel.startHeight+self.lockModel.lockHeight];//@"--";
       
    }else if(indexPath.row == 6){
        cell.typeName.text = @"区块号";
        cell.value.text = [NSString stringWithFormat:@"%ld", (long)self.lockModel.startHeight];
        cell.showRightBtn = YES;
        cell.rightBtnType = 1;
    }else if(indexPath.row == 7){
        cell_3.nameLabel.text = NSLocalizedString(@"transfer.tradeNo.", @"交易号");
        cell_3.infoLabel.text = self.lockModel.hashStr;
        return cell_3;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 7) {
        BasicWebViewController *webView = [[BasicWebViewController alloc] init];
        webView.navigationItem.title = NSLocalizedString(@"transfer.query", @"交易查询");
        webView.urlStr = [NSString stringWithFormat:@"%@TransactionHash?transactionHash=%@",App_Delegate.explorerWeb, [self.lockModel.hashStr add0xIfNeeded]];
        webView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webView animated:YES];
    }
}

#pragma mark ---- Button Action
//领取按钮
- (IBAction)rewardAction:(UIButton *)sender {
}

@end
