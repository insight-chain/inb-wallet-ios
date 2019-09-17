//
//  VoteListVC.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/19.
//  Copyright © 2019 apple. All rights reserved.
//

#import "VoteListVC.h"
#import "VoteDetailVC.h"
#import "NodeInfoVC.h"

#import "Node.h"
#import "NetWorkUtil.h"

#import "VoteListCell.h"

#import "VoteBarView.h"

#import "FMListPlaceholder.h"
#import "UITableView+FMListPlaceholder.h"

#import "MJRefresh.h"

@interface VoteListVC ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) VoteBarView *voteBarView;

@property(nonatomic, strong) NSMutableArray<Node *> *selectedNodes;
@property(nonatomic, strong) NSMutableArray<Node *> *nodesList;

@end

#define cellId @"voteListCell"

#define voteBarViewHeight (iPhoneX ? AdaptedWidth(50)+20 : AdaptedWidth(50))

@implementation VoteListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.voteBarView];
    
//    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.mas_equalTo(0);
//        make.bottom.mas_equalTo(self.voteBarView.mas_top);
//    }];
//    [self.voteBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(0);
////        make.top.mas_equalTo(self.tableView.mas_bottom);
//        make.height.mas_equalTo(voteBarViewHeight);
//        make.bottom.mas_equalTo(self.view);
//    }];
    
    __block __weak typeof(self) tmpSelf = self;
    
    /** 导航栏返回按钮文字 **/
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];
    
    self.voteBarView.subVote = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            VoteDetailVC *detailVC = [[VoteDetailVC alloc] init];
            detailVC.wallet = tmpSelf.wallet;
            detailVC.selectedNode = tmpSelf.selectedNodes;
            detailVC.totalNodeCount = kMaxSeleceNodesNumber; //tmpSelf.nodesList.count;
            detailVC.navigationItem.title = NSLocalizedString(@"vote", @"投票");
            detailVC.hidesBottomBarWhenPushed = YES;
            [tmpSelf.navigationController pushViewController:detailVC animated:YES];
        });
    };
    self.voteBarView.deleteNode = ^(Node * _Nonnull node) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [tmpSelf.selectedNodes removeObject:node];
            [tmpSelf.tableView reloadData];
        });
    };
    
//    [self.nodesList addObjectsFromArray:[self nodesTest]];
    self.voteBarView.totalNodes = kMaxSeleceNodesNumber; //最大选则节点数
    

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestNodes)];
    [self.tableView.mj_header beginRefreshing];
    
    __weak __typeof(self)weakSelf = self;
    _tableView.reloadBlock = ^(UIScrollView *listView) {
        [listView.mj_header beginRefreshing];
    };
    
    /// 使用场景 3
    // 自定义某个 列表的 占位图 文字 等等属性。根据需求自行调用相应接口。不想覆盖全局默认属性的参数传nil
    [self.tableView fm_emptyCoverName:@"vote_node_empty" emptyTips:NSLocalizedString(@"vote.node.empty", @"暂无投票节点")]; // emptyTips如果传 nil 则会显示全局默认文字。不要 emptyTips 传 空白字符 即可
    [self.tableView fm_backgroundColor:[UIColor whiteColor] tipsTextColor:kColorAuxiliary2 tipsFont:[UIFont systemFontOfSize:15]];
    [self.tableView fm_coverCenterYOffset:-80 coverSize:CGSizeMake(190, 150) coverSpaceToTips:20];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    [self.voteBarView reloadNodes:self.selectedNodes];
}
-(NSArray *)nodesTest{
    NSMutableArray *arr = @[].mutableCopy;
    for (int i = 0; i<10; i++) {
        Node *node = [[Node alloc] init];
        node.voteRatio = arc4random() % 100 / 100.0;
        node.name = [self randomCreatChinese:4];
        node.intro = [self randomCreatChinese:20];
        node.address = [self generateTradeNO];
        [arr addObject:node];
    }
    return (NSArray *)arr;
}

-(void)requestNodes{
    __block __weak typeof(self) tmpSelf = self;
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSString *url = [NSString stringWithFormat:@"%@node/info?page=1&limit=200", delegate.explorerHost];
    [NetworkUtil getRequest:url params:@{} success:^(id  _Nonnull resonseObject) {
        NSLog(@"%@", resonseObject);
        NSDictionary *result = (NSDictionary *)resonseObject;
        NSInteger totalCount = [result[@"totalCount"] integerValue];
        NSInteger totalPages = [result[@"totalPages"] integerValue];
        NSArray *items = result[@"items"];
        NSArray *nodesArr = [Node mj_objectArrayWithKeyValuesArray:items];
        [tmpSelf.nodesList removeAllObjects];
        [tmpSelf.nodesList addObjectsFromArray:nodesArr];
        [tmpSelf.tableView.mj_header endRefreshing];
        [tmpSelf.tableView.mj_footer endRefreshing];
        [tmpSelf.tableView reloadData];
    } failed:^(NSError * _Nonnull error) {
        [tmpSelf.nodesList removeAllObjects];
        [tmpSelf.tableView reloadData];
        NSLog(@"%@", error);
        
        [tmpSelf.tableView.mj_header endRefreshing];
        [tmpSelf.tableView.mj_footer endRefreshing];
    }];
//    __block __weak typeof(self) tmpSelf = self;
//    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [NetworkUtil  rpc_requetWithURL:delegate.rpcHost
//                             params:@{@"jsonrpc":@"2.0",
//                                      @"method":@"eth_getCandidateNodesInfo",
//                                      @"params":@[],
//                                      @"id":@(67)
//                                      }
//                         completion:^(id  _Nullable responseObject, NSError * _Nullable error) {
//                             if (error) {
//                                 NSLog(@"%@", error);
//                             }
//                             NSArray *nodes = responseObject[@"result"];
//                             if (nodes) {
//                                 NSArray *nodesArr = [Node mj_objectArrayWithKeyValuesArray:nodes];
//
//                                 dispatch_async(dispatch_get_main_queue(), ^{
//                                     [tmpSelf.nodesList addObjectsFromArray:nodesArr];
//                                     tmpSelf.voteBarView.totalNodes = tmpSelf.nodesList.count;
//                                     [tmpSelf.tableView reloadData];
//                                 });
//                             }
//                         }];
}

- (NSMutableString*)randomCreatChinese:(NSInteger)count{
    NSMutableString*randomChineseString =@"".mutableCopy;
    for(NSInteger i =0; i < count; i++){
        NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        //随机生成汉字高位
        NSInteger randomH =0xA1+arc4random()%(0xFE - 0xA1+1);
        //随机生成汉子低位
        NSInteger randomL =0xB0+arc4random()%(0xF7 - 0xB0+1);
        //组合生成随机汉字
        NSInteger number = (randomH<<8)+randomL;
        NSData *data = [NSData dataWithBytes:&number length:2];
        NSString*string = [[NSString alloc]initWithData:data encoding:gbkEncoding];
        [randomChineseString appendString:string];
    }
    return randomChineseString;
}
//产生随机字符串
- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTabcdefghijklmnopqrstuvwxyz";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}
    




#pragma mark ---- UITableViewDelegate && DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.nodesList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VoteListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([VoteListCell class]) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellId];
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    }
    Node *node = self.nodesList[indexPath.row];
    cell.node = node;
    __block __weak typeof(self) tmpSelf = self;
    cell.voteBlock = ^(Node * _Nonnull node) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(node.isVoted){
                if (tmpSelf.selectedNodes.count > kMaxSeleceNodesNumber) {
                    [MBProgressHUD showMessage:@"选择的节点数目已达到最大" toView:tmpSelf.view afterDelay:0.3 animted:YES];
                    node.isVoted = NO;
                    return ;
                }
                [tmpSelf.voteBarView addNode:node];
                [tmpSelf.selectedNodes addObject:node];
            }else{
                [tmpSelf.voteBarView deleteNode:node];
                [tmpSelf.selectedNodes removeObject:node];
            }
        });
    };
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Node *node = self.nodesList[indexPath.row];
    
    NodeInfoVC *nodeInfo = [[NodeInfoVC alloc] init];
    nodeInfo.node = node;
    nodeInfo.selectedNodes = self.selectedNodes;
    nodeInfo.totalNode = kMaxSeleceNodesNumber; //self.nodesList.count;
    
    [self.navigationController pushViewController:nodeInfo animated:YES];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, 2)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 2;
}
#pragma mark ---- setter && getter
-(UITableView *)tableView{
    if (_tableView == nil ) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, KHEIGHT - voteBarViewHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}
-(VoteBarView *)voteBarView{
    if (_voteBarView == nil) {
        _voteBarView = [[VoteBarView alloc] initWithFrame:CGRectMake(0, (KHEIGHT-voteBarViewHeight), KWIDTH, voteBarViewHeight)];
        
    }
    return _voteBarView;
}

-(NSMutableArray<Node *> *)nodesList{
    if (_nodesList == nil) {
        _nodesList = [NSMutableArray array];
    }
    return _nodesList;
}
-(NSMutableArray<Node *> *)selectedNodes{
    if (_selectedNodes == nil) {
        _selectedNodes = @[].mutableCopy;
    }
    return _selectedNodes;
}
@end
