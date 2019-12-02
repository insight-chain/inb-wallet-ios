//
//  WalletBackupVC.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/15.
//  Copyright © 2019 apple. All rights reserved.
//

#import "WalletBackupVC.h"
#import "TransferResultView.h"

#import "UIImage+QRImage.h"

#define kFontSize 15

#define kBigMargin 20
#define kMidMargin 15
#define kLittleMargin 10

#define kQRImgSize 130

@interface WalletBackupVC ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

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
@property(nonatomic, strong) UIButton *menmonryQRBtn; //私钥二维码

@property(nonatomic, strong) UILabel *qrLabel; //二维码
@property (nonatomic, strong) UIView *qrBg;
@property (nonatomic, strong) UIImageView *qr;
@property(nonatomic, strong) UILabel *qrAddressLabel;
@property (nonatomic, strong) UIButton *qrDownloadBtn; //下载二维码

@property(nonatomic, strong) UIImageView *tipImg_1;
@property(nonatomic, strong) UILabel *tipLabel_1;
@property(nonatomic, strong) UIImageView *tipImg_2;
@property(nonatomic, strong) UILabel *tipLabel_2;

@property(nonatomic, strong) UIButton *addressCopyBtn;
@property(nonatomic, strong) UIButton *privateKeyQRBtn; //私钥二维码


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

    self.scrollView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-kNavigationBarHeight);
    [self.view addSubview:self.scrollView];
    self.contentView = [[UIView alloc] init];
    [self.scrollView addSubview:self.contentView];
    
    [self makeConstraints];
    
    self.accountName.text = self.name;
    self.address.text = self.privateKey;
    self.menmonry.text = self.menmonryKey;
    if ([self.menmonry.text isEqualToString:@""]) {
        self.menmonryCopy.hidden = YES;
        self.menmonryQRBtn.hidden = YES;
        self.menmonryLabel.hidden = YES;
        self.menmonryBg.hidden = YES;
        self.menmonry.hidden = YES;
        
        NSString *entry = [EncryptUtils encryptByAES:self.address.text key:keyEntryQR];
        NSString *deEntry = [EncryptUtils decryptByAES:entry key:keyEntryQR];
        NSDictionary *infoDic = @{@"type":@(1),@"content":entry};
        NSString *jsonStr = [infoDic toJSONString];
        self.qr.image = [UIImage createQRImgae:jsonStr size:kQRImgSize centerImg:nil centerImgSize:20];
        
    }else{
        self.menmonryCopy.hidden = NO;
        self.menmonryQRBtn.hidden = NO;
        
        NSString *entry = [EncryptUtils encryptByAES:self.menmonryKey key:keyEntryQR];
        NSString *deEntry = [EncryptUtils decryptByAES:entry key:keyEntryQR];
        NSDictionary *infoDic = @{@"type":@(2),@"content":entry};
        NSString *jsonStr = [infoDic toJSONString];
        self.qr.image = [UIImage createQRImgae:jsonStr size:kQRImgSize centerImg:nil centerImgSize:20];
        
    }
    
    self.qrAddressLabel.text = [NSString stringWithFormat:@"%@", [App_Delegate.selectAddr add0xIfNeeded]];
    
    [self.contentView layoutIfNeeded];
    self.contentView.frame = CGRectMake(0, 0, KWIDTH, CGRectGetMaxY(self.tipLabel_2.frame)+50);
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.contentView.frame));
    

    
}

-(void)makeConstraints{
   
    [self.contentView addSubview:self.accountNameLabel];
    [self.contentView addSubview:self.accountNameBg];
    [self.contentView addSubview:self.accountName];
    
    [self.contentView addSubview:self.addressLabel];
    [self.contentView addSubview:self.addressBg];
    [self.contentView addSubview:self.address];
    [self.contentView addSubview:self.addressCopyBtn];
    [self.contentView addSubview:self.privateKeyQRBtn];
    
    [self.contentView addSubview:self.menmonryLabel];
    [self.contentView addSubview:self.menmonryBg];
    [self.contentView addSubview:self.menmonry];
    [self.contentView addSubview:self.menmonryCopy];
    [self.contentView addSubview:self.menmonryQRBtn];
    
    [self.contentView addSubview:self.qrBg];
    [self.qrBg addSubview:self.qrLabel];
    [self.qrBg addSubview:self.qr];
    [self.qrBg addSubview:self.qrAddressLabel];
    [self.qrBg addSubview:self.qrDownloadBtn];
    
    UIView *sepView = [[UIView alloc] init];
    sepView.backgroundColor = kColorBackground;
    [self.contentView addSubview:sepView];
    
    [self.contentView addSubview:self.tipImg_1];
    [self.contentView addSubview:self.tipLabel_1];
    [self.contentView addSubview:self.tipImg_2];
    [self.contentView addSubview:self.tipLabel_2];
    
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
        make.bottom.mas_equalTo(self.addressBg.mas_bottom).mas_offset(AdaptedHeight(-5));
        make.right.mas_equalTo(self.addressBg.mas_right).mas_offset(AdaptedWidth(-kLittleMargin-5));
        make.width.height.mas_equalTo(AdaptedWidth(kBigMargin+10));
    }];
    [self.privateKeyQRBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.addressCopyBtn);
        make.width.height.mas_equalTo(self.addressCopyBtn);
        make.right.mas_equalTo(self.addressCopyBtn.mas_left);
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
        make.bottom.mas_equalTo(self.menmonryBg.mas_bottom).mas_offset(AdaptedHeight(-5));
        make.right.mas_equalTo(self.menmonryBg.mas_right).mas_offset(AdaptedWidth(-kLittleMargin-5));
        make.width.height.mas_equalTo(AdaptedWidth(kBigMargin+10));
    }];
    [self.menmonryQRBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.menmonryCopy);
        make.width.height.mas_equalTo(self.menmonryCopy);
        make.right.mas_equalTo(self.menmonryCopy.mas_left);
    }];
    
    
    [self.qrBg mas_remakeConstraints:^(MASConstraintMaker *make) {
        if([self.menmonryKey isEqualToString:@""] || self.menmonryKey == nil){ make.top.mas_equalTo(self.addressBg.mas_bottom).mas_offset(AdaptedHeight(kBigMargin));
        }else{ make.top.mas_equalTo(self.menmonryBg.mas_bottom).mas_offset(AdaptedHeight(kBigMargin));
        }
        make.left.mas_equalTo(AdaptedWidth(kMidMargin));
        make.right.mas_equalTo(AdaptedWidth(-kMidMargin));
        make.height.mas_equalTo(AdaptedHeight(250));
    }];
    [self.qrLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.qrBg.mas_top).mas_offset(AdaptedHeight(5));
        make.centerX.mas_equalTo(self.qrBg.mas_centerX);
    }];
    [self.qr mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.qrLabel.mas_bottom).mas_offset(15);
        make.centerX.mas_equalTo(self.qrBg);
        make.width.height.mas_equalTo(AdaptedHeight(kQRImgSize));
    }];
    [self.qrAddressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.qr);
        make.top.mas_equalTo(self.qr.mas_bottom).mas_offset(10);
        make.width.mas_equalTo(AdaptedHeight(170));
    }];
    [self.qrDownloadBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.qr);
        make.top.mas_equalTo(self.qrAddressLabel.mas_bottom).mas_offset(10);
        make.width.mas_equalTo(140);
        make.height.mas_equalTo(30);
    }];
    
    [sepView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.qrBg.mas_bottom).mas_offset(AdaptedHeight(kBigMargin));
        make.height.mas_equalTo(AdaptedHeight(8));
    }];
    
    [self.tipImg_1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(sepView.mas_bottom).mas_offset(AdaptedHeight(kBigMargin));
        make.left.mas_equalTo(self.contentView).mas_offset(AdaptedWidth(kMidMargin));
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
    
    [MBProgressHUD showMessage:NSLocalizedString(@"wallet.copy.private.success", @"私钥已复制到剪贴板") toView:self.view afterDelay:1.5 animted:YES];
}
//复制助记词
-(void)mnemonicCopy:(UIButton *)sender{
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    board.string = self.menmonryKey;
    [MBProgressHUD showMessage:NSLocalizedString(@"wallet.copy.memonry.success", @"助记词已复制到剪贴板") toView:self.view afterDelay:1.5 animted:YES];
}
//显示私钥二维码
-(void)privateQR:(UIButton *)sender{
    NSString *entry = [EncryptUtils encryptByAES:self.address.text key:keyEntryQR];
    NSString *deEntry = [EncryptUtils decryptByAES:entry key:keyEntryQR];
    NSDictionary *infoDic = @{@"type":@(1),@"content":entry};
    NSString *jsonStr = [infoDic toJSONString];
    [TransferResultView QRViewWithTitle:NSLocalizedString(@"QRCode", @"二维码") value:jsonStr qrTip:NSLocalizedString(@"qrCode.showTip", @"二维码进制保存，截图，仅供用户在安全环境下方便扫描导入钱包")];
}
//显示助记词二维码
-(void)menmonryQR:(UIButton *)sender{
    [TransferResultView QRViewWithTitle:NSLocalizedString(@"QRCode", @"二维码") value:self.menmonry.text qrTip:NSLocalizedString(@"qrCode.showTip", @"二维码进制保存，截图，仅供用户在安全环境下方便扫描导入钱包")];
}
//保存inb秘钥二维码到相册
-(void)saveINBQR{
    self.qrDownloadBtn.hidden = YES;
    [self saveImageFromView:self.qrBg];
    self.qrDownloadBtn.hidden = NO;
}

#pragma mark ----

-(UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
    }
    return _scrollView;
}

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
-(UIButton *)privateKeyQRBtn{
    if (_privateKeyQRBtn == nil) {
        _privateKeyQRBtn = [[UIButton alloc] init];
        [_privateKeyQRBtn setImage:[UIImage imageNamed:@"qr"] forState:UIControlStateNormal];
        [_privateKeyQRBtn addTarget:self action:@selector(privateQR:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _privateKeyQRBtn;
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
-(UIButton *)menmonryQRBtn{
    if (_menmonryQRBtn == nil) {
        _menmonryQRBtn = [[UIButton alloc] init];
        [_menmonryQRBtn setImage:[UIImage imageNamed:@"qr"] forState:UIControlStateNormal];
        [_menmonryQRBtn addTarget:self action:@selector(menmonryQR:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _menmonryQRBtn;
}

-(UILabel *)qrLabel{
    if (_qrLabel == nil) {
           _qrLabel = [[UILabel alloc] init];
           _qrLabel.text = NSLocalizedString(@"qr.unique.inb", @"INB钱包专属二维码");
           _qrLabel.font = AdaptedFontSize(kFontSize);
           _qrLabel.textColor = kColorBlue;
       }
       return _qrLabel;
}
-(UIView *)qrBg{
    if (_qrBg == nil) {
        _qrBg = [[UIView alloc] init];
//        UIImage *img = [UIImage imageNamed:@"label_bg"];
//        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height/2.0, img.size.width/2.0, img.size.width/2.0, img.size.height/2.0) resizingMode:UIImageResizingModeStretch];
//        _qrBg.image = img;
    }
    return _qrBg;
}
-(UIImageView *)qr{
    if (_qr == nil) {
        _qr = [[UIImageView alloc] init];
    }
    return _qr;
}
-(UILabel *)qrAddressLabel{
    if (_qrAddressLabel == nil) {
        _qrAddressLabel = [[UILabel alloc] init];
        _qrAddressLabel.textColor = kColorTitle;
        _qrAddressLabel.font = [UIFont systemFontOfSize:13];
        _qrAddressLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _qrAddressLabel.textAlignment = NSTextAlignmentCenter;
        _qrAddressLabel.numberOfLines = 0;
    }
    return _qrAddressLabel;
}
-(UIButton *)qrDownloadBtn{
    if (_qrDownloadBtn == nil) {
        _qrDownloadBtn = [[UIButton alloc] init];
        [_qrDownloadBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg_blue"] forState:UIControlStateNormal];
        [_qrDownloadBtn setTitle:NSLocalizedString(@"saveQRCode", @"保存二维码") forState:UIControlStateNormal];
        [_qrDownloadBtn addTarget:self action:@selector(saveINBQR) forControlEvents:UIControlEventTouchUpInside];
        _qrDownloadBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _qrDownloadBtn;
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
