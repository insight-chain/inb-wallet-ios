//
//  WalletImportVC.m
//  wallet
//
//  Created by apple on 2019/3/25.
//  Copyright © 2019 apple. All rights reserved.
//

#import "WalletImportVC.h"

#import "WalletCreatedVC.h"
#import "BasicWebViewController.h"

#import "WalletMeta.h"
#import "WalletManager.h"

#import "SliderBar.h"

#define kPadding 20
#define kMidPadding 10

#define policyFont AdaptedFontSize(12)

@interface WalletImportVC ()<UITextViewDelegate,UITextFieldDelegate>

@property(nonatomic, assign) ImportType selectImportType;

@property(nonatomic, strong) UILabel *typeStrLabel; //"私钥"、"公钥"
@property(nonatomic, strong) UIImageView *keyTextBg;//
@property(nonatomic, strong) UITextView *keyTextView;
@property(nonatomic, strong) UITextView *keyPlaceHolder;

@property(nonatomic, strong) UILabel *accountNameLabel; //"身份名称"
@property(nonatomic, strong) UIImageView *accountNameTextBg;//
@property(nonatomic, strong) UITextField *accountName;

@property(nonatomic, strong) UILabel *passwordStrLabel; //"钱包密码"
@property(nonatomic, strong) UIImageView *passwordBg;
@property(nonatomic, strong) UITextField *password;
@property(nonatomic, strong) UIButton *eyeBtn;

@property(nonatomic, strong) UILabel *tipPasswordStrLabel; //“密码提示信息”
@property(nonatomic, strong) UIImageView *tipPasswordBg;
@property(nonatomic, strong) UITextField *tipPassword;
@property(nonatomic, strong) UIButton *tipPasswordCancel;

@property(nonatomic, strong) UITextView *agreePolicy; //隐私政策
@property(nonatomic, assign) BOOL isAgreePolicy; //是否同意隐私政策

@property(nonatomic, strong) UIButton *importBtn; //导入钱包
@property(nonatomic, strong) UIButton *createBtn; //创建钱包

@property(nonatomic, strong) SliderBar *sliderBar;

@end

@implementation WalletImportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColorBackground;
    
    /** View被导航栏遮挡问题的解决 **/
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
    self.sliderBar  = [[SliderBar alloc] initWithFrame:CGRectMake(0, 0, 0, kNavigationBarHeight)];
    self.sliderBar.itemsTitle = @[@"私钥", @"助记词"];
    self.sliderBar.itemTitleColor = kColorWithRGBA(1, 1, 1, 0.6);
    self.sliderBar.itemTitleFont  = AdaptedBoldFontSize(16);
    self.sliderBar.itemTitleSelectedColor = kColorWithRGBA(1, 1, 1, 1);
    self.sliderBar.itemTitleSelectedFont = AdaptedBoldFontSize(16);
    self.sliderBar.selectedIndex = 0;
    self.selectImportType = ImportType_private; //默认私钥导入
    
    __weak typeof(self) tmpSelf = self;
    self.sliderBar.itemClick = ^(NSInteger index) {
        if (index == 0) {
            tmpSelf.selectImportType = ImportType_private;
        }else{
            tmpSelf.selectImportType = ImportType_mnemonic;
        }
        
    };
    
    [self initNavition];
    
    self.typeStrLabel.text = NSLocalizedString(@"privateKey", @"私钥");
    
    [self makeConstraints];
    
    self.isAgreePolicy = YES; //默认同意
    [self policyIsAgree:self.isAgreePolicy];
    
    self.password.secureTextEntry = YES;
    self.tipPasswordCancel.hidden = YES;
}

-(void)initNavition{
    self.navigationItem.titleView = self.sliderBar;
}

-(void)makeConstraints{
    [self.view addSubview:self.typeStrLabel];
    [self.view addSubview:self.keyTextBg];
    [self.view addSubview:self.keyTextView];
    [self.view addSubview:self.keyPlaceHolder];
    
    [self.view addSubview:self.accountNameLabel];
    [self.view addSubview:self.accountNameTextBg];
    [self.view addSubview:self.accountName];
    
    [self.view addSubview:self.passwordStrLabel];
    [self.view addSubview:self.passwordBg];
    [self.view addSubview:self.password];
    [self.view addSubview:self.eyeBtn];
    
    [self.view addSubview:self.tipPasswordStrLabel];
    [self.view addSubview:self.tipPasswordBg];
    [self.view addSubview:self.tipPassword];
    [self.view addSubview:self.tipPasswordCancel];
    
    [self.view addSubview:self.agreePolicy];
    
    [self.view addSubview:self.importBtn];
    [self.view addSubview:self.createBtn];
    
    [self.typeStrLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(AdaptedHeight(kPadding));
    }];
    [self.keyTextBg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.typeStrLabel.mas_bottom).mas_offset(AdaptedHeight(kMidPadding));
        make.left.mas_equalTo(AdaptedWidth(15));
        make.right.mas_equalTo(AdaptedWidth(-15));
        make.height.mas_equalTo(self.keyTextBg.mas_width).multipliedBy(100.0/345.0);
    }];
    [self.keyTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.keyTextBg.mas_top).mas_offset(AdaptedHeight(5));
        make.left.mas_equalTo(self.keyTextBg.mas_left).mas_offset(AdaptedWidth(10));
        make.right.mas_equalTo(self.keyTextBg.mas_right).mas_offset(AdaptedWidth(-15));
        make.bottom.mas_equalTo(self.keyTextBg.mas_bottom).mas_offset(AdaptedHeight(-15));
    }];
    [self.keyPlaceHolder mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.mas_equalTo(self.keyTextView);
        make.height.mas_equalTo(25);
    }];
    
    [self.accountNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeStrLabel);
        make.top.mas_equalTo(self.keyTextBg.mas_bottom).mas_offset(AdaptedHeight(kPadding));
    }];
    [self.accountNameTextBg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.keyTextBg);
        make.top.mas_equalTo(self.accountNameLabel.mas_bottom).mas_offset(AdaptedHeight(kMidPadding));
        make.height.mas_equalTo(self.accountNameTextBg.mas_width).multipliedBy(45.0/345);
    }];
    [self.accountName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.accountNameTextBg.mas_centerY);
        make.left.mas_equalTo(self.accountNameTextBg.mas_left).mas_offset(AdaptedWidth(10));
        make.right.mas_equalTo(-10);
    }];
    
    [self.passwordStrLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeStrLabel);
        make.top.mas_equalTo(self.accountNameTextBg.mas_bottom).mas_offset(AdaptedHeight(kPadding));
    }];
    [self.passwordBg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.keyTextBg);
        make.top.mas_equalTo(self.passwordStrLabel.mas_bottom).mas_offset(AdaptedHeight(kMidPadding));
        make.height.mas_equalTo(self.passwordBg.mas_width).multipliedBy(45.0/345);
    }];
    [self.password mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.passwordBg.mas_centerY);
        make.left.mas_equalTo(self.passwordBg.mas_left).mas_offset(AdaptedWidth(10));
        make.right.mas_equalTo(self.eyeBtn.mas_left).mas_offset(-10);
    }];
    [self.eyeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.password.mas_centerY);
        make.right.mas_equalTo(self.passwordBg.mas_right).mas_offset(AdaptedWidth(-10));
        make.width.height.mas_equalTo(AdaptedWidth(20));
    }];
    [self.tipPasswordStrLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.passwordStrLabel);
        make.top.mas_equalTo(self.passwordBg.mas_bottom).mas_offset(AdaptedHeight(kPadding));
    }];
    [self.tipPasswordBg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.passwordBg);
        make.top.mas_equalTo(self.tipPasswordStrLabel.mas_bottom).mas_offset(AdaptedHeight(kMidPadding));
        make.height.mas_equalTo(self.passwordBg);
    }];
    [self.tipPassword mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.tipPasswordBg);
        make.left.mas_equalTo(self.tipPasswordBg.mas_left).mas_offset(AdaptedWidth(kMidPadding));
        make.right.mas_equalTo(self.tipPasswordCancel.mas_left).mas_offset(-10);
    }];
    [self.tipPasswordCancel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.tipPassword);
        make.right.mas_equalTo(self.tipPasswordBg.mas_right).mas_offset(AdaptedWidth(-10));
        make.height.width.mas_equalTo(self.eyeBtn);
    }];
    
    [self.agreePolicy mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.tipPasswordBg.mas_bottom).mas_offset(AdaptedHeight(20));
        
    }];
    [self.importBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.agreePolicy.mas_bottom).mas_offset(AdaptedHeight(15));
        make.width.mas_equalTo(AdaptedWidth(195));
        make.height.mas_equalTo(AdaptedHeight(40));
    }];
    [self.createBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.importBtn);
        make.width.height.mas_equalTo(self.importBtn);
        make.top.mas_equalTo(self.importBtn.mas_bottom).mas_offset(AdaptedHeight(5));
    }];
}

-(void)policyIsAgree:(BOOL)agree{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@" 我已仔细阅读并同意服务及隐私条款"];
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"policy://"
                             range:[[attributedString string] rangeOfString:@"同意服务及隐私条款"]];
    UIImage *image = [UIImage imageNamed:agree == YES ? @"checkbox_yes" : @"checkbox_no"];
    CGSize size = CGSizeMake(image.size.width + 2, image.size.height + 2);
    UIGraphicsBeginImageContextWithOptions(size, false, 0);
    [image drawInRect:CGRectMake(0, 2, image.size.width, image.size.height)];
    UIImage *resizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = resizeImage;
    NSMutableAttributedString *imageString = (id) [NSMutableAttributedString attributedStringWithAttachment:textAttachment];
    
    [imageString addAttribute:NSLinkAttributeName
                        value:@"checkbox://"
                        range:NSMakeRange(0, imageString.length)];
    [attributedString insertAttributedString:imageString atIndex:0];
    [attributedString addAttribute:NSFontAttributeName value:policyFont range:NSMakeRange(0, attributedString.length)];
    [attributedString addAttribute:NSBaselineOffsetAttributeName value:@(0.36*-10) range:NSMakeRange(0, imageString.length)];//基线偏移比例 0.16、0.36、0.66,
    self.agreePolicy.attributedText = attributedString;
    self.agreePolicy.linkTextAttributes = @{NSForegroundColorAttributeName: [UIColor blueColor],
//                                     NSUnderlineColorAttributeName: nil, //超链接点击时背景色
                                     NSUnderlineStyleAttributeName: @(NSUnderlinePatternSolid)};
}

-(void)changeImportType:(ImportType)type{
    if (ImportType_private == type) {
        self.typeStrLabel.text = NSLocalizedString(@"privateKey", @"私钥");
        self.keyPlaceHolder.text = NSLocalizedString(@"importWallet.privatekey.placeholder", @"请输入私钥");
    }else if (ImportType_mnemonic == type){
        self.typeStrLabel.text = NSLocalizedString(@"mnemonicWord", @"助记词");
        self.keyPlaceHolder.text = NSLocalizedString(@"importWallet.mnemonic.placeholder", @"请输入助记词");
    }
}

#pragma mark ---- Action
//显示、隐藏钱包密码
-(void)passwordHideAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.password.secureTextEntry = !sender.selected;
}
//取消密码提示文案
-(void)cancelTipPassword:(UIButton *)sender{
    self.tipPassword.text = @"";
}
//导入钱包
-(void)importAction:(UIButton *)sender{
    
    if(self.password.text.length < 6){
        [MBProgressHUD showMessage:NSLocalizedString(@"password.setting.error.tooshort", @"设置密码长度小于5") toView:self.view afterDelay:2 animted:YES];
        return;
    }else if(self.password.text.length > 16){
        [MBProgressHUD showMessage:NSLocalizedString(@"password.setting.error.toolong", @"设置密码长度大于16") toView:self.view afterDelay:2 animted:YES];
        return;
    }
    
    BasicWallet *wallet;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (self.selectImportType == ImportType_private) {
        WalletMeta *metadata = [[WalletMeta alloc] initWith:source_privateKey];
        metadata.segWit = @"P2WPKH";
        metadata.name = self.accountName.text;
        metadata.passwordHint = self.tipPassword.text;
        metadata.chainType = chain_eth;
        metadata.chain = [WalletMeta getChainStr:chain_eth];
        wallet = [WalletManager importFromPrivateKey:self.keyTextView.text encryptedBy:self.password.text metadata:metadata accountName:@"import"];//[WalletManager importFromMnemonic:mnemonic metadata:metadata encryptBy:tmpSelf.password.text path:@"m/44'/60'/0'/0/0"];
        
    }else{
        WalletMeta *metadata = [[WalletMeta alloc] initWith:source_mnemonic];
        metadata.segWit = @"P2WPKH";
        metadata.name = self.accountName.text;
        metadata.passwordHint = self.tipPassword.text;
        metadata.chainType = chain_eth;
        metadata.chain = [WalletMeta getChainStr:chain_eth];
        wallet = [WalletManager importFromMnemonic:self.keyTextView.text metadata:metadata encryptBy:self.password.text path:@"m/49'/0'/0'"];//m/44'/60'/0'/0/0
        
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [NotificationCenter postNotificationName:NOTI_ADD_WALLET object:wallet];
    [self.navigationController popViewControllerAnimated:YES];
}
//创建钱包
-(void)createAction:(UIButton *)sender{
    WalletCreatedVC *createVC = [[WalletCreatedVC alloc] init];
    createVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:createVC animated:YES];
}

#pragma mark ----
-(UILabel *)typeStrLabel{
    if (_typeStrLabel == nil) {
        _typeStrLabel = [[UILabel alloc] init];
        _typeStrLabel.font = AdaptedFontSize(15);
        _typeStrLabel.textColor = kColorTitle;
    }
    return _typeStrLabel;
}
-(UIImageView *)keyTextBg{
    if (_keyTextBg == nil) {
        _keyTextBg = [[UIImageView alloc] init];
        UIImage *img = [UIImage imageNamed:@"textView_bg"];
        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height/2.0, img.size.width/2.0, img.size.height/2.0, img.size.width/2.0) resizingMode:UIImageResizingModeStretch];
        _keyTextBg.image = img;
    }
    return _keyTextBg;
}
-(UITextView *)keyTextView{
    if (_keyTextView == nil) {
        _keyTextView = [[UITextView alloc] init];
        _keyTextView.textColor = kColorTitle;
        _keyTextView.font = AdaptedFontSize(15);
        _keyTextView.delegate = self;
    }
    return _keyTextView;
}
-(UITextView *)keyPlaceHolder{
    if (_keyPlaceHolder == nil) {
        _keyPlaceHolder = [[UITextView alloc] init];
        _keyPlaceHolder.textColor = kColorAuxiliary2;
        _keyPlaceHolder.font = AdaptedFontSize(15);
        _keyPlaceHolder.editable = NO; //不可编辑
        _keyPlaceHolder.backgroundColor = [UIColor clearColor];
    }
    return _keyPlaceHolder;
}

-(UILabel *)accountNameLabel{
    if (_accountNameLabel == nil) {
        _accountNameLabel = [[UILabel alloc] init];
        _accountNameLabel.font = AdaptedFontSize(15);
        _accountNameLabel.textColor = kColorTitle;
        _accountNameLabel.text = NSLocalizedString(@"wallet.accountName", @"身份名称");
    }
    return _accountNameLabel;
}
-(UIImageView *)accountNameTextBg{
    if (_accountNameTextBg == nil) {
        _accountNameTextBg = [[UIImageView alloc] init];
        UIImage *img = [UIImage imageNamed:@"textField_bg"];
        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height/2.0, img.size.width/2.0, img.size.height/2.0, img.size.width/2.0) resizingMode:UIImageResizingModeStretch];
        _accountNameTextBg.image = img;
    }
    return _accountNameTextBg;
}
-(UITextField *)accountName{
    if (_accountName == nil) {
        _accountName = [[UITextField alloc] init];
        _accountName.textColor = kColorTitle;
        _accountName.font = AdaptedFontSize(15);
        _accountName.placeholder = NSLocalizedString(@"placeholder.accountName", @"设置一个身份名称");
    }
    return _accountName;
}

-(UILabel *)passwordStrLabel{
    if (_passwordStrLabel == nil) {
        _passwordStrLabel = [[UILabel alloc] init];
        _passwordStrLabel.text = NSLocalizedString(@"walletPassword", @"钱包密码");
        _passwordStrLabel.font = AdaptedFontSize(15);
        _passwordStrLabel.textColor = kColorTitle;
    }
    return _passwordStrLabel;
}
-(UIImageView *)passwordBg{
    if (_passwordBg == nil) {
        _passwordBg = [[UIImageView alloc] init];
        UIImage *img = [UIImage imageNamed:@"textField_bg"];
        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height/2.0, img.size.width/2.0, img.size.height/2.0, img.size.width/2.0) resizingMode:UIImageResizingModeStretch];
        _passwordBg.image = img;
    }
    return _passwordBg;
}
-(UITextField *)password{
    if (_password == nil) {
        _password = [[UITextField alloc] init];
        _password.font = AdaptedFontSize(15);
        _password.textColor = kColorTitle;
        _password.placeholder = NSLocalizedString(@"walletPassword.placeholder", @"6-15位由大小字母、数字或符号组成");
    }
    return _password;
}

-(UIButton *)eyeBtn{
    if (_eyeBtn == nil) {
        _eyeBtn = [[UIButton alloc] init];
        [_eyeBtn setImage:[UIImage imageNamed:@"eye_close_blue"] forState:UIControlStateNormal];
        [_eyeBtn setImage:[UIImage imageNamed:@"eye_open_blue"] forState:UIControlStateSelected];
        [_eyeBtn addTarget:self action:@selector(passwordHideAction:)
          forControlEvents:UIControlEventTouchUpInside];
    }
    return _eyeBtn;
}
-(UILabel *)tipPasswordStrLabel{
    if (_tipPasswordStrLabel == nil) {
        _tipPasswordStrLabel = [[UILabel alloc] init];
        _tipPasswordStrLabel.font = AdaptedFontSize(15);
        _tipPasswordStrLabel.textColor = kColorTitle;
        _tipPasswordStrLabel.text = NSLocalizedString(@"passwordTipMessage", @"密码提示信息");
    }
    return _tipPasswordStrLabel;
}
-(UIImageView *)tipPasswordBg{
    if (_tipPasswordBg == nil) {
        _tipPasswordBg = [[UIImageView alloc] init];
        UIImage *img = [UIImage imageNamed:@"textField_bg"];
        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height/2.0, img.size.width/2.0, img.size.height/2.0, img.size.width/2.0) resizingMode:UIImageResizingModeStretch];
        _tipPasswordBg.image = img;
    }
    return _tipPasswordBg;
}
-(UITextField *)tipPassword{
    if (_tipPassword == nil) {
        _tipPassword = [[UITextField alloc] init];
        _tipPassword.font = AdaptedFontSize(15);
        _tipPassword.textColor = kColorTitle;
        _tipPassword.placeholder = NSLocalizedString(@"passwordTipMessage.placeholder", @"可不填");
        _tipPassword.delegate = self;
    }
    return _tipPassword;
}
- (UIButton *)tipPasswordCancel{
    if (_tipPasswordCancel == nil) {
        _tipPasswordCancel = [[UIButton alloc] init];
        [_tipPasswordCancel setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        [_tipPasswordCancel addTarget:self action:@selector(cancelTipPassword:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tipPasswordCancel;
}
-(UIButton *)importBtn{
    if (_importBtn == nil) {
        _importBtn = [[UIButton alloc] init];
        [_importBtn setTitle:NSLocalizedString(@"importWallet", @"导入钱包") forState:UIControlStateNormal];
        UIImage *img = [UIImage imageNamed:@"btn_bg_blue"];
        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height/2.0, img.size.width/2.0, img.size.height/2.0, img.size.width/2.0) resizingMode:UIImageResizingModeStretch];
        [_importBtn setBackgroundImage:img forState:UIControlStateNormal];
        [_importBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _importBtn.titleLabel.font = AdaptedFontSize(15);
        [_importBtn addTarget:self action:@selector(importAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _importBtn;
}
-(UIButton *)createBtn{
    if (_createBtn == nil) {
        _createBtn = [[UIButton alloc] init];
        [_createBtn setTitle:NSLocalizedString(@"createWallet", @"创建钱包") forState:UIControlStateNormal];
        _createBtn.backgroundColor = [UIColor clearColor];
        [_createBtn setTitleColor:kColorBlue forState:UIControlStateNormal];
        _createBtn.titleLabel.font = AdaptedFontSize(15);
        [_createBtn addTarget:self action:@selector(createAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _createBtn;
}
-(UITextView *)agreePolicy{
    if (_agreePolicy == nil) {
        _agreePolicy = [[UITextView alloc] init];
        _agreePolicy.backgroundColor = [UIColor clearColor];
        _agreePolicy.font = policyFont;
        _agreePolicy.delegate = self;
        _agreePolicy.editable = NO; //禁止编辑
        _agreePolicy.scrollEnabled = NO;
    }
    return _agreePolicy;
}

-(void)setSelectImportType:(ImportType)selectImportType{
    _selectImportType = selectImportType;
    [self changeImportType:_selectImportType];
}

#pragma mark ---- UITextFeildDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.tipPassword) {
        if(![string isEqualToString:@""]){
            self.tipPasswordCancel.hidden = NO;
        }
        if([string isEqualToString:@""] && (range.location == 0 && range.length>=1)){ //输入的是退格键 && 表示输入的是第一个字符
            self.tipPasswordCancel.hidden = YES;
        }
    }
    
    return YES;
}
#pragma mark ---- UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if(![text isEqualToString:@""]){
        self.keyPlaceHolder.hidden = YES;
    }
    if([text isEqualToString:@""] && (range.location == 0 && range.length>=1)){ //输入的是退格键 && 表示输入的是第一个字符
        self.keyPlaceHolder.hidden = NO;
        
    }
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction{
    if ([[URL scheme] isEqualToString:@"policy"]) {
        NSLog(@"同意阅读");
        BasicWebViewController *webVC = [[BasicWebViewController alloc] init];
        webVC.urlStr = @"http://www.baidu.com";
        [self.navigationController pushViewController:webVC animated:YES];
        return NO;
    }else if ([[URL scheme] isEqualToString:@"checkbox"]){
        self.isAgreePolicy = !self.isAgreePolicy;
        [self policyIsAgree:self.isAgreePolicy];
        return NO;
    }
    return YES;
}
@end
