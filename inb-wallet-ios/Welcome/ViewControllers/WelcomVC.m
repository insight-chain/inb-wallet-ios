//
//  WelcomVC.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/26.
//  Copyright © 2019 apple. All rights reserved.
//

#import "WelcomVC.h"

#import "WalletInfoVC.h"
#import "WalletImportVC.h"
#import "WalletCreatedVC.h"

#import "BasicWallet.h"
#import "Identity.h"

@interface WelcomVC ()
@property(nonatomic, strong) UIImageView *topBgImageView;
@property(nonatomic, strong) UILabel *welcomLabel;

@property(nonatomic, strong) UIImageView *createImageView;
@property(nonatomic, strong) UILabel *createTip1;
@property(nonatomic, strong) UILabel *createTip2;
@property(nonatomic, strong) UIView *createTipView;

@property(nonatomic, strong) UIImageView *importImageView;
@property(nonatomic, strong) UILabel *importTip1;
@property(nonatomic, strong) UILabel *importTip2;
@property(nonatomic, strong) UIView *importTipView;
@end

@implementation WelcomVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NotificationCenter addObserver:self selector:@selector(addWalletNoti:) name:NOTI_ADD_WALLET object:nil];
    
    self.view.backgroundColor = kColorBackground;
    
    [self.view addSubview:self.topBgImageView];
    [self.view addSubview:self.welcomLabel];
    [self.view addSubview:self.importImageView];
    [self.view addSubview:self.importTipView];
    
    [self.view addSubview:self.createImageView];
    [self.view addSubview:self.createTipView];
    
    [self.importTipView addSubview:self.importTip1];
    [self.importTipView addSubview:self.importTip2];
    
    [self.createTipView addSubview:self.createTip1];
    [self.createTipView addSubview:self.createTip2];
    
    [self makeConstraints];
    
    NSString *str = NSLocalizedString(@"welcom", @"您好,欢迎来到Insight Chain");
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attrStr setAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:self.welcomLabel.font} range:NSMakeRange(0, str.length)];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 20;
    [attrStr addAttributes:@{NSParagraphStyleAttributeName:paragraph} range:NSMakeRange(0, str.length)];
    self.welcomLabel.attributedText = attrStr;
    
    NSString *importTip_1 = [NSString stringWithFormat:@"%@（%@）", NSLocalizedString(@"importWallet", @"导入钱包"), NSLocalizedString(@"welcom.hasINBWallet", @"我有INB公链钱包")];
    NSMutableAttributedString *importAttri = [[NSMutableAttributedString alloc] initWithString:importTip_1 attributes:@{NSFontAttributeName:AdaptedFontSize(12), NSForegroundColorAttributeName:kColorTitle}];
    [importAttri setAttributes:@{NSFontAttributeName:AdaptedFontSize(16), NSForegroundColorAttributeName:kColorTitle} range:[importTip_1 rangeOfString:NSLocalizedString(@"importWallet", @"导入钱包")]];
    self.importTip1.attributedText = importAttri;
    self.importTip2.text = NSLocalizedString(@"welcom.importTip", @"通过私钥、助记词导入钱包");
    
    NSString *createTip_1 = [NSString stringWithFormat:@"%@（%@）", NSLocalizedString(@"createWallet", @"创建钱包"), NSLocalizedString(@"welcom.noINBWallet", @"没有INB公链钱包")];
    NSMutableAttributedString *createAttri = [[NSMutableAttributedString alloc] initWithString:createTip_1 attributes:@{NSFontAttributeName:AdaptedFontSize(12), NSForegroundColorAttributeName:kColorTitle}];
    [createAttri setAttributes:@{NSFontAttributeName:AdaptedFontSize(16), NSForegroundColorAttributeName:kColorTitle} range:[createTip_1 rangeOfString:NSLocalizedString(@"createWallet", @"创建钱包")]];
    self.createTip1.attributedText = createAttri;
    self.createTip2.text = NSLocalizedString(@"welcom.createTip", @"创建一个INB钱包");
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}
-(void)viewWillDisappear:(BOOL)animated{
    //    如果不想让其他页面的导航栏变为透明 需要重置
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

/** 设置状态栏的颜色，配合根控制器的 childViewControllerForStatusBarStyle 使用**/
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent; //UIStatusBarStyleDefault
}

-(void)makeConstraints{
    [self.topBgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_offset(AdaptedHeight(245));
    }];
    [self.welcomLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topBgImageView.mas_top).mas_offset(AdaptedWidth(100));
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
    }];
    [self.importImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topBgImageView.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(self.importImageView.mas_width).multipliedBy(23.0/67.0);
    }];
    [self.importTipView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.importImageView.mas_centerY);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(self.importTip2.mas_right);
        make.right.mas_equalTo(self.importTip1.mas_right);
        make.top.mas_equalTo(self.importTip1.mas_top);
        make.bottom.mas_equalTo(self.importTip2.mas_bottom);
    }];
    [self.createImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.importImageView.mas_bottom).mas_offset(40);
        make.left.right.height.mas_equalTo(self.importImageView);
    }];
    [self.createTipView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.createImageView.mas_centerY);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(self.createTip1.mas_right);
        make.right.mas_equalTo(self.createTip2.mas_right);
        make.top.mas_equalTo(self.createTip1.mas_top);
        make.bottom.mas_equalTo(self.createTip2.mas_bottom);
    }];
    
    [self.importTip1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.importTipView);
    }];
    [self.importTip2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.importTip1.mas_bottom).mas_offset(15);
        make.left.mas_equalTo(self.importTip1.mas_left);
    }];
    
    [self.createTip1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.createTipView);
    }];
    [self.createTip2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.createTip1.mas_bottom).mas_offset(15);
        make.left.mas_equalTo(self.createTip1.mas_left);
    }];
}

-(void)addWalletNoti:(NSNotification *)noti{
    BasicWallet *wallet = noti.object;
    Identity *identi = [Identity currentIdentity];
    
    BasicWallet *firstWallet = identi.wallets.firstObject;
    /** 钱包 **/
    WalletInfoVC *walletInfoVC = [[WalletInfoVC alloc] init];
    walletInfoVC.title = NSLocalizedString(@"wallet", @"钱包");
    walletInfoVC.view.backgroundColor = [UIColor whiteColor];

    walletInfoVC.tabBarItem.image = [[UIImage imageNamed:@"tab_wallet_no"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//渲染模式初始化
    walletInfoVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_wallet_yes"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    walletInfoVC.tabBarItem.title = NSLocalizedString(@"wallet", @"钱包");
    
    walletInfoVC.selectedWallet = firstWallet;
    walletInfoVC.wallets = identi.wallets;
    
    TabBarVC *tab = (TabBarVC *)self.tabBarController;
    CCNavigationController *navi = tab.viewControllers[0];
    [navi setViewControllers:@[walletInfoVC] animated:YES];
}

#pragma mark ---- Gesture Action
//创建
-(void)createWallet:(UITapGestureRecognizer *)gesture{
    WalletCreatedVC *createVC = [[WalletCreatedVC alloc] init];
    createVC.navigationItem.title = NSLocalizedString(@"createWallet", @"创建钱包");
    createVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:createVC animated:YES];
}
//导入
-(void)importWallet:(UIGestureRecognizer *)gesture{
    WalletImportVC *importVC = [[WalletImportVC alloc] init];
    importVC.navigationItem.title = NSLocalizedString(@"importWallet", @"导入钱包");
    importVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:importVC animated:YES];
}

#pragma mark ---- getter 
-(UIImageView *)topBgImageView{
    if (_topBgImageView == nil) {
        _topBgImageView = [[UIImageView alloc] init];
        _topBgImageView.image = [UIImage imageNamed:@"wallet_top_bg"];
    }
    return _topBgImageView;
}
-(UIImageView *)createImageView{
    if (_createImageView == nil) {
        _createImageView = [[UIImageView alloc] init];
        _createImageView.image = [UIImage imageNamed:@"wallet_create_bg"];
        
        _createImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(createWallet:)];
        [_createImageView addGestureRecognizer:tap];
    }
    return _createImageView;
}
-(UIImageView *)importImageView{
    if (_importImageView == nil) {
        _importImageView = [[UIImageView alloc] init];
        _importImageView.image = [UIImage imageNamed:@"wallet_import_bg"];
        _importImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(importWallet:)];
        [_importImageView addGestureRecognizer:tap];
    }
    return _importImageView;
}
-(UILabel *)welcomLabel{
    if (_welcomLabel == nil) {
        _welcomLabel = [[UILabel alloc] init];
        _welcomLabel.textColor = [UIColor whiteColor];
        _welcomLabel.font = AdaptedFontSize(23);
        _welcomLabel.numberOfLines = 0;
        
    }
    return _welcomLabel;
}

-(UILabel *)importTip1{
    if (_importTip1 == nil) {
        _importTip1 = [[UILabel alloc] init];
        _importTip1.font = AdaptedFontSize(16);
        _importTip1.textColor = kColorTitle;
        
        _importTip1.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(importWallet:)];
        [_importTip1 addGestureRecognizer:tap];
    }
    return _importTip1;
}
-(UILabel *)importTip2{
    if (_importTip2 == nil) {
        _importTip2 = [[UILabel alloc] init];
        _importTip2.font = AdaptedFontSize(15);
        _importTip2.textColor = kColorBlue;
        
        _importTip2.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(importWallet:)];
        [_importTip2 addGestureRecognizer:tap];
    }
    return _importTip2;
}

-(UILabel *)createTip1{
    if (_createTip1 == nil) {
        _createTip1 = [[UILabel alloc] init];
        _createTip1.font = AdaptedFontSize(16);
        _createTip1.textColor = kColorTitle;
        
        _createTip1.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(createWallet:)];
        [_createTip1 addGestureRecognizer:tap];
    }
    return _createTip1;
}
-(UILabel *)createTip2{
    if (_createTip2 == nil) {
        _createTip2 = [[UILabel alloc] init];
        _createTip2.font = AdaptedFontSize(15);
        _createTip2.textColor = kColorBlue;
        
        _createTip2.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(createWallet:)];
        [_createTip2 addGestureRecognizer:tap];
    }
    return _createTip2;
}
-(UIView *)createTipView{
    if (_createTipView == nil) {
        _createTipView = [[UIView alloc] init];
        _createTipView.backgroundColor = [UIColor whiteColor];
    }
    return _createTipView;
}
-(UIView *)importTipView{
    if (_importTipView == nil) {
        _importTipView = [[UIView alloc] init];
        _importTipView.backgroundColor = [UIColor whiteColor];
    }
    return _importTipView;
}
@end
