//
//  WalletBackupVC.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/15.
//  Copyright © 2019 apple. All rights reserved.
//

#import "WalletBackupVC.h"

#define kFontSize 15

#define kBigMargin 20
#define kMidMargin 15
#define kLittleMargin 10

@interface WalletBackupVC ()

@property(nonatomic, strong) UILabel *accountNameLabel; //"账号名"
@property(nonatomic, strong) UILabel *accountName;
@property(nonatomic, strong) UIImageView *accountNameBg;

@property(nonatomic, strong) UILabel *addressLabel; //"钱包地址"
@property(nonatomic, strong) UILabel *address;
@property(nonatomic, strong) UIImageView *addressBg;

@property(nonatomic, strong) UILabel *privateLabel; //"私钥地址"
@property(nonatomic, strong) UILabel *private;
@property(nonatomic, strong) UIImageView *privateBg;

@property(nonatomic, strong) UILabel *menmonryLabel; //助记词
@property(nonatomic, strong) UILabel *menmonry;
@property(nonatomic, strong) UIImageView *menmonryBg;
@property(nonatomic, strong) UIButton *menmonryCopy;

@property(nonatomic, strong) UIImageView *tipImg_1;
@property(nonatomic, strong) UILabel *tipLabel_1;
@property(nonatomic, strong) UIImageView *tipImg_2;
@property(nonatomic, strong) UILabel *tipLabel_2;

@property(nonatomic, strong) UIButton *addressCopyBtn;

@end

@implementation WalletBackupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    /** View被导航栏遮挡问题的解决 **/
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
    
    [self makeConstraints];
    
    self.accountName.text = self.name;
    self.address.text = self.privateKey;
    self.menmonry.text = self.menmonryKey;
}

-(void)makeConstraints{
    [self.view addSubview:self.accountNameLabel];
    [self.view addSubview:self.accountNameBg];
    [self.view addSubview:self.accountName];
    
    [self.view addSubview:self.addressLabel];
    [self.view addSubview:self.addressBg];
    [self.view addSubview:self.address];
    [self.view addSubview:self.addressCopyBtn];
    
    [self.view addSubview:self.menmonryLabel];
    [self.view addSubview:self.menmonryBg];
    [self.view addSubview:self.menmonry];
    [self.view addSubview:self.menmonryCopy];
    
    UIView *sepView = [[UIView alloc] init];
    sepView.backgroundColor = kColorBackground;
    [self.view addSubview:sepView];
    
    [self.view addSubview:self.tipImg_1];
    [self.view addSubview:self.tipLabel_1];
    [self.view addSubview:self.tipImg_2];
    [self.view addSubview:self.tipLabel_2];
    
    [self.accountNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(AdaptedWidth(kBigMargin));
    }];
    [self.accountNameBg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.accountNameLabel.mas_bottom).mas_offset(AdaptedHeight(kLittleMargin));
        make.left.mas_equalTo(AdaptedWidth(kMidMargin));
        make.right.mas_equalTo(AdaptedWidth(-kMidMargin));
        make.height.mas_equalTo(AdaptedHeight(45));
    }];
    [self.accountName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.accountNameBg);
        make.left.mas_equalTo(self.accountNameBg.mas_left).mas_offset(AdaptedWidth(kLittleMargin));
    }];
    
    [self.addressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.accountNameBg.mas_bottom).mas_offset(AdaptedHeight(kBigMargin));
        make.left.mas_equalTo(self.accountNameLabel);
    }];
    [self.addressBg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.addressLabel.mas_bottom).mas_offset(AdaptedHeight(kLittleMargin));
        make.left.mas_equalTo(AdaptedWidth(kMidMargin));
        make.right.mas_equalTo(AdaptedWidth(-kMidMargin));
        make.height.mas_equalTo(AdaptedHeight(100));
    }];
    [self.address mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.addressBg.mas_top).mas_offset(AdaptedHeight(kMidMargin)); make.left.mas_equalTo(self.addressBg.mas_left).mas_offset(AdaptedWidth(kLittleMargin));
        make.right.mas_equalTo(self.addressBg.mas_right).mas_offset(AdaptedWidth(-kLittleMargin));
    }];
    
    [self.addressCopyBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.addressBg.mas_bottom).mas_offset(AdaptedHeight(-kMidMargin));
        make.right.mas_equalTo(self.addressBg.mas_right).mas_offset(AdaptedWidth(-kLittleMargin));
        make.width.height.mas_equalTo(AdaptedWidth(kBigMargin));
    }];
    
    [self.menmonryLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.addressBg.mas_bottom).mas_offset(AdaptedHeight(kBigMargin));
        make.left.mas_equalTo(self.accountNameLabel);
    }];
    [self.menmonryBg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.menmonryLabel.mas_bottom).mas_offset(AdaptedHeight(kLittleMargin));
        make.left.mas_equalTo(AdaptedWidth(kMidMargin));
        make.right.mas_equalTo(AdaptedWidth(-kMidMargin));
        make.height.mas_equalTo(AdaptedHeight(100));
    }];
    [self.menmonry mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.menmonryBg.mas_top).mas_offset(AdaptedHeight(kMidMargin)); make.left.mas_equalTo(self.menmonryBg.mas_left).mas_offset(AdaptedWidth(kLittleMargin));
        make.right.mas_equalTo(self.menmonryBg.mas_right).mas_offset(AdaptedWidth(-kLittleMargin));
    }];
    [self.menmonryCopy mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.menmonryBg.mas_bottom).mas_offset(AdaptedHeight(-kMidMargin));
        make.right.mas_equalTo(self.menmonryBg.mas_right).mas_offset(AdaptedWidth(-kLittleMargin));
        make.width.height.mas_equalTo(AdaptedWidth(kBigMargin));
    }];
    
    [sepView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.menmonryBg.mas_bottom).mas_offset(AdaptedHeight(kBigMargin));
        make.height.mas_equalTo(AdaptedHeight(8));
    }];
    
    [self.tipImg_1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(sepView.mas_bottom).mas_offset(AdaptedHeight(kBigMargin));
        make.left.mas_equalTo(self.view).mas_offset(AdaptedWidth(kMidMargin));
        make.width.height.mas_equalTo(AdaptedWidth(15));
    }];
    [self.tipLabel_1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.tipImg_1);
        make.left.mas_equalTo(self.tipImg_1.mas_right).mas_offset(AdaptedWidth(5));
        make.right.mas_equalTo(self.addressBg.mas_right);
    }];
    [self.tipImg_2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipLabel_1.mas_bottom).mas_offset(AdaptedHeight(kMidMargin));
        make.left.width.height.mas_equalTo(self.tipImg_1);
    }];
    [self.tipLabel_2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipImg_2);
        make.left.right.mas_equalTo(self.tipLabel_1);
    }];
}

#pragma mark ---- Action
//复制钱包地址
-(void)addressCopy:(UIButton *)sender{
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    board.string = self.privateKey;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = @"私钥已复制到剪贴板";
    [hud setRemoveFromSuperViewOnHide:YES];
    [hud hideAnimated:YES afterDelay:2];
}
//复制助记词
-(void)mnemonicCopy:(UIButton *)sender{
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    board.string = self.menmonryKey;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = @"助记词已复制到剪贴板";
    [hud setRemoveFromSuperViewOnHide:YES];
    [hud hideAnimated:YES afterDelay:2];
}
#pragma mark ----
-(UILabel *)accountNameLabel{
    if(_accountNameLabel == nil){
        _accountNameLabel = [[UILabel alloc] init];
        _accountNameLabel.font = AdaptedFontSize(kFontSize);
        _accountNameLabel.textColor = kColorBlue;
        _accountNameLabel.text = NSLocalizedString(@"accountName", @"账号名");
    }
    return _accountNameLabel;
}
-(UIImageView *)accountNameBg{
    if (_accountNameBg == nil) {
        _accountNameBg = [[UIImageView alloc] init];
        UIImage *img = [UIImage imageNamed:@"label_bg"];
        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height/2.0, img.size.width/2.0, img.size.width/2.0, img.size.height/2.0) resizingMode:UIImageResizingModeStretch];
        _accountNameBg.image = img;
    }
    return _accountNameBg;
}
-(UILabel *)accountName{
    if (_accountName == nil) {
        _accountName = [[UILabel alloc] init];
        _accountName.textColor = kColorAuxiliary2;
        _accountName.font = AdaptedFontSize(kFontSize);
    }
    return _accountName;
}

-(UILabel *)addressLabel{
    if (_addressLabel == nil) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.font = AdaptedFontSize(kFontSize);
        _addressLabel.textColor = kColorBlue;
        _addressLabel.text = NSLocalizedString(@"privateKey",@"私钥"); //NSLocalizedString(@"walletAddress", @"钱包地址");
    }
    return _addressLabel;
}
-(UIImageView *)addressBg{
    if (_addressBg == nil) {
        _addressBg = [[UIImageView alloc] init];
        UIImage *img = [UIImage imageNamed:@"label_bg"];
        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height/2.0, img.size.width/2.0, img.size.width/2.0, img.size.height/2.0) resizingMode:UIImageResizingModeStretch];
        _addressBg.image = img;
    }
    return _addressBg;
}
-(UILabel *)address{
    if (_address == nil) {
        _address = [[UILabel alloc] init];
        _address.numberOfLines = 0;
        _address.textColor = kColorAuxiliary2;
        _address.font = AdaptedFontSize(kFontSize);
        _address.lineBreakMode = NSLineBreakByCharWrapping; //避免中间就换行
    }
    return _address;
}
-(UIButton *)addressCopyBtn{
    if (_addressCopyBtn == nil) {
        _addressCopyBtn = [[UIButton alloc] init];
        [_addressCopyBtn setImage:[UIImage imageNamed:@"copy"] forState:UIControlStateNormal];
        [_addressCopyBtn addTarget:self action:@selector(addressCopy:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addressCopyBtn;
}

-(UILabel *)menmonryLabel{
    if (_menmonryLabel == nil) {
        _menmonryLabel = [[UILabel alloc] init];
        _menmonryLabel.text = NSLocalizedString(@"mnemonicWord", @"助记词");
        _menmonryLabel.font = AdaptedFontSize(kFontSize);
        _menmonryLabel.textColor = kColorBlue;
    }
    return _menmonryLabel;
}
-(UIImageView *)menmonryBg{
    if (_menmonryBg == nil) {
        _menmonryBg = [[UIImageView alloc] init];
        UIImage *img = [UIImage imageNamed:@"label_bg"];
        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height/2.0, img.size.width/2.0, img.size.width/2.0, img.size.height/2.0) resizingMode:UIImageResizingModeStretch];
        _menmonryBg.image = img;
    }
    return _menmonryBg;
}
-(UILabel *)menmonry{
    if (_menmonry == nil) {
        _menmonry = [[UILabel alloc] init];
        _menmonry.numberOfLines = 0;
        _menmonry.textColor = kColorAuxiliary2;
        _menmonry.font = AdaptedFontSize(kFontSize);
        _menmonry.lineBreakMode = NSLineBreakByCharWrapping; //避免中间就换行
    }
    return _menmonry;
}
-(UIButton *)menmonryCopy{
    if (_menmonryCopy == nil) {
        _menmonryCopy = [[UIButton alloc] init];
        [_menmonryCopy setImage:[UIImage imageNamed:@"copy"] forState:UIControlStateNormal];
        [_menmonryCopy addTarget:self action:@selector(mnemonicCopy:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _menmonryCopy;
}

-(UIImageView *)tipImg_1{
    if (_tipImg_1 == nil) {
        _tipImg_1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"horn"]];
    }
    return _tipImg_1;
}
-(UILabel *)tipLabel_1{
    if (_tipLabel_1 == nil) {
        _tipLabel_1 = [[UILabel alloc] init];
        _tipLabel_1.font = AdaptedFontSize(14);
        _tipLabel_1.textColor = kColorBlue;
        _tipLabel_1.text = NSLocalizedString(@"backup.tip_1", @"建议抄写或打印私钥后放置在安全地点保存");
        _tipLabel_1.numberOfLines = 0;
    }
    return _tipLabel_1;
}
-(UIImageView *)tipImg_2{
    if (_tipImg_2 == nil) {
        _tipImg_2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"horn"]];
    }
    return _tipImg_2;
}
-(UILabel *)tipLabel_2{
    if (_tipLabel_2 == nil) {
        _tipLabel_2 = [[UILabel alloc] init];
        _tipLabel_2.font = AdaptedFontSize(14);
        _tipLabel_2.textColor = kColorBlue;
        _tipLabel_2.text = NSLocalizedString(@"backup.tip_2", @"请勿通过网络工具传输私钥，");
        _tipLabel_2.numberOfLines = 0;
    }
    return _tipLabel_2;
}
@end
