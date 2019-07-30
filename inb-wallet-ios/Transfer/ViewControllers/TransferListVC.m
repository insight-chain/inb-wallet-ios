//
//  TransferListVC.m
//  test
//
//  Created by insightChain_iOS开发 on 2019/6/12.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "TransferListVC.h"
#import "TransactionDetailVC.h"

#import "TransferListCell.h"

#import "TransferModel.h"
#import "NetworkUtil.h"

#import "MJRefresh.h"

#define cellId @"transferListCell"

@interface TransferListVC ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *recordArr;
@end

@implementation TransferListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

        NSString *url = [NSString stringWithFormat:@"http://192.168.1.191:8383/v1/account/search/transfers?address=%@&page=1&limit=200", self.address];
//        NSString *url = [NSString stringWithFormat:@"%@account/search/transfers?address=%@&page=1&limit=200", appDelegate.explorerHost, self.address];
        [NetworkUtil getRequest:url params:@{} success:^(id  _Nonnull resonseObject) {
            
            NSDictionary *res = (NSDictionary *)resonseObject;
            
            NSInteger totalCount = res[@"totalCount"];
            NSInteger totalPages = res[@"totalPages"];
            NSArray *items = res[@"items"];
            
            NSMutableArray *tradingArr = [TransferModel mj_objectArrayWithKeyValuesArray:items];
            
            [self.recordArr removeAllObjects];
            
            [self.recordArr addObjectsFromArray:tradingArr];
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData]; //没有更多数据
            [self.tableView reloadData];
            return;
            
        } failed:^(NSError * _Nonnull error) {
            [self.tableView.mj_header endRefreshing];
        }];
    }];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark ---- UITableViewDatasource & Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.recordArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TransferListCell *listCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (listCell == nil) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([TransferListCell class]) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellId];
        listCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    }
    
    TransferModel *transfer = self.recordArr[indexPath.row];
    
    if(transfer.type == tradingType_transfer && transfer.direction == 2){
        //转入
        listCell.addressLabel.text = transfer.from;
        listCell.typeLabel.text = @" 收款 ";
        listCell.typeLabel.layer.borderColor = kColorBlue.CGColor;
        listCell.typeLabel.layer.cornerRadius = 3;
        listCell.typeLabel.layer.borderWidth = 1;
        listCell.valueLabel.text = [NSString stringWithFormat:@"+ %.4f INB", transfer.amount];
        
    }else if(transfer.type == tradingType_transfer && transfer.direction == 1){
        //转出
        listCell.addressLabel.text = transfer.to;
        listCell.typeLabel.text = @" 转账 ";
        listCell.typeLabel.layer.borderColor = kColorBlue.CGColor;
        listCell.typeLabel.layer.cornerRadius = 3;
        listCell.typeLabel.layer.borderWidth = 1;
        listCell.valueLabel.text = [NSString stringWithFormat:@"- %.4f INB", transfer.amount];
    }else if(transfer.type == tradingType_vote){
        //投票
        listCell.addressLabel.text = transfer.to;
        listCell.typeLabel.text = @" 投票 ";
        listCell.typeLabel.layer.borderColor = kColorBlue.CGColor;
        listCell.typeLabel.layer.cornerRadius = 3;
        listCell.typeLabel.layer.borderWidth = 1;
        listCell.valueLabel.text = [NSString stringWithFormat:@"- %.4f INB", transfer.amount];
    }else if(transfer.type == tradingType_mortgage){
        listCell.addressLabel.text = transfer.to;
        listCell.typeLabel.text = @" 抵押 ";
        listCell.typeLabel.layer.borderColor = kColorBlue.CGColor;
        listCell.typeLabel.layer.cornerRadius = 3;
        listCell.typeLabel.layer.borderWidth = 1;
        listCell.valueLabel.text = [NSString stringWithFormat:@"- %.4f INB", transfer.amount];
    }else if(transfer.type == tradingType_unMortgage){
        listCell.addressLabel.text = transfer.to;
        listCell.typeLabel.text = @" 赎回 ";
        listCell.typeLabel.layer.borderColor = kColorBlue.CGColor;
        listCell.typeLabel.layer.cornerRadius = 3;
        listCell.typeLabel.layer.borderWidth = 1;
        listCell.valueLabel.text = [NSString stringWithFormat:@"+ %.4f INB", transfer.amount];
    }
    
    listCell.timeLabel.text = transfer.timestamp;
    listCell.infoLabel.text = transfer.input;
    
    return listCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    TransferModel *model = (TransferModel *)self.recordArr[indexPath.row];
    TransactionDetailVC *detailVC = [[TransactionDetailVC alloc] init];
    detailVC.tranferModel = model;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark ----
-(NSMutableArray *)recordArr{
    if (_recordArr == nil) {
        _recordArr = @[].mutableCopy;
    }
    return _recordArr;
}
-(void)setAddress:(NSString *)address{
    if ([address hasPrefix:@"0x"]) {
        _address = address;
    }else{
        _address = [NSString stringWithFormat:@"0x%@", address];
    }
}
@end
