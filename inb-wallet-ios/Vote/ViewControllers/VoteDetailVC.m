//
//  VoteDetailVC.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/23.
//  Copyright © 2019 apple. All rights reserved.
//

#import "VoteDetailVC.h"
#import "VoteDetailHeaderView.h"
#import "VoteDetailCell.h"

#import "NetworkUtil.h"

#import "TransactionSignedResult.h"
#import "WalletManager.h"
#import "Node.h"

#import "PasswordInputView.h"

#define cellId @"VoteDetailCell"

@interface VoteDetailVC ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) VoteDetailHeaderView *headerView;

@property(nonatomic, strong) UILabel *sectionHeaderView; //”已选节点 “

@property(nonatomic, strong) UITableView *selectedNodesList; //以选节点
@property(nonatomic, strong) UIButton *voteButton; //提交投票

@end

@implementation VoteDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"transfer.typeName.vote", @"节点投票");
    /**
     *   表示本viewController中的ScrollView使用哪些新特性中提供的contentInsets.
     * 我们使用None.默认为All，也就是所有的方向都使用。
     */
//    self.edgesForExtendedLayout = UIRectEdgeAll;
    /**
     *  表示这种自适应的contentInsets是否包括statusBar的高度。这是一条比较关键的代码。
     *  我们的tableView之所以会向上滚动20像素就是因为当我们隐藏了statusBar之后scrollView认为没有了状态栏，
     *  那么它的contentInsets.top自动减小20px.
     */
//    self.extendedLayoutIncludesOpaqueBars = YES;
    /**
     *  表示在本viewController的view.subviews中的子view是否要受到系统的自动适配。
     *  比如在这里如果设为YES（默认也是），那么这个tableView.contentInsets.top就会为64.
     *  这里我们置为No,就不会又这个自动的调整了。
     */
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //解决导航栏不遮挡View
     if (@available(iOS 11.0, *)) {
        self.selectedNodesList.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
            
    }
    
    self.headerView = [[VoteDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, 100)];
    self.selectedNodesList.tableHeaderView = self.headerView;
    self.selectedNodesList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.headerView.balanceINB = self.wallet.balanceINB;
    self.headerView.mortgageINB = self.wallet.mortgagedINB;
    self.headerView.voteTotalValue.text = [NSString stringWithFormat:@"%.0f", self.wallet.mortgagedINB*self.selectedNode.count];
    __block __weak typeof(self) tmpSelf = self;
    self.headerView.addMortgageBlock = ^(double inbNumber) {
        if (inbNumber != 0) {
            //抵押
            [tmpSelf mortgage:inbNumber];
        }
    };
    [self.view addSubview:self.selectedNodesList];
    [self.view addSubview:self.voteButton];
    
    [self makeConstraints];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //    如果不想让其他页面的导航栏变为透明 需要重置
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:nil];
    
}

-(void)makeConstraints{
    [self.selectedNodesList mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
    }];
    [self.voteButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.selectedNodesList.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
        if (iPhoneX) {
            make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-20);
        }else{
            make.bottom.mas_equalTo(self.view.mas_bottom);
        }
    }];
}
//抵押
-(void)mortgage:(double)inbNumber{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [PasswordInputView showPasswordInputWithConfirmClock:^(NSString * _Nonnull password) {
        __block __weak typeof(self) tmpSelf = self;
        [MBProgressHUD showHUDAddedTo:tmpSelf.view animated:YES];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @try {
                [NetworkUtil rpc_requetWithURL:delegate.rpcHost params:@{@"jsonrpc":@"2.0",
                                                                         @"method":@"eth_getTransactionCount",
                                                                         @"params":@[[self.wallet.address add0xIfNeeded],@"latest"],@"id":@(1)}
                                    completion:^(id  _Nullable responseObject, NSError * _Nullable error) {
                                        if (error) {
                                            [MBProgressHUD hideHUDForView:tmpSelf.view animated:YES];
                                            return ;
                                        }
                                        NSDictionary *dic = (NSDictionary *)responseObject;
                                        NSDecimalNumber *nonce = [dic[@"result"] decimalNumberFromHexString];
                                       
                                        NSDecimalNumber *val = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", inbNumber]];
                                        NSDecimalNumber *bitVal = [val decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:kWei]];
                                        TransactionSignedResult *signResult = [WalletManager ethSignTransactionWithWalletID:tmpSelf.wallet.walletID nonce:[nonce stringValue] txType:TxType_moetgage gasPrice:@"200000" gasLimit:@"21000" to:@"0xaa18a055AB2017a0Cd3fB7D70f269C9B80092206" value:[bitVal stringValue] data:[[@"mortgageNet" hexString] add0xIfNeeded] password:password chainID:kChainID];
                                        
                                        [NetworkUtil rpc_requetWithURL:delegate.rpcHost
                                                                params:@{@"jsonrpc":@"2.0",
                                                                         @"method": @"eth_mortgageRawNet",
                                                                         @"params":@[[signResult.signedTx add0xIfNeeded]],
                                                                         @"id":@(67),
                                                                         }
                                                            completion:^(id  _Nullable responseObject, NSError * _Nullable error) {
                                                                [MBProgressHUD hideHUDForView:tmpSelf.view animated:YES];
                                                                if (error) {
                                                                    return ;
                                                                }
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    [NotificationCenter postNotificationName:NOTI_MORTGAGE_CHANGE object:nil];
                                                                });
                                                            }];
                                    }];
                
                
                
            } @catch (NSException *exception) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:tmpSelf.view animated:YES];
                    [MBProgressHUD showMessage:@"密码错误" toView:tmpSelf.view afterDelay:1 animted:YES];
                });
                
            } @finally {
                
            }
            
        });
    }];
}

#pragma mark ---- Button Action
-(void)voteSubmitAction:(UIButton *)sender{
//    [self registerToNode];
    if(self.selectedNode.count <= 0){
        [MBProgressHUD showMessage:NSLocalizedString(@"message.tip.noNodes", @"未选择节点，请选择后提交") toView:self.view afterDelay:1.5 animted:YES];
        return;
    }
    __block __weak typeof(self) tmpSelf = self;
    [self voteNodes];
}

-(void)voteNodes{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
     [PasswordInputView showPasswordInputWithConfirmClock:^(NSString * _Nonnull password) {
         __block __weak typeof(self) tmpSelf = self;
         [MBProgressHUD showHUDAddedTo:tmpSelf.view animated:YES];
         
         [NetworkUtil rpc_requetWithURL:delegate.rpcHost params:@{@"jsonrpc":@"2.0",
                                                                  @"method":nonce_MethodName,
                                                                  @"params":@[[self.wallet.address add0xIfNeeded],@"latest"],@"id":@(1)}
                             completion:^(id  _Nullable responseObject, NSError * _Nullable error) {
                                 if (error) {
                                     [MBProgressHUD hideHUDForView:tmpSelf.view animated:YES];
                                     [MBProgressHUD showMessage:NSLocalizedString(@"transfer.result.failed", @"转账失败") toView:tmpSelf.view afterDelay:1 animted:NO];
                                     return ;
                                 }
                                 NSDictionary *dic = (NSDictionary *)responseObject;
                                 NSDecimalNumber *nonce = [dic[@"result"] decimalNumberFromHexString];
                                 
                                 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                     @try {
                                         NSDecimalNumber *value = [NSDecimalNumber decimalNumberWithString:@"0"];
                                         NSMutableArray *nodeArr = [NSMutableArray array];
                                         for(Node *node in tmpSelf.selectedNode){
                                             [nodeArr addObject:[node.address remove0x]];
                                         }
                                         NSString *nodeStr = [nodeArr componentsJoinedByString:@","];
                                         NSString *nodeDataStr = [NSString stringWithFormat:@"%@",nodeStr];
                                    
                                         TransactionSignedResult *signResult = [WalletManager ethSignTransactionWithWalletID:tmpSelf.wallet.walletID nonce:[nonce stringValue] txType:TxType_vote gasPrice:@"200000" gasLimit:@"21000" to:[tmpSelf.wallet.address add0xIfNeeded] value:[value stringValue] data:[[nodeDataStr hexString] add0xIfNeeded] password:password chainID:kChainID]; //41，3
                                         [NetworkUtil rpc_requetWithURL:delegate.rpcHost
                                                                 params:@{@"jsonrpc":@"2.0",
                                                                          @"method":sendTran_MethodName,
                                                                          @"params":@[[signResult.signedTx add0xIfNeeded]],
                                                                          @"id":@(1)}
                                                             completion:^(id  _Nullable responseObject, NSError * _Nullable error) {
                                                                 [MBProgressHUD hideHUDForView:tmpSelf.view animated:YES];
                                                                 
                                                                 if (error) {
                                                                     [MBProgressHUD showMessage:NSLocalizedString(@"transfer.vote.failed", @"投票失败") toView:tmpSelf.view afterDelay:1 animted:NO];
                                                                     return ;
                                                                 }
                                                                 
                                                                 if(responseObject[@"error"]){
                                                                     [MBProgressHUD showMessage:responseObject[@"error"][@"message"] toView:tmpSelf.view afterDelay:1.5 animted:NO];
                                                                 }
                                                                 NSLog(@"%@---%@",[responseObject  class], responseObject);
                                                                 
                                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                                     [MBProgressHUD showMessage:NSLocalizedString(@"transfer.vote.success", @"投票成功") toView:tmpSelf.view afterDelay:1 animted:NO];
                                                                     [NotificationCenter postNotificationName:NOTI_BALANCE_CHANGE object:nil];
                                                                 });
                                                             }];
                                         
                                     } @catch (NSException *exception) {
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             [MBProgressHUD hideHUDForView:tmpSelf.view animated:YES];
                                             [MBProgressHUD showMessage:@"密码错误" toView:tmpSelf.view afterDelay:1 animted:YES];
                                         });
                                         
                                     } @finally {
                                         
                                     }
                                 });
                             }];
     }];
}

#pragma mark ---- UITableViewDelegate && DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.nodesArr.count;
    return self.selectedNode.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VoteDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([VoteDetailCell class]) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellId];
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    }
    Node *node = self.selectedNode[indexPath.row];
    cell.node = node;
    __block __weak typeof(self) tmpSelf = self;
    cell.deleteBlock = ^(Node * _Nonnull node) {
        dispatch_async(dispatch_get_main_queue(), ^{
            node.isVoted = NO;
            [tmpSelf.selectedNode removeObject:node];
            [tmpSelf.selectedNodesList reloadData];
        });
    };
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    if(!self.sectionHeaderView){
        self.sectionHeaderView = [[UILabel alloc] init];
        self.sectionHeaderView.font = AdaptedFontSize(13);
        self.sectionHeaderView.textColor = kColorAuxiliary2;
    }
    
    if (![view.subviews containsObject:self.sectionHeaderView]) {
        [view addSubview:self.sectionHeaderView];
        [self.sectionHeaderView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.mas_equalTo(0);
            make.left.mas_equalTo(view.mas_left).mas_offset(AdaptedWidth(15));
        }];
    }
    
    self.sectionHeaderView.text = [NSString stringWithFormat:@"%@ %lu/%d", NSLocalizedString(@"selectedNodes", @"已选节点"), (unsigned long)self.selectedNode.count, self.totalNodeCount];
    return view;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y >= AdaptedHeight(150)) {
        //    如果不想让其他页面的导航栏变为透明 需要重置
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//        [self.navigationController.navigationBar setShadowImage:nil];
    }else{
        //    //设置导航栏背景图片为一个空的image，这样就透明了
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        //去掉透明后导航栏下边的黑边
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    }
}
#pragma mark ---- setter && getter
-(UITableView *)selectedNodesList{
    if (_selectedNodesList == nil) {
        _selectedNodesList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, KHEIGHT) style:UITableViewStyleGrouped];
        _selectedNodesList.backgroundColor = [UIColor whiteColor];
        _selectedNodesList.delegate = self;
        _selectedNodesList.dataSource = self;
    }
    return _selectedNodesList;
}

-(UIButton *)voteButton{
    if (_voteButton == nil) {
        _voteButton = [[UIButton alloc] init];
        [_voteButton setTitle:NSLocalizedString(@"submitVote", @"提交投票") forState:UIControlStateNormal];
        _voteButton.titleLabel.font = AdaptedFontSize(15);
        [_voteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_voteButton setBackgroundColor:kColorBlue];
        [_voteButton addTarget:self action:@selector(voteSubmitAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voteButton;
}

@end
