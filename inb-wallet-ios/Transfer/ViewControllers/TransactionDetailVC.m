//
//  TransactionDetailVC.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/18.
//  Copyright © 2019 apple. All rights reserved.
//

#import "TransactionDetailVC.h"

#import "BasicWebViewController.h"

#import "TransferHeaderView.h"
#import "TransferFooterView.h"

#import "TransferMessageCell.h"
#import "TransferMessage_2Cell.h"
#import "TransferMessage_3Cell.h"

#import "NSDate+DateString.h"

#define cellId_1 @"messageType_1"
#define cellId_2 @"messageType_2"
#define cellId_3 @"messageType_3"

@interface TransactionDetailVC ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) TransferFooterView *tableFooter;
@property(nonatomic, strong) UIView *tableHeader;
@end

@implementation TransactionDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /** 导航栏返回按钮文字 **/
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];
    
    self.tableFooter = [[TransferFooterView alloc] init];
    self.tableFooter.frame = CGRectMake(0, 0, KWIDTH, AdaptedWidth(130));
    self.tableView.tableFooterView = self.tableFooter;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.mas_equalTo(0);
    }];
    
    self.tableFooter.info = self.tranferModel.tradingHash;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, AdaptedWidth(183))];
    if(self.tranferModel.type == TxType_vote || self.tranferModel.type == TxType_updateNodeInfo){
        
        NSString *titleStr;
        NSString *infoStr;
        if(self.tranferModel.type == TxType_vote){
            titleStr = NSLocalizedString(@"transfer.vote", @"节点投票");
            NSArray *address = [self.tranferModel.input componentsSeparatedByString:@","];
            NSMutableString *mutS = [NSMutableString string];
            [address enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *str = [obj add0xIfNeeded];
                [mutS appendString:str];
                if (idx < address.count ) {
                    [mutS appendString:@"\n"];
                }
            }];
            infoStr = [NSString stringWithFormat:@"%@\n%@", NSLocalizedString(@"vote.detail.toStr", @"投票给"), mutS];
        }else if (self.tranferModel.type == TxType_updateNodeInfo){
            titleStr = NSLocalizedString(@"transfer.typeName.node.update", @"修改节点");
            infoStr = [NSString stringWithFormat:@"修改 %@ 节点", self.tranferModel.input];
        }
        self.tableHeader = [[TransferHeaderVoteView alloc] initWithTitle:titleStr info:infoStr];
        self.tableHeader.frame = CGRectMake(0, 0, KWIDTH, ((TransferHeaderVoteView *)self.tableHeader).viewHeight);
        tableHeaderView.frame = CGRectMake(0, 0, KWIDTH, ((TransferHeaderVoteView *)self.tableHeader).viewHeight);
        [tableHeaderView addSubview:self.tableHeader];
        [self.tableHeader mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.mas_equalTo(0);
        }];
        self.tableView.tableHeaderView = tableHeaderView;
        [self.tableHeader layoutIfNeeded];
        CGRect rect = tableHeaderView.frame;
        rect.size.height = ((TransferHeaderVoteView *)self.tableHeader).viewHeight;
        tableHeaderView.frame = rect;
    }else{
        self.tableHeader = [[TransferHeaderView alloc] init];
        tableHeaderView.frame = CGRectMake(0, 0, KWIDTH, AdaptedWidth(183));
        if (self.tranferModel.type == TxType_transfer) {
            
            if (self.tranferModel.direction == 1) { //付款
                ((TransferHeaderView *)self.tableHeader).resultLabel.text = NSLocalizedString(@"transfer.success", @"转账成功");
                ((TransferHeaderView *)self.tableHeader).valueLabel.text = [NSString stringWithFormat:@"-%@ INB", [NSString changeNumberFormatter:[NSString stringWithFormat:@"%f",self.tranferModel.amount]]];
            }else{
                //收款
                ((TransferHeaderView *)self.tableHeader).resultLabel.text = NSLocalizedString(@"transfer.collection.success", @"收款成功");
                ((TransferHeaderView *)self.tableHeader).valueLabel.text = [NSString stringWithFormat:@"+%@ INB", [NSString changeNumberFormatter:[NSString stringWithFormat:@"%f",self.tranferModel.amount]]];
            }
        }else if (self.tranferModel.type == TxType_lock || self.tranferModel.type == TxType_moetgage){
            ((TransferHeaderView *)self.tableHeader).resultLabel.text = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"mortgage", @"抵押"), NSLocalizedString(@"resource", @"资源")];
            ((TransferHeaderView *)self.tableHeader).valueLabel.text = [NSString stringWithFormat:@"-%@ INB", [NSString changeNumberFormatter:[NSString stringWithFormat:@"%f",self.tranferModel.amount]]];
        }else if(self.tranferModel.type == TxType_unMortgage){
            ((TransferHeaderView *)self.tableHeader).resultLabel.text = [NSString stringWithFormat:@"%@", NSLocalizedString(@"transfer.typeName.redemption.apply", @"抵押赎回")];
            ((TransferHeaderView *)self.tableHeader).valueLabel.text = [NSString stringWithFormat:@"%@ INB", [NSString changeNumberFormatter:[NSString stringWithFormat:@"%f",self.tranferModel.amount]]];
        }else if(self.tranferModel.type == TxType_rewardVote || self.tranferModel.type == TxType_rewardLock){
            ((TransferHeaderView *)self.tableHeader).resultLabel.text = [NSString stringWithFormat:@"%@", NSLocalizedString(@"transfer.typeName.vote.reward", @"领取投票收益")];
            ((TransferHeaderView *)self.tableHeader).valueLabel.text = [NSString stringWithFormat:@"-%@ INB", [NSString changeNumberFormatter:[NSString stringWithFormat:@"%f",self.tranferModel.amount]]];
//            ((TransferHeaderView *)self.tableHeader).valueLabel.textColor = kColorAuxiliary2;
//            ((TransferHeaderView *)self.tableHeader).valueLabel.backgroundColor = kColorBackground;
//            ((TransferHeaderView *)self.tableHeader).valueLabel.layer.borderWidth = 1;
//            ((TransferHeaderView *)self.tableHeader).valueLabel.layer.borderColor = kColorSeparate.CGColor;
//            ((TransferHeaderView *)self.tableHeader).valueLabel.numberOfLines = 0;
        }else if(self.tranferModel.type == TxType_reResource){
            ((TransferHeaderView *)self.tableHeader).resultLabel.text = [NSString stringWithFormat:@"%@", NSLocalizedString(@"Resource.receive", @"领取资源")];
            ((TransferHeaderView *)self.tableHeader).valueLabel.text = @"";
        }
        
        [tableHeaderView addSubview:self.tableHeader];
        [self.tableHeader mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.mas_equalTo(0);
        }];
        self.tableView.tableHeaderView = tableHeaderView;
        [self.tableHeader layoutIfNeeded];
        CGRect rect = tableHeaderView.frame;
        rect.size.height = self.tableHeader.frame.size.height;
        tableHeaderView.frame = rect;
    }
    
    
    
}

#pragma mark ---- UITableViewDelegate && DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.tranferModel.type == TxType_vote){ //投票
        return 4;
    }else if(self.tranferModel.type == TxType_rewardVote || self.tranferModel.type == TxType_rewardLock){ //领取投票收益 || 领取抵押收益
        return 5;
    }else if(self.tranferModel.type == TxType_lock || self.tranferModel.type == TxType_moetgage){ //锁仓 //抵押
        return 6;
    }else if(self.tranferModel.type == TxType_reResource){ //领取资源
        return 4;
    }else if(self.tranferModel.type == TxType_transfer){ //交易
        if(self.tranferModel.input && ![self.tranferModel.input isEqualToString:@""]){
            return 7;
        }else{
            return 6;
        }
    }else if(self.tranferModel.type == TxType_updateNodeInfo){//修改节点
        return 4;
    }else if(self.tranferModel.type == TxType_unMortgage){ //抵押赎回
        return 5;
    }else{
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TransferMessageCell *cell_1 = [tableView dequeueReusableCellWithIdentifier:cellId_1];
    if (cell_1 == nil) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([TransferMessageCell class]) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellId_1];
        cell_1 = [tableView dequeueReusableCellWithIdentifier:cellId_1];
    }
    cell_1.selectionStyle = UITableViewCellSelectionStyleNone;
    cell_1.rightBtnType = btnType_copy; //
    cell_1.canCopy = YES;
    
    TransferMessage_2Cell *cell_2 = [tableView dequeueReusableCellWithIdentifier:cellId_2];
    if (cell_2 == nil) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([TransferMessage_2Cell class]) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellId_2];
        cell_2 = [tableView dequeueReusableCellWithIdentifier:cellId_2];
    }
    cell_2.selectionStyle = UITableViewCellSelectionStyleNone;
    
    TransferMessage_3Cell *cell_3 = [tableView dequeueReusableCellWithIdentifier:cellId_3];
    if(cell_3 == nil){
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([TransferMessage_3Cell class]) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellId_3];
        cell_3 = [tableView dequeueReusableCellWithIdentifier:cellId_3];
    }
    cell_3.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(self.tranferModel.type == TxType_lock || self.tranferModel.type == TxType_moetgage){ //锁仓
        InlineTransfer *inlineTran = self.tranferModel.transactionLog[0];
        if(indexPath.row == 0){
            cell_1.typeName.text = NSLocalizedString(@"transfer.sendMoney", @"发款账号");
            cell_1.value.text = self.tranferModel.from;
            cell_1.rightBtnType = btnType_copy; //
            cell_1.showRightBtn = YES;
            return cell_1;
        }else if (indexPath.row == 1){
            cell_1.typeName.text = NSLocalizedString(@"transfer.collectionMoney", @"收款账号");
            cell_1.value.text = inlineTran.to;
            cell_1.rightBtnType = btnType_copy;
            cell_1.showRightBtn = YES;
            return cell_1;
        }else if (indexPath.row == 2){
            cell_2.typeName.text = @"抵押详情"; //NSLocalizedString(@"transfer.resource", @"资源消耗");
            cell_2.valueName.text = @"抵押期限\n\n年化率";
            NSDecimalNumber *lockDec = [self.tranferModel.lockNumber decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"10000"]];
            if([self.tranferModel.lockNumber integerValue] == 0){
                cell_2.value.text = [NSString stringWithFormat:@"--\n\n--"];
            }else{
                cell_2.value.text = [NSString stringWithFormat:@"%.2f万区块\n\n%.1f%%",[lockDec doubleValue], self.tranferModel.lockRate];
            }
            return cell_2;
        }else if (indexPath.row == 3){
            cell_1.typeName.text = NSLocalizedString(@"transfer.blockNo.", @"区块号");
            cell_1.value.text = self.tranferModel.blockNumber;
            cell_1.rightBtnType = btnType_copy;
            cell_1.showRightBtn = YES;
            return cell_1;
        }else if (indexPath.row == 4){
            cell_1.typeName.text = NSLocalizedString(@"transfer.tradeTime", @"交易时间");
            cell_1.value.text = [NSDate timestampSwitchTime:self.tranferModel.timestamp/1000.0 formatter:@"yyyy-MM-dd HH:mm:ss"];
            cell_1.canCopy = NO;
            cell_1.showRightBtn = NO;
            return cell_1;
        }else if(indexPath.row == 5){
            cell_3.nameLabel.text = NSLocalizedString(@"transfer.tradeNo.", @"交易号");
            cell_3.rightView.hidden = NO;
            cell_3.infoLabel.text = [self.tranferModel.tradingHash add0xIfNeeded];
            return cell_3;
        }else if (indexPath.row == 6){
            cell_3.nameLabel.text = NSLocalizedString(@"transfer.note", @"备注");
            cell_3.rightView.hidden = YES;
            cell_3.infoLabel.text = self.tranferModel.input;
            return cell_3;
        }
    }else if(self.tranferModel.type == TxType_unMortgage){
        //抵押赎回
        if(indexPath.row == 0){
            cell_1.typeName.text = NSLocalizedString(@"transfer.sendMoney", @"发款账号");
            cell_1.value.text = self.tranferModel.from;
            cell_1.showRightBtn = YES;
            return cell_1;
        }else if (indexPath.row == 1){
            cell_1.typeName.text = NSLocalizedString(@"transfer.collectionMoney", @"收款账号");
            cell_1.value.text = @"--";
            cell_1.showRightBtn = YES;
            return cell_1;
        }else if (indexPath.row == 2){
            cell_1.typeName.text = NSLocalizedString(@"transfer.blockNo.", @"区块号");
            cell_1.value.text = self.tranferModel.blockHash;
            cell_1.showRightBtn = YES;
            return cell_1;
        }else if (indexPath.row == 3){
            cell_1.typeName.text = NSLocalizedString(@"transfer.tradeTime", @"交易时间");
            cell_1.value.text = [NSDate timestampSwitchTime:self.tranferModel.timestamp/1000.0 formatter:@"yyyy-MM-dd HH:mm:ss"];
            cell_1.canCopy = NO;
            cell_1.showRightBtn = NO;
            return cell_1;
        }else if(indexPath.row == 4){
            cell_3.nameLabel.text = NSLocalizedString(@"transfer.tradeNo.", @"交易号");
            cell_3.rightView.hidden = NO;
            cell_3.infoLabel.text = [self.tranferModel.tradingHash add0xIfNeeded];
            return cell_3;
        }else if (indexPath.row == 5){
            cell_3.nameLabel.text = NSLocalizedString(@"transfer.note", @"备注");
            cell_3.rightView.hidden = YES;
            cell_3.infoLabel.text = self.tranferModel.input;
            return cell_3;
        }
    }else if(self.tranferModel.type == TxType_vote || self.tranferModel.type == TxType_reResource){ //投票 || 领取资源
        if(indexPath.row == 0){
            cell_1.typeName.text = NSLocalizedString(@"vote.to", @"发起方");
            cell_1.value.text = self.tranferModel.from;
            cell_1.showRightBtn = NO;
            return cell_1;
        }else if(indexPath.row == 1){
            cell_1.typeName.text = NSLocalizedString(@"transfer.blockNo.", @"区块号");
            cell_1.value.text = self.tranferModel.blockNumber;
            cell_1.showRightBtn = YES;
            return cell_1;
        }else if (indexPath.row == 2){
            cell_1.typeName.text = NSLocalizedString(@"transfer.tradeTime", @"交易时间");
            cell_1.value.text = [NSDate timestampSwitchTime:self.tranferModel.timestamp/1000.0 formatter:@"yyyy-MM-dd HH:mm:ss"];
            cell_1.canCopy = NO;
            cell_1.showRightBtn = NO;
            return cell_1;
        }else if (indexPath.row == 3){
            cell_3.nameLabel.text = NSLocalizedString(@"transfer.tradeNo.", @"交易号");
            cell_3.rightView.hidden = NO;
            cell_3.infoLabel.text = [self.tranferModel.tradingHash add0xIfNeeded];
            return cell_3;
        }
    }else if(self.tranferModel.type == TxType_rewardVote || self.tranferModel.type == TxType_rewardLock){ //领取投票收益
        if(indexPath.row == 0){
            cell_1.typeName.text = NSLocalizedString(@"transfer.sendMoney", @"发款账号");
            cell_1.value.text = self.tranferModel.from;
            cell_1.showRightBtn = YES;
            return cell_1;
        }else if (indexPath.row == 1){
            cell_1.typeName.text = NSLocalizedString(@"transfer.collectionMoney", @"收款账号");
            cell_1.value.text = self.tranferModel.to;
            cell_1.showRightBtn = YES;
            return cell_1;
        }else if (indexPath.row == 2){
            cell_1.typeName.text = NSLocalizedString(@"transfer.blockNo.", @"区块号");
            cell_1.value.text = self.tranferModel.blockNumber;
            cell_1.showRightBtn = YES;
            return cell_1;
        }else if (indexPath.row == 3){
            cell_1.typeName.text = NSLocalizedString(@"transfer.tradeTime", @"交易时间");
            cell_1.value.text = [NSDate timestampSwitchTime:self.tranferModel.timestamp/1000.0 formatter:@"yyyy-MM-dd HH:mm:ss"];
            cell_1.canCopy = NO;
            cell_1.showRightBtn = NO;
            return cell_1;
        }else if (indexPath.row == 4){
            cell_3.nameLabel.text = NSLocalizedString(@"transfer.tradeNo.", @"交易号");
            cell_3.rightView.hidden = NO;
            cell_3.infoLabel.text = [self.tranferModel.tradingHash add0xIfNeeded];
            return cell_3;
        }else if (indexPath.row == 5){
            cell_3.nameLabel.text = NSLocalizedString(@"transfer.note", @"备注");
            cell_3.rightView.hidden = YES;
            cell_3.infoLabel.text = self.tranferModel.input;
            return cell_3;
        }
    }else if(self.tranferModel.type == TxType_updateNodeInfo){
        //更新节点
        if(indexPath.row == 0){
            cell_1.typeName.text = NSLocalizedString(@"vote.to", @"发起方");
            cell_1.value.text = self.tranferModel.from;
            cell_1.showRightBtn = YES;
            return cell_1;
        }else if (indexPath.row == 1){
            cell_1.typeName.text = NSLocalizedString(@"transfer.blockNo.", @"区块号");
            cell_1.value.text = self.tranferModel.blockNumber;
            cell_1.showRightBtn = YES;
            return cell_1;
        }else if (indexPath.row == 2){
            cell_1.typeName.text = NSLocalizedString(@"transfer.tradeTime", @"交易时间");
            cell_1.value.text = [NSDate timestampSwitchTime:self.tranferModel.timestamp/1000.0 formatter:@"yyyy-MM-dd HH:mm:ss"];
            cell_1.canCopy = NO;
            cell_1.showRightBtn = NO;
            return cell_1;
        }else if (indexPath.row == 3){
            cell_3.nameLabel.text = NSLocalizedString(@"transfer.tradeNo.", @"交易号");
            cell_3.rightView.hidden = NO;
            cell_3.infoLabel.text = [self.tranferModel.tradingHash add0xIfNeeded];
            return cell_3;
        }else if (indexPath.row == 4){
            cell_3.nameLabel.text = NSLocalizedString(@"transfer.note", @"备注");
            cell_3.rightView.hidden = YES;
            cell_3.infoLabel.text = self.tranferModel.input;
            return cell_3;
        }
    }else{
        if(indexPath.row == 0){
            cell_1.typeName.text = NSLocalizedString(@"transfer.sendMoney", @"发款账号");
            cell_1.value.text = self.tranferModel.from;
            cell_1.showRightBtn = YES;
            return cell_1;
        }else if (indexPath.row == 1){
            cell_1.typeName.text = NSLocalizedString(@"transfer.collectionMoney", @"收款账号");
            cell_1.value.text = self.tranferModel.to;
            cell_1.showRightBtn = YES;
            return cell_1;
        }else if (indexPath.row == 2){
            cell_2.typeName.text = NSLocalizedString(@"transfer.resource", @"资源消耗");
            cell_2.valueName.text = @"RES";
            cell_2.value.text = self.tranferModel.bindwith;
            return cell_2;
        }else if (indexPath.row == 3){
            cell_1.typeName.text = NSLocalizedString(@"transfer.blockNo.", @"区块号");
            cell_1.value.text = self.tranferModel.blockNumber;
            cell_1.showRightBtn = YES;
            return cell_1;
        }else if (indexPath.row == 4){
            cell_1.typeName.text = NSLocalizedString(@"transfer.tradeTime", @"交易时间");
            cell_1.value.text = [NSDate timestampSwitchTime:self.tranferModel.timestamp/1000.0 formatter:@"yyyy-MM-dd HH:mm:ss"];
            cell_1.canCopy = NO;
            cell_1.showRightBtn = NO;
            return cell_1;
        }else if (indexPath.row == 5){
            cell_3.nameLabel.text = NSLocalizedString(@"transfer.tradeNo.", @"交易号");
            cell_3.rightView.hidden = NO;
            cell_3.infoLabel.text = [self.tranferModel.tradingHash add0xIfNeeded];
            return cell_3;
        }else if (indexPath.row == 6){
            cell_3.nameLabel.text = NSLocalizedString(@"transfer.note", @"备注");
            cell_3.rightView.hidden = YES;
            cell_3.infoLabel.text = self.tranferModel.input;
            return cell_3;
        }
    }
    
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(self.tranferModel.type == TxType_vote){ //投票
        if(indexPath.row == 3){
            [self toDetail];
        }
    }else if(self.tranferModel.type == TxType_rewardVote || self.tranferModel.type == TxType_rewardLock){ //领取投票收益
        if(indexPath.row == 4){
            [self toDetail];
        }
    }else if(self.tranferModel.type == TxType_lock || self.tranferModel.type == TxType_moetgage){ //锁仓 //抵押
        if(indexPath.row == 5){
            [self toDetail];
        }
    }else if(self.tranferModel.type == TxType_reResource){ //领取资源
        if(indexPath.row == 3){
            [self toDetail];
        }
    }else if(self.tranferModel.type == TxType_transfer){ //交易
        if(indexPath.row == 5){
            [self toDetail];
        }
    }else if(self.tranferModel.type == TxType_updateNodeInfo){//修改节点
        if(indexPath.row == 3){
            [self toDetail];
        }
    }else if(self.tranferModel.type == TxType_unMortgage){ //抵押赎回
        if(indexPath.row == 4){
            [self toDetail];
        }
    }
}

-(void)toDetail{
    BasicWebViewController *webView = [[BasicWebViewController alloc] init];
    webView.urlStr = [NSString stringWithFormat:@"%@transactionHashMobile?transactionHash=%@",App_Delegate.webHost, [self.tranferModel.tradingHash add0xIfNeeded]];
    webView.navigationItem.title = NSLocalizedString(@"transfer.detail", @"交易详情");
    webView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webView animated:YES];
}

#pragma mark ----
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.bounces = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
