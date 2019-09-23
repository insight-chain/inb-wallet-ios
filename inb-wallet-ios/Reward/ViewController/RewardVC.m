//
//  RewardVC.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/9/10.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "RewardVC.h"

#import "VoteListVC.h"
#import "RewardRecordVC.h"
#import "MortgageDetailVC.h"

#import "RedeemCell_2.h"

#import "LockModel.h"
#import "NetworkUtil.h"

static NSString *cellId_2 = @"redeemCell_2";

@interface RewardVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UIImageView *headerBg;
@property (weak, nonatomic) IBOutlet UILabel *voteRewardValue;
@property (weak, nonatomic) IBOutlet UILabel *voteNumber;
@property (weak, nonatomic) IBOutlet UIButton *voteRewardBtn;
@property (weak, nonatomic) IBOutlet UILabel *vote_no_tip;
@property (weak, nonatomic) IBOutlet UIButton *goVoteBtn;

@property (nonatomic, strong) NSArray *stores; //抵押数据
@property (nonatomic, assign) NSInteger voteNumberValue; //投票数量
@property (nonatomic, assign) NSInteger lastReceiveVoteAwardHeight; //上次领取投票时块高度
@property (nonatomic, assign) double lastReceiveVoteAwardTime;//上次领取投票奖励的时间
@property (nonatomic, assign) NSInteger currentBlockNumber;//当前最新块高度
@end

@implementation RewardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeNavigation];
     
    self.tableView.tableHeaderView = self.tableHeaderView;
    
    
    
    [self requestBlockHeight];
    [self request];
    
    
    if(self.voteNumberValue > 0){ //参与过投票
        self.headerBg.image = [UIImage imageNamed:@"reward_vote_bg"];
        self.vote_no_tip.hidden = YES;
        self.goVoteBtn.hidden = YES;
        self.voteRewardValue.hidden = NO;
        self.voteNumber.hidden = NO;
        self.voteRewardBtn.hidden = NO;
    }else{
        self.headerBg.image = [UIImage imageNamed:@"reward_vote_no_bg"];
        self.vote_no_tip.hidden = NO;
        self.goVoteBtn.hidden = NO;
        self.voteRewardValue.hidden = YES;
        self.voteNumber.hidden = YES;
        self.voteRewardBtn.hidden = YES;
    }
    
    
    
}

-(void)makeNavigation{
    UIButton *rightBtn = [[UIButton alloc] init];
    [rightBtn setTitle:NSLocalizedString(@"reward.receive", @"领取奖励") forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(toRecordAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
}

-(void)request{
    __block __weak typeof(self) tmpSelf = self;
    
    NSString *url = [NSString stringWithFormat:@"%@account/search?address=%@", App_Delegate.explorerHost, [App_Delegate.selectAddr add0xIfNeeded]];
    [NetworkUtil getRequest:url params:@{} success:^(id  _Nonnull resonseObject) {
        NSLog(@"%@", resonseObject);
        double mortgagete = [resonseObject[@"mortgage"] doubleValue]; //抵押的INB
        double regular = [resonseObject[@"regular"] doubleValue]; //锁仓的INB
        NSArray *storeDTO = resonseObject[@"storeDTO"]; //锁仓
        
        NSMutableArray *arr = [LockModel mj_objectArrayWithKeyValuesArray:storeDTO];
        
        double mor = mortgagete - regular;
        if ( mor > 0) {
            LockModel *morM = [[LockModel alloc] init];
            morM.amount = [NSString stringWithFormat:@"%f", mor];
            morM.lockHeight = 0;
            morM.address = App_Delegate.selectAddr;
            [arr addObject:morM];
        }
        
        tmpSelf.stores = arr;
        
        /** 赎回中 **/
//        double redeemValue = [resonseObject[@"redeemValue"] doubleValue]; //赎回中的INB
//        NSInteger redeemTime = [resonseObject[@"redeemStartHeight"] doubleValue];//赎回开始时间
        
        /** 投票数量 **/
//        tmpSelf.lastReceiveVoteAwardTime = [resonseObject[@"lastReceiveVoteAwardTime"] doubleValue]/1000;
        tmpSelf.lastReceiveVoteAwardHeight = [resonseObject[@"lastReceiveVoteAwardHeight"] integerValue];
        tmpSelf.voteNumberValue = [resonseObject[@"voteNumber"] integerValue];
        
        [tmpSelf.tableView reloadData];
        
    } failed:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
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
//领取投票奖励

#pragma mark ---- UITableViewDelegate && Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.stores.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RedeemCell_2 *cell = [tableView dequeueReusableCellWithIdentifier:cellId_2];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([RedeemCell_2 class]) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellId_2];
        cell = [tableView dequeueReusableCellWithIdentifier:cellId_2];
    }
    LockModel *model = self.stores[indexPath.row];
    cell.model = model;
    cell.currentBlockNumber = self.currentBlockNumber;
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, 35)];
    view.backgroundColor = kColorBackground;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 100, 15)];
    label.text = @"抵押列表";
    label.textColor = kColorTitle;
    label.font = [UIFont systemFontOfSize:15];
    [view addSubview:label];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35.0;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 10)];
    view.backgroundColor = kColorBackground;
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LockModel *model = self.stores[indexPath.row];
    
    MortgageDetailVC *detailVC = [[MortgageDetailVC alloc] initWithNibName:@"MortgageDetailVC" bundle:nil];
    detailVC.lockModel = model;
    [self.navigationController pushViewController:detailVC animated:NO];
}
#pragma mark ---- Button Action
//领取奖励
- (IBAction)rewardAction:(UIButton *)sender {
}
//去投票
- (IBAction)goVoteAction:(UIButton *)sender {
    VoteListVC *listVC = [[VoteListVC alloc] init];
    listVC.wallet = self.wallet;
    listVC.navigationItem.title = NSLocalizedString(@"vote", @"投票");
    listVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:listVC animated:YES];
}

//查看领取记录
-(void)toRecordAction:(UIButton *)sender{
    RewardRecordVC *recordVC = [[RewardRecordVC alloc] init];
    recordVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:recordVC animated:YES];
    
}

#pragma mark ---- setter && getter
-(void)setVoteNumberValue:(NSInteger)voteNumberValue{
    _voteNumberValue = voteNumberValue;
    if(_voteNumberValue > 0){ //参与过投票
        self.headerBg.image = [UIImage imageNamed:@"reward_vote_bg"];
        self.vote_no_tip.hidden = YES;
        self.goVoteBtn.hidden = YES;
        self.voteRewardValue.hidden = NO;
        self.voteNumber.hidden = NO;
        self.voteRewardBtn.hidden = NO;
    }else{
        self.headerBg.image = [UIImage imageNamed:@"reward_vote_no_bg"];
        self.vote_no_tip.hidden = NO;
        self.goVoteBtn.hidden = NO;
        self.voteRewardValue.hidden = YES;
        self.voteNumber.hidden = YES;
        self.voteRewardBtn.hidden = YES;
    }
    
    [self calulateReward:self.lastReceiveVoteAwardHeight voteNumber:_voteNumberValue/100000.0];
    self.voteNumber.text = [NSString stringWithFormat:@"已投票数量 %.2f", _voteNumberValue/100000.0];
}

-(void)calulateReward:(NSInteger)startBlockNumber voteNumber:(double)voteNumber{
//    前提：（当前区块高度-上次领投票奖励区块高度）/每天产生区块数>=7
//    本次领取奖励=（当前区块高度-上次领投票奖励区块高度）/每天产生区块数（24*60*60/2）*年化（9%）/365*已投票数
    
    NSInteger perDayBlock = 24*60*60/2; //每天产生的去块数
    double difDay = (self.currentBlockNumber - startBlockNumber) / (perDayBlock*1.0);
    
    double reward = difDay * 0.09 / 365 *voteNumber;
    
    self.voteRewardValue.text = [NSString stringWithFormat:@"%.5f INB", reward];
    
    if (difDay >= 7) {
        //可以领取
        [self.voteRewardBtn setTitle:[NSString stringWithFormat:@"领取奖励"] forState:UIControlStateNormal];
        self.voteRewardBtn.userInteractionEnabled = YES;
    }else{
        NSInteger day = floor(difDay);
        [self.voteRewardBtn setTitle:[NSString stringWithFormat:@"%d天后领取", 7-day] forState:UIControlStateNormal];
        self.voteRewardBtn.userInteractionEnabled = NO;
    }
    

}

@end
