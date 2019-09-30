//
//  WalletAccountsListView.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/15.
//  Copyright © 2019 apple. All rights reserved.
//

#import "WalletAccountsListView.h"
#import "WalletAccountsListCell.h"

#import "BasicWallet.h"

#import "SDWebImage.h"

@interface WalletAccountsListView()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, assign) int selectedIndex;

@property(nonatomic, strong) UIView *maskView;
@property(nonatomic, strong) UITableView *tableView;

//收起
@property(nonatomic, strong) UIView *packUpView;
@property(nonatomic, strong) UIImageView *packUpImg;

@property(nonatomic, strong) UIView *addAccountView; //添加账户
@property(nonatomic, strong) UIButton *addAccountBtn;

@property(nonatomic, copy) void(^clickBlock)(int index);

@end

#define cellId @"accountListCell"

static double cellHeight = 70;

@implementation WalletAccountsListView

+(instancetype)showAccountList:(NSArray *)accounts selectAccount:(nonnull BasicWallet *)selected clickBlock:(nonnull void (^)(int))clickBlock{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    WalletAccountsListView *listView = [[WalletAccountsListView alloc] initWithFrame:window.bounds];
    listView.accounts = accounts;
    listView.selectedIndex = (int)[accounts indexOfObject:selected];
    listView.clickBlock = clickBlock;
    [window addSubview:listView];
    return listView;
}
-(instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.maskView];
        [self addSubview:self.tableView];
        [self addSubview:self.addAccountView];
        [self addSubview:self.packUpView];
        
        [self.packUpView addSubview:self.packUpImg];
        [self.addAccountView addSubview:self.addAccountBtn];
        
        [self makeConstraints];
        
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.maskView];
        [self addSubview:self.tableView];
        [self addSubview:self.addAccountView];
        [self addSubview:self.packUpView];
        
        [self.addAccountView addSubview:self.addAccountBtn];
        [self.packUpView addSubview:self.packUpImg];
        
        [self makeConstraints];
    }
    return self;
}
-(void)makeConstraints{
    [self.maskView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.mas_equalTo(0);
    }];
    [self.packUpView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.tableView.mas_top);
        make.height.mas_equalTo(35);
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.addAccountView.mas_top);
//        make.height.mas_lessThanOrEqualTo(280);
        double hei = self.accounts.count * cellHeight;
        make.height.mas_equalTo( hei> 280 ? 280 : hei);
    }];
    [self.addAccountView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        if (iPhoneX) {
            make.bottom.mas_equalTo(0+20);
        }else{
            make.bottom.mas_equalTo(0);
        }
        make.height.mas_equalTo(65);
    }];
    
    [self.packUpImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.packUpView);
        make.top.mas_equalTo(20);
    }];
    [self.addAccountBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.addAccountView.mas_centerX);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(195);
    }];
}
//隐藏列表
-(void)hideListView{
    [self removeFromSuperview];
}
//添加账户
-(void)addAccountAction:(UIButton *)sender{
    if(self.addAccountBlock){
        self.addAccountBlock();
    }
    [self hideListView];
}
#pragma mark ----
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.accounts.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WalletAccountsListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([WalletAccountsListCell class]) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellId];
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    }
    BasicWallet *wallet = self.accounts[indexPath.row];
    [cell.imageHeaderView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"headerImgDefault"]];
    cell.nameLabel.text = wallet.imTokenMeta.name;
    cell.addressLabel.text = wallet.address;
    if (indexPath.row == self.selectedIndex) {
        cell.selectedImg.image = [UIImage imageNamed:@"selected_yes"];
    }else{
        cell.selectedImg.image = [UIImage imageNamed:@"selected_no"];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WalletAccountsListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row != self.selectedIndex) {
        WalletAccountsListCell *oldCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section inSection:self.selectedIndex]];
        cell.selectedImg.image = [UIImage imageNamed:@"selected_yes"];
        oldCell.selectedImg.image = [UIImage imageNamed:@"selected_no"];
        if (self.clickBlock) {
            self.clickBlock(indexPath.row);
        }
        [self hideListView];
    }
}
#pragma mark ---- setter && getter
-(UIView *)maskView{
    if (_maskView == nil) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = kColorWithRGBA(0, 0, 0, 0.3);
        _maskView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideListView)];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
-(UIView *)addAccountView{
    if (_addAccountView == nil) {
        _addAccountView = [[UIView alloc] init];
        _addAccountView.backgroundColor = [UIColor whiteColor];
    }
    return _addAccountView;
}
-(UIButton *)addAccountBtn{
    if (_addAccountBtn == nil) {
        _addAccountBtn = [[UIButton alloc] init];
        [_addAccountBtn setTitle:NSLocalizedString(@"addAccount", @"添加账户") forState:UIControlStateNormal];
        _addAccountBtn.titleLabel.font = AdaptedFontSize(15);
        UIImage *img = [UIImage imageNamed:@"btn_bg_blue"];
        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height/2.0, img.size.width/2.0, img.size.height/2.0, img.size.width/2.0) resizingMode:UIImageResizingModeStretch];
        [_addAccountBtn setBackgroundImage:img forState:UIControlStateNormal];
        [_addAccountBtn addTarget:self action:@selector(addAccountAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addAccountBtn;
}
-(UIView *)packUpView{
    if (_packUpView == nil) {
        _packUpView = [[UIView alloc] init];
        _packUpView.backgroundColor = [UIColor whiteColor];
        _packUpView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideListView)];
        [_packUpView addGestureRecognizer:tap];
    }
    return _packUpView;
}
-(UIImageView *)packUpImg{
    if (_packUpImg == nil) {
        _packUpImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"packUp"]];
    }
    return _packUpImg;
}

-(void)setAccounts:(NSArray *)accounts{
    _accounts = accounts;
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.addAccountView.mas_top);
        double hei = self.accounts.count * cellHeight;
        make.height.mas_equalTo( hei> 280 ? 280 : hei);
    }];
    
}

@end
