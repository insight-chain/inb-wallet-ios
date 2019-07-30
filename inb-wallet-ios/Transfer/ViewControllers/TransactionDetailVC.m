//
//  TransactionDetailVC.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/18.
//  Copyright © 2019 apple. All rights reserved.
//

#import "TransactionDetailVC.h"

#import "TransferHeaderView.h"
#import "TransferFooterView.h"

#import "TransferMessageCell.h"
#import "TransferMessage_2Cell.h"

#define cellId_1 @"messageType_1"
#define cellId_2 @"messageType_2"

@interface TransactionDetailVC ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) TransferFooterView *tableFooter;
@property(nonatomic, strong) TransferHeaderView *tableHeader;
@end

@implementation TransactionDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.tableFooter = [[TransferFooterView alloc] init];
    self.tableFooter.frame = CGRectMake(0, 0, KWIDTH, AdaptedWidth(202));
    self.tableView.tableFooterView = self.tableFooter;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.mas_equalTo(0);
    }];
    
    self.tableFooter.info = self.tranferModel.input;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, AdaptedWidth(183))];
    self.tableHeader = [[TransferHeaderView alloc] init];
    [tableHeaderView addSubview:self.tableHeader];
    [self.tableHeader mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(0);
    }];
    self.tableView.tableHeaderView = tableHeaderView;
    
    if (self.tranferModel.type == tradingType_transfer) {
        self.tableHeader.resultLabel.text = NSLocalizedString(@"transfer.success", @"转账成功");
        if (self.tranferModel.direction == 1) { //付款
            self.tableHeader.valueLabel.text = [NSString stringWithFormat:@"-%.4f INB", self.tranferModel.amount];
        }else{
            //收款
            self.tableHeader.valueLabel.text = [NSString stringWithFormat:@"+%.4f INB", self.tranferModel.amount];
        }
    }else if (self.tranferModel.type == tradingType_mortgage || self.tranferModel.type == tradingType_unMortgage){
        self.tableHeader.resultLabel.text = [NSString stringWithFormat:@"%@NET", NSLocalizedString(@"mortgage", @"抵押")];
        if(self.tranferModel.type == tradingType_mortgage){
            self.tableHeader.valueLabel.text = [NSString stringWithFormat:@"-%.4f INB", self.tranferModel.amount];
        }else{
            self.tableHeader.valueLabel.text = [NSString stringWithFormat:@"+%.4f INB", self.tranferModel.amount];
        }
    }else if(self.tranferModel.type == tradingType_vote){
        self.tableHeader.resultLabel.text = [NSString stringWithFormat:@"%@NET", NSLocalizedString(@"transfer.vote", @"节点投票")];
        self.tableHeader.valueLabel.text = self.tranferModel.input;
        self.tableHeader.valueLabel.textColor = kColorAuxiliary2;
        self.tableHeader.valueLabel.backgroundColor = kColorBackground;
        self.tableHeader.valueLabel.layer.borderWidth = 1;
        self.tableHeader.valueLabel.layer.borderColor = kColorSeparate.CGColor;
        self.tableHeader.valueLabel.numberOfLines = 0;
        
    }
    
    [self.tableHeader layoutIfNeeded];
    CGRect rect = tableHeaderView.frame;
    rect.size.height = self.tableHeader.frame.size.height;
    tableHeaderView.frame = rect;
    
    
}

#pragma mark ---- UITableViewDelegate && DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.tranferModel.type == tradingType_vote){
        return 5;
    }else{
        return 6;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TransferMessageCell *cell_1 = [tableView dequeueReusableCellWithIdentifier:cellId_1];
    if (cell_1 == nil) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([TransferMessageCell class]) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellId_1];
        cell_1 = [tableView dequeueReusableCellWithIdentifier:cellId_1];
    }
    
    TransferMessage_2Cell *cell_2 = [tableView dequeueReusableCellWithIdentifier:cellId_2];
    if (cell_2 == nil) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([TransferMessage_2Cell class]) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellId_2];
        cell_2 = [tableView dequeueReusableCellWithIdentifier:cellId_2];
    }
    if(indexPath.row == 0){
        cell_1.typeName.text = NSLocalizedString(@"transfer.sendMoney", @"发款方");
        cell_1.value.text = self.tranferModel.from;
        cell_1.showRightBtn = YES;
        return cell_1;
    }else if (indexPath.row == 1){
        cell_1.typeName.text = NSLocalizedString(@"transfer.collectionMoney", @"发款方");
        cell_1.value.text = self.tranferModel.to;
        cell_1.showRightBtn = YES;
        return cell_1;
    }else if (indexPath.row == 2){
        if(self.tranferModel.type == tradingType_vote){
            cell_1.typeName.text = NSLocalizedString(@"transfer.blockNo.", @"区块号");
            cell_1.value.text = self.tranferModel.blockHash;
            cell_1.showRightBtn = YES;
            return cell_1;
        }else{
            if(self.tranferModel.type == tradingType_transfer){
                cell_2.typeName.text = NSLocalizedString(@"transfer.resource", @"资源消耗");
                cell_2.valueName.text = @"NET";
                cell_2.value.text = self.tranferModel.bindwith;
            }else if(self.tranferModel.type == tradingType_mortgage || self.tranferModel.type == tradingType_unMortgage){ //抵押
                cell_2.typeName.text = @"抵押详情"; //NSLocalizedString(@"transfer.resource", @"资源消耗");
                cell_2.valueName.text = @"NET(bytes)";
                cell_2.value.text = self.tranferModel.bindwith;
            }
            return cell_2;
        }
    }else if (indexPath.row == 3){
        if(self.tranferModel.type == tradingType_vote){
            cell_1.typeName.text = NSLocalizedString(@"transfer.tradeTime", @"交易时间");
            cell_1.value.text = self.tranferModel.timestamp;
            cell_1.showRightBtn = NO;
            return cell_1;
        }else{
            cell_1.typeName.text = NSLocalizedString(@"transfer.blockNo.", @"区块号");
            cell_1.value.text = self.tranferModel.blockHash;
            cell_1.showRightBtn = YES;
            return cell_1;
        }
    }else if (indexPath.row == 4){
        if(self.tranferModel.type == tradingType_vote){
            cell_1.typeName.text = NSLocalizedString(@"transfer.tradeNo.", @"交易号");
            cell_1.value.text = @"交易查询";
            cell_1.rightBtnType = 2;
            cell_1.showRightBtn = YES;
            cell_1.showSeperatorView = NO;
            return cell_1;
        }else{
            cell_1.typeName.text = NSLocalizedString(@"transfer.tradeTime", @"交易时间");
            cell_1.value.text = self.tranferModel.timestamp;
            cell_1.showRightBtn = NO;
            return cell_1;
        }
    }else if (indexPath.row == 5){
        cell_1.typeName.text = NSLocalizedString(@"transfer.tradeNo.", @"交易号");
        cell_1.value.text = @"交易查询";
        cell_1.rightBtnType = 2;
        cell_1.showRightBtn = YES;
        cell_1.showSeperatorView = NO;
        return cell_1;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
