//
//  WalletInfoFunctionView.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/2.
//  Copyright © 2019 apple. All rights reserved.
//

#import "WalletInfoFunctionView.h"
#import "UIButton+Layout.h"

#define marginImg 10

@interface WalletInfoFunctionView()
@property(nonatomic, strong) UIButton *transferBtn; //转账
@property(nonatomic, strong) UIButton *gatheringBtn;//收款
@property(nonatomic, strong) UIButton *nodeBtn;     //扫一扫
@property(nonatomic, strong) UIButton *voteBtn; //投票
@property(nonatomic, strong) UIButton *recordTransactionBtn; //交易记录
@property(nonatomic, strong) UIButton *backupBtn; //备份
@end

@implementation WalletInfoFunctionView

-(instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.transferBtn];
        [self addSubview:self.gatheringBtn];
        [self addSubview:self.nodeBtn];
        [self addSubview:self.voteBtn];
        [self addSubview:self.recordTransactionBtn];
        [self addSubview:self.backupBtn];
        
        [self makeConstraints];
    }
    return self;
}

-(void)makeConstraints{
    [self.gatheringBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(2);
        make.width.mas_equalTo(AdaptedWidth(70));
        make.height.mas_equalTo(AdaptedHeight(60));
    }];
    [self.transferBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.gatheringBtn.mas_top);
        make.right.mas_equalTo(self.gatheringBtn.mas_left).mas_offset(AdaptedWidth(-70));
        make.width.height.mas_equalTo(self.gatheringBtn);
    }];
    [self.recordTransactionBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.gatheringBtn.mas_top);
        make.left.mas_equalTo(self.gatheringBtn.mas_right).mas_offset(AdaptedWidth(70));
        make.width.height.mas_equalTo(self.gatheringBtn);
    }];
    [self.backupBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.transferBtn);
        make.top.mas_equalTo(self.transferBtn.mas_bottom).mas_offset(AdaptedHeight(2));
        make.bottom.mas_equalTo(0);
        make.width.height.mas_equalTo(self.gatheringBtn);
    }];
    [self.voteBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.gatheringBtn);
        make.top.mas_equalTo(self.backupBtn);
        make.width.height.mas_equalTo(self.gatheringBtn);
    }];
    [self.nodeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.recordTransactionBtn);
        make.top.mas_equalTo(self.voteBtn);
        make.width.height.mas_equalTo(self.gatheringBtn);
    }];
    
    [self.transferBtn topImgbelowTitle:marginImg];
    [self.gatheringBtn topImgbelowTitle:marginImg];
    [self.nodeBtn topImgbelowTitle:marginImg];
    [self.voteBtn topImgbelowTitle:marginImg];
    [self.recordTransactionBtn topImgbelowTitle:marginImg];
    [self.backupBtn topImgbelowTitle:marginImg];
}

#pragma mark ---- Button Action
//转账
-(void)transferAction:(UIButton *)sender{
    if (self.click) {
        self.click(FunctionType_transfer);
    }
}
//收款
-(void)gatherAction:(UIButton *)sender{
    if (self.click) {
        self.click(FunctionType_collection);
    }
}
//扫码
-(void)nodeAction:(UIButton *)sender{
    if (self.click) {
        self.click(FunctionType_node);
    }
}
//投票
-(void)voteAction:(UIButton *)sender{
    if (self.click) {
        self.click(FunctionType_vote);
    }
}
//记录
-(void)recordAction:(UIButton *)sender{
    if (self.click) {
        self.click(FunctionType_record);
    }
}
//备份
-(void)backupAction:(UIButton *)sender{
    if (self.click) {
        self.click(FunctionType_reward);
    }
}

-(UIButton *)transferBtn{
    if (_transferBtn == nil) {
        _transferBtn = [[UIButton alloc] init];
        [_transferBtn setTitle:NSLocalizedString(@"transfer", @"转账") forState:UIControlStateNormal];
        [_transferBtn setImage:[UIImage imageNamed:@"wallet_transfer"] forState:UIControlStateNormal];

        [_transferBtn setTitleColor:kColorTitle forState:UIControlStateNormal];
        _transferBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_transferBtn addTarget:self action:@selector(transferAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _transferBtn;
}
-(UIButton *)gatheringBtn{
    if (_gatheringBtn == nil) {
        _gatheringBtn = [[UIButton alloc] init];
        [_gatheringBtn setTitle:NSLocalizedString(@"collection", @"收款") forState:UIControlStateNormal];
        [_gatheringBtn setImage:[UIImage imageNamed:@"wallet_gathering"] forState:UIControlStateNormal];
        [_gatheringBtn setTitleColor:kColorTitle forState:UIControlStateNormal];
        _gatheringBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_gatheringBtn addTarget:self action:@selector(gatherAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _gatheringBtn;
}
-(UIButton *)nodeBtn{
    if (_nodeBtn == nil) {
        _nodeBtn = [[UIButton alloc] init];
        [_nodeBtn setTitle:NSLocalizedString(@"wallet.node", @"节点申请") forState:UIControlStateNormal];
        [_nodeBtn setImage:[UIImage imageNamed:@"wallet_node"] forState:UIControlStateNormal];
        [_nodeBtn setTitleColor:kColorTitle forState:UIControlStateNormal];
        _nodeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_nodeBtn addTarget:self action:@selector(nodeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nodeBtn;
}
-(UIButton *)voteBtn{
    if (_voteBtn == nil) {
        _voteBtn = [[UIButton alloc] init];
        [_voteBtn setTitle:NSLocalizedString(@"transfer.vote", @"节点投票") forState:UIControlStateNormal];
        [_voteBtn setImage:[UIImage imageNamed:@"wallet_vote"] forState:UIControlStateNormal];
        [_voteBtn setTitleColor:kColorTitle forState:UIControlStateNormal];
        _voteBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_voteBtn addTarget:self action:@selector(voteAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voteBtn;
}
-(UIButton *)recordTransactionBtn{
    if (_recordTransactionBtn == nil) {
        _recordTransactionBtn = [[UIButton alloc] init];
        [_recordTransactionBtn setTitle:NSLocalizedString(@"transactionRecords", @"交易记录") forState:UIControlStateNormal];
        [_recordTransactionBtn setImage:[UIImage imageNamed:@"wallet_transaction_record"] forState:UIControlStateNormal];
        [_recordTransactionBtn setTitleColor:kColorTitle forState:UIControlStateNormal];
        _recordTransactionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_recordTransactionBtn addTarget:self action:@selector(recordAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recordTransactionBtn;
}
-(UIButton *)backupBtn{
    if (_backupBtn == nil) {
        _backupBtn = [[UIButton alloc] init];
        [_backupBtn setTitle:NSLocalizedString(@"wallet.reward", @"收益奖励") forState:UIControlStateNormal];
        [_backupBtn setImage:[UIImage imageNamed:@"wallet_reward"] forState:UIControlStateNormal];
        [_backupBtn setTitleColor:kColorTitle forState:UIControlStateNormal];
        _backupBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_backupBtn addTarget:self action:@selector(backupAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backupBtn;
}
@end
