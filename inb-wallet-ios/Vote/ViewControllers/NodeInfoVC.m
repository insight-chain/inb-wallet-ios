//
//  NodeInfoVC.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/6.
//  Copyright © 2019 apple. All rights reserved.
//

#import "NodeInfoVC.h"
#import "VoteBarView.h"

#import "VoteDetailVC.h"

#import "NodeHeaderTableViewCell.h"
#import "NodeInfoCell.h"
#import "SettingCell.h"

#import "BasicWallet.h"

#import "SDWebImage.h"

#define cellId_1 @"nodeInfoHeader"
#define cellId_2 @"nodeInfoCell"
#define cellId_3 @"settingCell"

@interface NodeInfoVC ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) VoteBarView *voteBarView;
@end

@implementation NodeInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.voteBarView];
    
    [self makeConstraints];
    
    __block __weak typeof(self) tmpSelf = self;
    self.voteBarView.subVote = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            VoteDetailVC *detailVC = [[VoteDetailVC alloc] init];
            detailVC.wallet = tmpSelf.wallet;
            detailVC.selectedNode = tmpSelf.selectedNodes;
            detailVC.totalNodeCount = tmpSelf.totalNode;
            detailVC.navigationItem.title = NSLocalizedString(@"vote", @"投票");
            detailVC.hidesBottomBarWhenPushed = YES;
            [tmpSelf.navigationController pushViewController:detailVC animated:YES];
        });
    };
    self.voteBarView.deleteNode = ^(Node * _Nonnull node) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [tmpSelf.tableView reloadData];
            [tmpSelf.selectedNodes removeObject:node];
        });
    };
    self.voteBarView.totalNodes = self.totalNode;
    for (Node *node in self.selectedNodes) {
        [self.voteBarView addNode:node];
    }
}

-(void)makeConstraints{
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.voteBarView.mas_top);
    }];
    [self.voteBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.tableView.mas_bottom);
        if(iPhoneX){
            make.height.mas_equalTo(AdaptedWidth(50)+20);
        }else{
            make.height.mas_equalTo(AdaptedWidth(50));
        }
        make.bottom.mas_equalTo(self.view);
    }];
}

#pragma mark ---- UITableViewDelegate && DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 || section == 1 || section == 2) {
        
        return 1;
    }else if (section == 3){
        return 4;
    }else{
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NodeHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId_1];
        if (cell == nil) {
            UINib *nib = [UINib nibWithNibName:NSStringFromClass([NodeHeaderTableViewCell class]) bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:cellId_1];
            cell = [tableView dequeueReusableCellWithIdentifier:cellId_1];
        }
        [cell.headerImg sd_setImageWithURL:[NSURL URLWithString:self.node.image] placeholderImage:[UIImage imageNamed:@"headerImgDefault"]];
        cell.country.text = self.node.country;
        cell.city.text = self.node.city;
        cell.website.text = self.node.webSite;
        cell.name.text = self.node.name;
        cell.address.text = self.node.address;
        if([self.selectedNodes containsObject:self.node]){
            [cell.voteBtn setTitle:@"已投票" forState:UIControlStateNormal];
        }else{
            [cell.voteBtn setTitle:NSLocalizedString(@"vote", @"投票") forState:UIControlStateNormal];
        }
        __block __weak typeof(self) tmpSelf = self;
        cell.voteBlock = ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([tmpSelf.selectedNodes containsObject:tmpSelf.node]) {
                    tmpSelf.node.isVoted = NO;
                    [tmpSelf.selectedNodes removeObject:tmpSelf.node];
                    [tmpSelf.voteBarView deleteNode:tmpSelf.node];
                    [cell.voteBtn setTitle:@"投票" forState:UIControlStateNormal];
                }else{
                    tmpSelf.node.isVoted = YES;
                    [tmpSelf.selectedNodes addObject:tmpSelf.node];
                    [tmpSelf.voteBarView addNode:tmpSelf.node];
                    [cell.voteBtn setTitle:@"已投票" forState:UIControlStateNormal];
                }
            });
        };
        return cell;
    }else if (indexPath.section == 1 || indexPath.section == 2){
        NodeInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId_2];
        if (cell == nil) {
            UINib *nib = [UINib nibWithNibName:NSStringFromClass([NodeInfoCell class]) bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:cellId_2];
            cell = [tableView dequeueReusableCellWithIdentifier:cellId_2];
        }
        if (indexPath.section == 1) {
            cell.infoLable.text = self.node.serverIntro;
        }else{
            cell.infoLable.text = self.node.intro;
        }
        return cell;
    }else if(indexPath.section == 3){
        SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId_3];
        if (cell == nil) {
            UINib *nib = [UINib nibWithNibName:NSStringFromClass([SettingCell class]) bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:cellId_3];
            cell = [tableView dequeueReusableCellWithIdentifier:cellId_3];
        }
        cell.hideSubTitle = NO;
        cell.hideAuxiliaryImg = YES;
        cell.hideSeperator = NO;
        cell.hideRightImg = YES;
        if (indexPath.row == 0) {
            cell.title.text = @"官方twitter";
            cell.subTitle.text = @"http://www.insightchain.io";
        }else if (indexPath.row == 1){
            cell.title.text = @"官方点电报";
            cell.subTitle.text = @"http://www.insightchain.io";
        }else if(indexPath.row == 2){
            cell.title.text = @"官方微信";
            cell.subTitle.text = @"Insightchain";
        }else if (indexPath.row == 3){
            cell.title.text = @"Facebook";
            cell.subTitle.text = @"Insightchain";
        }
        return cell;
    }else{
        return nil;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return nil;
    }else if (section == 1 || section == 2 || section == 3){
        UIView *headeV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, 40)];
        headeV.backgroundColor = [UIColor whiteColor];
        UILabel *la = [[UILabel alloc] init];
        la.textColor = kColorBlue;
        la.font = AdaptedFontSize(15);
        [headeV addSubview:la];
        [la mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(20);
            make.bottom.mas_equalTo(-5);
        }];
        
        if (section == 1) {
            la.text = NSLocalizedString(@"node.server", @"服务器");
        }else if (section == 2){
            la.text = NSLocalizedString(@"node.team", @"团队介绍");
        }else if (section == 3){
            la.text = NSLocalizedString(@"node.contact", @"联系方式");
        }
        
        return headeV;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }else if (section == 1 || section == 2 || section == 3){
        return 40;
    }else{
        return 0.01;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, 8)];
    view.backgroundColor = kColorBackground;
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1 || section == 3) {
        return 0.01;
    }
    return 8;
}
#pragma mark ---- Setter && Getter
-(UITableView *)tableView{
    if (_tableView == nil ) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, KHEIGHT) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
    }
    return _tableView;
}
-(VoteBarView *)voteBarView{
    if (_voteBarView == nil) {
        _voteBarView = [[VoteBarView alloc] init];
        
    }
    return _voteBarView;
}
@end
