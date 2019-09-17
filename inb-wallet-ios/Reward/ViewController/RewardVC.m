//
//  RewardVC.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/9/10.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "RewardVC.h"

#import "RewardRecordVC.h"

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

@end

@implementation RewardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeNavigation];
     
    self.tableView.tableHeaderView = self.tableHeaderView;
    
    if(1){ //参与过投票
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
    
    [self request];
    
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
        double mortgagete = [resonseObject[@"mortgagte"] doubleValue]; //抵押的INB
        double regular = [resonseObject[@"regular"] doubleValue]; //锁仓的INB
        NSArray *storeDTO = resonseObject[@"storeDTO"]; //锁仓
        
        NSMutableArray *arr = [LockModel mj_objectArrayWithKeyValuesArray:storeDTO];
        
        double mor = mortgagete - regular;
        if ( mor > 0) {
            LockModel *morM = [[LockModel alloc] init];
            morM.amount = [NSString stringWithFormat:@"%f", mor];
            morM.days = 0;
            morM.address = App_Delegate.selectAddr;
            [arr addObject:morM];
        }
        
        tmpSelf.stores = arr;
        
        /** 赎回中 **/
        double redeemValue = [resonseObject[@"redeemValue"] doubleValue]; //赎回中的INB
        double redeemTime = [resonseObject[@"redeemTime"] doubleValue];//赎回开始时间
        
        
        [tmpSelf.tableView reloadData];
        
    } failed:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}


#pragma mark ---- UITableViewDelegate && Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RedeemCell_2 *cell = [tableView dequeueReusableCellWithIdentifier:cellId_2];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([RedeemCell_2 class]) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellId_2];
        cell = [tableView dequeueReusableCellWithIdentifier:cellId_2];
    }
    
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
#pragma mark ---- Button Action
//领取奖励
- (IBAction)rewardAction:(UIButton *)sender {
}
//去投票
- (IBAction)goVoteAction:(UIButton *)sender {
}

//查看领取记录
-(void)toRecordAction:(UIButton *)sender{
    RewardRecordVC *recordVC = [[RewardRecordVC alloc] init];
    recordVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:recordVC animated:YES];
    
}
@end
