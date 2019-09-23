//
//  NodeRegisterVC.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/7/17.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "NodeRegisterVC.h"

#import "PasswordInputView.h"
#import "NetworkUtil.h"
#import "WalletManager.h"

#import "CountryCodeView.h"

@interface NodeRegisterVC()

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIView *scrollContentView;

@property(nonatomic, strong) UILabel *headImgStr; //设置头像
@property(nonatomic, strong) UITextField *headImg;

@property(nonatomic, strong) UILabel *nameStr; //头像
@property(nonatomic, strong) UITextField *name;
@property(nonatomic, strong) UIView *sepView_1; // 分割线

@property(nonatomic, strong) UILabel *introStr; //节点介绍
@property(nonatomic, strong) UIImageView *introBg;
@property(nonatomic, strong) UITextView *intro;

@property(nonatomic, strong) UILabel *otherInfoStr; //其他信息
@property(nonatomic, strong) InfoView *ipInfo;
@property(nonatomic, strong) InfoView *portInfo;
@property(nonatomic, strong) InfoView *telegraphInfo;
@property(nonatomic, strong) InfoView *wechatInfo;
@property(nonatomic, strong) InfoView *facebookInfo;
@property(nonatomic, strong) InfoView *twitterInfo;
@property(nonatomic, strong) InfoView *githubInfo;
@property(nonatomic, strong) InfoView *countryInfo;

@property(nonatomic, strong) CountryCodeView *countryView; //国家选择列表

@property(nonatomic, strong) UIButton *submitBtn;

@end

@implementation NodeRegisterVC

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = kColorBackground;
    
    self.self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.scrollView];
    
    self.scrollContentView = [[UIView alloc] init];
    [self.scrollView addSubview:self.scrollContentView];
    
    [self makeConstraints];
    
    [self.scrollContentView layoutIfNeeded];
    self.scrollContentView.frame = CGRectMake(0, 0, KWIDTH, CGRectGetMaxY(self.submitBtn.frame)+5);
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.scrollContentView.frame));
    [self getCountry];
}


-(void)getCountry{
    NSLocale *locale = [NSLocale currentLocale];
    NSArray *countryArray = [NSLocale ISOCountryCodes];
    NSMutableDictionary *objectDic = [[NSMutableDictionary alloc] init];
    for (NSString *countryCode in countryArray)
    {
        NSString *displayNameString = [locale displayNameForKey:NSLocaleCountryCode value:countryCode];
        [objectDic setObject:displayNameString forKey:countryCode];
    }
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:objectDic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];//[objectDic jsonStringEncoded];
    
    NSLog(@"json：%@",jsonString);
    
    NSLog(@"%@",objectDic);
}


-(void)makeConstraints{
    
    [self.scrollContentView addSubview:self.headImgStr];
    [self.scrollContentView addSubview:self.headImg];
    
    [self.scrollContentView addSubview:self.nameStr];
    [self.scrollContentView addSubview:self.name];
    [self.scrollContentView addSubview:self.sepView_1];
    
    [self.scrollContentView addSubview:self.introStr];
    [self.scrollContentView addSubview:self.introBg];
    [self.scrollContentView addSubview:self.intro];

    
    [self.scrollContentView addSubview:self.otherInfoStr];
    [self.scrollContentView addSubview:self.ipInfo];
    [self.scrollContentView addSubview:self.portInfo];
    [self.scrollContentView addSubview:self.telegraphInfo];
    [self.scrollContentView addSubview:self.wechatInfo];
    [self.scrollContentView addSubview:self.facebookInfo];
    [self.scrollContentView addSubview:self.twitterInfo];
    [self.scrollContentView addSubview:self.githubInfo];
    [self.scrollContentView addSubview:self.countryInfo];
    
    [self.scrollContentView addSubview:self.submitBtn];
    
    [self.headImgStr mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(20);
    }];
    [self.headImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headImgStr.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(45);
    }];
    
    [self.nameStr mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headImg.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(15);
    }];
    [self.name mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameStr.mas_bottom).mas_offset(10);
        make.left.right.mas_equalTo(self.nameStr);
        make.height.mas_equalTo(45);
    }];

    [self.introStr mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.name.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(self.nameStr);
    }];
    [self.introBg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.introStr.mas_bottom).mas_offset(10);
        make.left.right.mas_equalTo(self.name);
        make.height.mas_equalTo(150);
    }];
    [self.intro mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.introBg.mas_top).mas_equalTo(5);
        make.left.mas_equalTo(self.introBg.mas_left).mas_equalTo(5);
        make.right.mas_equalTo(self.introBg.mas_right).mas_equalTo(-5);
        make.bottom.mas_equalTo(self.introBg.mas_bottom).mas_equalTo(-5);
    }];
    
    [self.otherInfoStr mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.introBg.mas_bottom).mas_offset(15);
        make.left.right.mas_equalTo(self.introStr);
    }];
    [self.ipInfo mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.otherInfoStr.mas_bottom).mas_offset(20);
        make.left.right.mas_equalTo(self.name);
        make.height.mas_equalTo(45);
    }];
    [self.portInfo mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.ipInfo.mas_bottom).mas_offset(15);
        make.left.right.mas_equalTo(self.ipInfo);
        make.height.mas_equalTo(self.ipInfo);
    }];
    [self.telegraphInfo mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.portInfo.mas_bottom).mas_offset(15);
        make.left.right.height.mas_equalTo(self.portInfo);
    }];
    [self.wechatInfo mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.telegraphInfo.mas_bottom).mas_offset(15);
        make.left.right.height.mas_equalTo(self.telegraphInfo);
    }];
    [self.facebookInfo mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.wechatInfo.mas_bottom).mas_offset(15);
        make.left.right.height.mas_equalTo(self.wechatInfo);
    }];
    [self.twitterInfo mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.facebookInfo.mas_bottom).mas_offset(15);
        make.left.right.height.mas_equalTo(self.facebookInfo);
    }];
    [self.githubInfo mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.twitterInfo.mas_bottom).mas_offset(15);
        make.left.right.height.mas_equalTo(self.twitterInfo);
    }];
    [self.countryInfo mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.githubInfo.mas_bottom).mas_offset(15);
        make.left.right.height.mas_equalTo(self.twitterInfo);
    }];
    [self.submitBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.countryInfo.mas_bottom).mas_offset(30);
        make.centerX.mas_equalTo(self.scrollContentView.mas_centerX);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark ---- UIButton Action
//注册节点
-(void)submitAction:(UIButton *)sender{
    [self registerToNode];
}
//选择国家
-(void)countrySelect:(UIButton *)sender{
    if(self.countryView == nil){
        self.countryView = [[CountryCodeView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, KHEIGHT)];
        self.countryView.selectCountry = ^(NSString * _Nullable countryName, NSString * _Nonnull countryCode) {
            NSLog(@"Name:%@---Code:%@", countryName, countryCode);
        };
    }
    [App_Delegate.window addSubview:self.countryView];
}
#pragma mark ---- function
//注册及节点
-(void)registerToNode{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSString *ip = self.ipInfo.info.text;
    NSString *port = self.portInfo.info.text;
    NSString *name = self.name.text;
    NSString *country = @"China";
    NSString *city = @"111111111";
    NSString *headerImgStr = @"www.ima1112222ge.com";
    NSString *homepageUrl = @"www.baid222u.com"; //主页
    NSString *email = @"ghyin22sight@insig222ht.io";
    NSString *attributeData = [NSString stringWithFormat:@"name/lgggg-age/200-jobs/bug-intro/%@",self.intro.text];
    
    NSString *nodeID = @"8aa5fc69c92bb3e8acb71b0b42f2e0bfaf4b642a4a38b0efaf2d1270880ea4a187ea16d3811436833f05a08a512cddce920f0a988b75527548bb75d9628fa503";
    // nodeID~ip~port~name~country(nation)~city~imageURL~website~email~data(key1/value1-key2/value2....)
    NSString *dataStr = [NSString stringWithFormat:@"%@~%@~%@~%@~%@~%@~%@~%@~%@~%@", nodeID, ip, port, name, country, city, headerImgStr, homepageUrl, email, attributeData];
    
    [PasswordInputView showPasswordInputWithConfirmClock:^(NSString * _Nonnull password) {
        __block __weak typeof(self) tmpSelf = self;
        [MBProgressHUD showHUDAddedTo:tmpSelf.view animated:YES];
        
        [NetworkUtil rpc_requetWithURL:delegate.rpcHost params:@{@"jsonrpc":@"2.0",
                                                                 @"method":nonce_MethodName,
                                                                 @"params":@[[self.wallet.address add0xIfNeeded],@"latest"],@"id":@(1)}
                            completion:^(id  _Nullable responseObject, NSError * _Nullable error) {
                                if (error) {
                                    [MBProgressHUD hideHUDForView:tmpSelf.view animated:YES];
                                    [MBProgressHUD showMessage:NSLocalizedString(@"修改节点失败", @"修改节点失败") toView:tmpSelf.view afterDelay:0.3 animted:NO];
                                    return ;
                                }
                                NSDictionary *dic = (NSDictionary *)responseObject;
                                NSDecimalNumber *nonce = [dic[@"result"] decimalNumberFromHexString];
                                @try{
                                    TransactionSignedResult *signResult = [WalletManager ethSignTransactionWithWalletID:self.wallet.walletID nonce:[nonce stringValue] txType:TxType_nodeRegister gasPrice:@"200000" gasLimit:@"21000" to:[self.wallet.address add0xIfNeeded] value:@"0" data:[dataStr hexString] password:password chainID:kChainID];
                                    [NetworkUtil rpc_requetWithURL:delegate.rpcHost
                                                            params:@{@"jsonrpc":@"2.0",
                                                                     @"method":sendTran_MethodName,
                                                                     @"params":@[[signResult.signedTx add0xIfNeeded]],
                                                                     @"id":@(1)}
                                                        completion:^(id  _Nullable responseObject, NSError * _Nullable error) {
                                                            [MBProgressHUD hideHUDForView:tmpSelf.view animated:YES];
                                                            
                                                            if (error) {
                                                                [MBProgressHUD showMessage:NSLocalizedString(@"修改节点失败", @"修改节点失败") toView:tmpSelf.view afterDelay:0.3 animted:NO];
                                                                return ;
                                                            }
                                                            NSLog(@"%@---%@",[responseObject  class], responseObject);
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                [MBProgressHUD showMessage:NSLocalizedString(@"修改节点成功", @"修改节点成功") toView:tmpSelf.view afterDelay:0.3 animted:NO];
                                                                [NotificationCenter postNotificationName:NOTI_BALANCE_CHANGE object:nil];
                                                            });
                                                        }];
                                }@catch (NSException *exception) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [MBProgressHUD hideHUDForView:tmpSelf.view animated:YES];
                                        [MBProgressHUD showMessage:@"密码错误" toView:tmpSelf.view afterDelay:0.5 animted:YES];
                                    });
                                    
                                } @finally {
                                    
                                }
                            }];
        
        
        
    }];
    
}

#pragma mark ----
-(void)setNode:(Node *)node{
    _node = node;
    self.name.text = _node.name;
    self.intro.text = _node.intro;
    
    self.ipInfo.info.text = _node.host;
    self.portInfo.info.text = _node.port;
    self.intro.text = _node.intro;
}


-(UILabel *)headImgStr{
    if(_headImgStr == nil){
        _headImgStr = [[UILabel alloc] init];
        _headImgStr.font = AdaptedFontSize(15);
        _headImgStr.textColor = kColorTitle;
        _headImgStr.text = @"设置头像";
    }
    return _headImgStr;
}
-(UITextField *)headImg{
    if(_headImg == nil){
        _headImg = [[UITextField alloc] init];
        _headImg.background = [UIImage imageNamed:@"textField_bg"];
        _headImg.textColor = kColorTitle;
        _headImg.placeholder = @"请输入头像图片的URL地址";
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 35)];
        _headImg.leftView = leftView;
        _headImg.leftViewMode = UITextFieldViewModeAlways;
        
    }
    return _headImg;
}
-(UILabel *)nameStr{
    if (_nameStr == nil) {
        _nameStr = [[UILabel alloc] init];
        _nameStr.font = AdaptedFontSize(15);
        _nameStr.textColor = kColorTitle;
        _nameStr.text = @"节点名称";
    }
    return _nameStr;
}
-(UITextField *)name{
    if (_name == nil) {
        
        _name = [[UITextField alloc] init];
        _name.background = [UIImage imageNamed:@"textField_bg"];
        _name.textColor = kColorTitle;
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 35)];
        _name.leftView = leftView;
        _name.leftViewMode = UITextFieldViewModeAlways;
        
        _name.font = AdaptedFontSize(15);
        _name.backgroundColor = [UIColor whiteColor];
        _name.placeholder = @"请输入节点名称";
    }
    return _name;
}
-(UIView *)sepView_1{
    if (_sepView_1 == nil) {
        _sepView_1 = [[UIView alloc] init];
        _sepView_1.backgroundColor = kColorSeparate;
    }
    return _sepView_1;
}

-(UILabel *)introStr{
    if (_introStr == nil) {
        _introStr = [[UILabel alloc] init];
        _introStr.font = AdaptedFontSize(15);
        _introStr.textColor = kColorTitle;
        _introStr.text = @"节点介绍";
    }
    return _introStr;
}
-(UIImageView *)introBg{
    if (_introBg == nil) {
        _introBg = [[UIImageView alloc] init];
        UIImage *img = [UIImage imageNamed:@"textView_bg"];
        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height/2.0, img.size.width/2.0, img.size.height/2.0, img.size.width/2.0) resizingMode:UIImageResizingModeStretch];
        _introBg.image = img;
    }
    return _introBg;
}
-(UITextView *)intro{
    if (_intro == nil) {
        _intro = [[UITextView alloc] init];
        
    }
    return _intro;
}

-(UILabel *)otherInfoStr{
    if (_otherInfoStr == nil) {
        _otherInfoStr = [[UILabel alloc] init];
        _otherInfoStr.font = AdaptedFontSize(15);
        _otherInfoStr.textColor = kColorTitle;
        _otherInfoStr.text = @"选填信息";
    }
    return _otherInfoStr;
}

-(InfoView *)ipInfo{
    if(_ipInfo == nil){
        _ipInfo = [[InfoView alloc] init];
        _ipInfo.title.text = @"节点IP";
        _ipInfo.backgroundColor = [UIColor clearColor];
    }
    return _ipInfo;
}
-(InfoView *)portInfo{
    if(_portInfo == nil){
        _portInfo = [[InfoView alloc] init];
        _portInfo.title.text = @"端口号";
        _portInfo.backgroundColor = [UIColor clearColor];
    }
    return _portInfo;
}

-(InfoView *)telegraphInfo{
    if (_telegraphInfo == nil) {
        _telegraphInfo = [[InfoView alloc] init];
        _telegraphInfo.title.text = @"电报";
    }
    return _telegraphInfo;
}
-(InfoView *)wechatInfo{
    if (_wechatInfo == nil) {
        _wechatInfo = [[InfoView alloc] init];
        _wechatInfo.title.text = @"微信";
    }
    return _wechatInfo;
}
-(InfoView *)facebookInfo{
    if (_facebookInfo == nil) {
        _facebookInfo = [[InfoView alloc] init];
        _facebookInfo.title.text = @"facebook";
    }
    return _facebookInfo;
}
-(InfoView *)twitterInfo{
    if (_twitterInfo == nil) {
        _twitterInfo = [[InfoView alloc] init];
        _twitterInfo.title.text = @"twitter";
    }
    return _twitterInfo;
}
-(InfoView *)githubInfo{
    if (_githubInfo == nil) {
        _githubInfo = [[InfoView alloc] init];
        _githubInfo.title.text = @"github";

    }
    return _githubInfo;
}

-(InfoView *)countryInfo{
    if(_countryInfo == nil){
        _countryInfo = [[InfoView alloc] init];
        _countryInfo.title.text = @"国家";
        _countryInfo.info.enabled = NO;
        
    }
    return _countryInfo;
}

-(UIButton *)submitBtn{
    if(_submitBtn == nil){
        _submitBtn = [[UIButton alloc] init];
        [_submitBtn setTitle:@"保 存" forState:UIControlStateNormal];
        [_submitBtn setBackgroundColor:kColorBlue];
        [_submitBtn addTarget:self action:@selector(countrySelect:) forControlEvents:UIControlEventTouchUpInside]; //submitAction
    }
    return _submitBtn;
}
@end

#pragma mark ---- 信息view

@interface InfoView ()
@end

@implementation InfoView : UIView
-(instancetype)init{
    if (self = [super init]) {
        [self makeConstraints];
    }
    return self;
}

-(void)makeConstraints{
    [self addSubview:self.title];
    [self addSubview:self.info];
    
    [self.title mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self).mas_offset(10);
        make.bottom.mas_equalTo(self).mas_offset(-10);
        make.width.mas_equalTo(AdaptedWidth(80));
    }];
    [self.info mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.title.mas_right);
        make.top.bottom.mas_equalTo(0);
    }];
    
}

-(UILabel *)title{
    if (_title == nil) {
        _title = [[UILabel alloc] init];
        _title.font = AdaptedFontSize(15);
        _title.textColor = kColorTitle;
    }
    return _title;
}
-(UITextField *)info{
    if (_info == nil) {
        _info = [[UITextField alloc] init];
        _info.background = [UIImage imageNamed:@"textField_bg"];
        _info.textAlignment = NSTextAlignmentLeft;
        _info.font =AdaptedFontSize(15);
        
        UIView *leftV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
        _info.leftView = leftV;
        _info.leftViewMode = UITextFieldViewModeAlways;
    }
    return _info;
}
@end
