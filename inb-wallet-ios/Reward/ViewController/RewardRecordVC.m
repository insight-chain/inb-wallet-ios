//
//  RewardRecordVC.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/9/11.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "RewardRecordVC.h"

#import "RewardRecordCell.h"

#import "RewardDetailVC.h"

#import "NetworkUtil.h"

#import "TransferModel.h"

#import "MJRefresh.h"
#import "LYEmptyViewHeader.h"

static NSString *kCellId = @"rewardRecordCell";

@interface RewardRecordVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<TransferModel *> *recordsData;

@property (nonatomic, strong) LYEmptyView *noDataView;
@property (nonatomic, strong) LYEmptyView *noNetworkView;

@end

@implementation RewardRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestRecord];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.tableView ly_startLoading];
        [self requestRecord];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    self.tableView.ly_emptyView = self.noDataView;
}

-(void)requestRecord{
    __block __weak typeof(self) tmpSelf = self;
    
    NSString *url = [NSString stringWithFormat:@"%@transaction/award?address=%@", App_Delegate.explorerHost, [App_Delegate.selectAddr add0xIfNeeded]];
    [NetworkUtil getRequest:url params:@{}
                    success:^(id  _Nonnull resonseObject) {
                        
                        [self.tableView.mj_header endRefreshing];
                        [self.tableView.mj_footer endRefreshing];
   
                        NSInteger totalPage = [resonseObject[@"totalPages"] integerValue];
                        NSInteger totalCount = [resonseObject[@"totalCount"] integerValue];
                        NSArray *items = resonseObject[@"items"];
                        
                        tmpSelf.recordsData = [TransferModel mj_objectArrayWithKeyValuesArray:items];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.tableView reloadData];
                            [self.tableView ly_endLoading];
                        });
                    } failed:^(NSError * _Nonnull error) {
                        
                        [self.tableView ly_endLoading];
                        [self.tableView.mj_header endRefreshing];
                        [self.tableView.mj_footer endRefreshing];
                        
                        NSLog(@"%@", error);
                    }];
}


#pragma mark ---- UITableViewDelegate && Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.recordsData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RewardRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:@"RewardRecordCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:kCellId];
        cell = [tableView dequeueReusableCellWithIdentifier:kCellId];
    }
    TransferModel *model = self.recordsData[indexPath.row];
    cell.model = model;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TransferModel *model = self.recordsData[indexPath.row];
    RewardDetailVC *rewardVC = [[RewardDetailVC alloc] init];
    rewardVC.model = model;
    rewardVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:rewardVC animated:YES];
}
#pragma mark ----

-(LYEmptyView *)noDataView{
    if (_noDataView == nil) {
        _noDataView = [LYEmptyView emptyActionViewWithImage:[UIImage imageNamed:@""] titleStr:@"暂无数据" detailStr:@"" btnTitleStr:@"重新加载" btnClickBlock:^{
            
        }];
    }
    return _noDataView;
}

-(LYEmptyView *)noNetworkView{
    if (_noDataView == nil) {
        _noDataView = [LYEmptyView emptyActionViewWithImage:[UIImage imageNamed:@""] titleStr:@"网络请求出错" detailStr:@"" btnTitleStr:@"重试" btnClickBlock:^{
            
        }];
    }
    return _noDataView;
}
-(NSMutableArray<TransferModel *> *)recordsData{
    if(_recordsData == nil){
        _recordsData = @[].mutableCopy;
    }
    return _recordsData;
}
@end
