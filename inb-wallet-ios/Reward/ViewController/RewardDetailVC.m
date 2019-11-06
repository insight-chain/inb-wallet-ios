//
//  RewardDetailVC.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/9/19.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "RewardDetailVC.h"

#import "TransferMessageCell.h"
#import "TransferMessage_2Cell.h"
#import "TransferMessage_3Cell.h"

#define cellId_1 @"messageType_1"
#define cellId_2 @"messageType_2"
#define cellId_3 @"messageType_3"

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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    InlineTransfer *tr = self.tranferModel.transactionLog[0];
    self.headerValueLabel.text = [NSString stringWithFormat:@"%@ INB", [NSString changeNumberFormatter:[NSString stringWithFormat:@"%f", ((InlineTransfer *)self.tranferModel.transactionLog[0]).amount]]];
    
    if (self.tranferModel.type == TxType_rewardLock) {
        self.headerTitleLabel.text = NSLocalizedString(@"transfer.reward.lock", @"锁仓收益");
    }else{
        self.headerTitleLabel.text = NSLocalizedString(@"transfer.reward.vote", @"投票收益");
    }
}
-(void)setTranferModel:(TransferModel *)tranferModel{
    _tranferModel = tranferModel;
    self.headerValueLabel.text = [NSString stringWithFormat:@"%@ INB", [NSString changeNumberFormatter:[NSString stringWithFormat:@"%f", self.tranferModel.amount]]];
    
    if (tranferModel.type == TxType_rewardLock) {
        self.headerTitleLabel.text = NSLocalizedString(@"transfer.reward.lock", @"锁仓收益");
    }else{
        self.headerTitleLabel.text = NSLocalizedString(@"transfer.reward.vote", @"投票收益");
    }
   
   
}
#pragma mark ---- UITableViewDelegate && Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
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
    return nil;
}

@end
