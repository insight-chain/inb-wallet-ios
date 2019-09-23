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

#import "NSDate+DateString.h"
#import "MJRefresh.h"

#import "FMListPlaceholder.h"
#import "UITableView+FMListPlaceholder.h"

#define cellId @"transferListCell"

@interface TransferListVC ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *recordArr;
@end

@implementation TransferListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, KHEIGHT) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    [self.view addSubview:self.tableView];
    
    [self.tableView.mj_header beginRefreshing];
    
    __weak __typeof(self)weakSelf = self;
    self.tableView.reloadBlock = ^(UIScrollView *listView) {
        [listView.mj_header beginRefreshing];
    };
    /// 使用场景 3
    // 自定义某个 列表的 占位图 文字 等等属性。根据需求自行调用相应接口。不想覆盖全局默认属性的参数传nil
    [self.tableView fm_emptyCoverName:@"record_trading_empty" emptyTips:NSLocalizedString(@"record.trading.empty", @"暂无交易历史")]; // emptyTips如果传 nil 则会显示全局默认文字。不要 emptyTips 传 空白字符 即可
    [self.tableView fm_backgroundColor:[UIColor whiteColor] tipsTextColor:kColorAuxiliary2 tipsFont:[UIFont systemFontOfSize:15]];
    [self.tableView fm_coverCenterYOffset:-80 coverSize:CGSizeMake(190, 150) coverSpaceToTips:20];
}

-(void)headerRefresh{
    [self performSelector:@selector(reloadTable) withObject:nil afterDelay:1];
}
-(void)reloadTable{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *url = [NSString stringWithFormat:@"%@account/search/transfers?address=%@&page=1&limit=200", appDelegate.explorerHost,self.address];
    __weak __block typeof(self) tmpSelf = self;
    [NetworkUtil getRequest:url params:@{} success:^(id  _Nonnull resonseObject) {
        
        NSDictionary *res = (NSDictionary *)resonseObject;
        
        NSInteger totalCount = res[@"totalCount"];
        NSInteger totalPages = res[@"totalPages"];
        NSArray *items = res[@"items"];
        
        NSMutableArray *tradingArr = [TransferModel mj_objectArrayWithKeyValuesArray:items];
        
        [tmpSelf.recordArr removeAllObjects];
        
        [tmpSelf.recordArr addObjectsFromArray:tradingArr];
        
        [tmpSelf.tableView.mj_header endRefreshing];
        [tmpSelf.tableView.mj_footer endRefreshingWithNoMoreData]; //没有更多数据
        [tmpSelf.tableView reloadData];
        return;
        
    } failed:^(NSError * _Nonnull error) {
        [self.recordArr removeAllObjects];
        [tmpSelf.tableView reloadData];
        [tmpSelf.tableView.mj_header endRefreshing];
    }];
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
    
    listCell.timeLabel.text = [NSDate timestampSwitchTime:[transfer.timestamp doubleValue]/1000.0 formatter:@"yyyy-MM-dd HH:mm"];
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
