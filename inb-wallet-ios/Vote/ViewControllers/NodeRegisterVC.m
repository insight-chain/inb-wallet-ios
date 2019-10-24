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

@property(nonatomic, strong) UILabel *nameStr; //节点名称
@property(nonatomic, strong) UITextField *name;
@property(nonatomic, strong) UIView *sepView_1; // 分割线

@property(nonatomic, strong) UILabel *ipStr; //节点IP
@property(nonatomic, strong) UITextField *ipTF;

@property(nonatomic, strong) UILabel *portStr; //节点端口号
@property(nonatomic, strong) UITextField *portTF;

@property(nonatomic, strong) UILabel *countryStr; //国家
@property(nonatomic, strong) UIButton *countryBtn;
@property(nonatomic, strong) NSString *countryCode; //国家码

@property(nonatomic, strong) UILabel *introStr; //节点介绍
@property(nonatomic, strong) UIImageView *introBg;
@property(nonatomic, strong) UITextView *intro;

@property(nonatomic, strong) UILabel *idStr; //节点ID
@property(nonatomic, strong) UIImageView *idBg;
@property(nonatomic, strong) UITextView *nodeID;


@property(nonatomic, strong) UILabel *otherInfoStr; //其他信息
@property(nonatomic, strong) InfoView *receiveAccountInfo; //接收地址
@property(nonatomic, strong) InfoView *websiteInfo; //官网
@property(nonatomic, strong) InfoView *telegraphInfo;
@property(nonatomic, strong) InfoView *wechatInfo;
@property(nonatomic, strong) InfoView *facebookInfo;
@property(nonatomic, strong) InfoView *twitterInfo;
@property(nonatomic, strong) InfoView *githubInfo;
@property(nonatomic, strong) InfoView *emailInfo;

@property(nonatomic, strong) CountryCodeView *countryView; //国家选择列表

@property(nonatomic, strong) UIButton *submitBtn;

@end

@implementation NodeRegisterVC

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = kColorBackground;
    
    self.self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, KHEIGHT-kNavigationBarHeight)];
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
    
    [self.scrollContentView addSubview:self.ipStr];
    [self.scrollContentView addSubview:self.ipTF];
    
    [self.scrollContentView addSubview:self.portStr];
    [self.scrollContentView addSubview:self.portTF];
    
    [self.scrollContentView addSubview:self.countryStr];
    [self.scrollContentView addSubview:self.countryBtn];
    
    [self.scrollContentView addSubview:self.idStr];
    [self.scrollContentView addSubview:self.idBg];
    [self.scrollContentView addSubview:self.nodeID];
    
    [self.scrollContentView addSubview:self.introStr];
    [self.scrollContentView addSubview:self.introBg];
    [self.scrollContentView addSubview:self.intro];

    
    [self.scrollContentView addSubview:self.otherInfoStr];
    [self.scrollContentView addSubview:self.receiveAccountInfo];
    [self.scrollContentView addSubview:self.websiteInfo];
    [self.scrollContentView addSubview:self.telegraphInfo];
    [self.scrollContentView addSubview:self.wechatInfo];
    [self.scrollContentView addSubview:self.facebookInfo];
    [self.scrollContentView addSubview:self.twitterInfo];
    [self.scrollContentView addSubview:self.githubInfo];
    [self.scrollContentView addSubview:self.emailInfo];
    
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
        make.left.right.mas_equalTo(self.headImg);
        make.height.mas_equalTo(45);
    }];
    
    [self.ipStr mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.name.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(15);
    }];
    [self.ipTF mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.ipStr.mas_bottom).mas_offset(10);
        make.left.right.mas_equalTo(self.headImg);
        make.height.mas_equalTo(45);
    }];
    
    [self.portStr mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.ipTF.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(15);
    }];
    [self.portTF mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.portStr.mas_bottom).mas_offset(10);
        make.left.right.mas_equalTo(self.ipTF);
        make.height.mas_equalTo(45);
    }];
    
    [self.countryStr mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.portTF.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(15);
    }];
    [self.countryBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.countryStr.mas_bottom).mas_offset(10);
        make.left.right.mas_equalTo(self.ipTF);
        make.height.mas_equalTo(45);
    }];

    [self.idStr mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.countryBtn.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(self.portStr);
    }];
    [self.idBg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.idStr.mas_bottom).mas_offset(10);
        make.left.right.mas_equalTo(self.name);
        make.height.mas_equalTo(150);
    }];
    [self.nodeID mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.idStr.mas_bottom).mas_offset(10);
        make.left.right.mas_equalTo(self.name);
        make.height.mas_equalTo(150);
    }];
    
    [self.introStr mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nodeID.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(self.idStr);
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
    [self.receiveAccountInfo mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.otherInfoStr.mas_bottom).mas_offset(20);
        make.left.right.mas_equalTo(self.name);
        make.height.mas_equalTo(45);
    }];
    [self.websiteInfo mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.receiveAccountInfo.mas_bottom).mas_offset(15);
        make.left.right.mas_equalTo(self.receiveAccountInfo);
        make.height.mas_equalTo(self.receiveAccountInfo);
    }];
    [self.telegraphInfo mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.websiteInfo.mas_bottom).mas_offset(15);
        make.left.right.height.mas_equalTo(self.websiteInfo);
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
    [self.emailInfo mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.githubInfo.mas_bottom).mas_offset(15);
        make.left.right.height.mas_equalTo(self.twitterInfo);
    }];
    [self.submitBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.emailInfo.mas_bottom).mas_offset(30);
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
    [self.view endEditing:YES];
    __block __weak typeof(self) tmpSelf = self;
    if(self.countryView == nil){
        self.countryView = [[CountryCodeView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, KHEIGHT)];
        self.countryView.selectCountry = ^(NSString * _Nullable countryName, NSString * _Nonnull countryCode) {
            NSLog(@"Name:%@---Code:%@", countryName, countryCode);
            [tmpSelf.countryBtn setTitle:countryName forState:UIControlStateNormal];
            tmpSelf.countryCode = countryCode;
        };
    }
    [App_Delegate.window addSubview:self.countryView];
}
#pragma mark ---- function
//注册及节点
-(void)registerToNode{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSString *ip = self.ipTF.text?:@"";
    NSString *port = self.portTF.text?:@"";
    NSString *name = self.name.text;
    NSString *country = self.countryCode;
    NSString *headerImgStr = self.headImg.text ? : @"";
    NSString *homepageUrl = self.websiteInfo.info.text?:@""; //主页
    NSString *email = self.emailInfo.info.text ? : @"";
    NSDictionary *attributeDic = @{@"name":name,
                                   @"intro":self.intro.text,
                                   @"wechat":self.wechatInfo.info.text,
                                   @"telegraph":self.telegraphInfo.info.text,
                                   @"facebook":self.facebookInfo.info.text,
                                   @"twitter":self.twitterInfo.info.text,
                                   @"github":self.githubInfo.info.text
    };
    NSString *attributeData = [attributeDic toJSONString];
    
    NSString *nodeID = self.nodeID.text ? : @"";// @"8aa5fc69c92bb3e8acb71b0b42f2e0bfaf4b642a4a38b0efaf2d1270880ea4a187ea16d3811436833f05a08a512cddce920f0a988b75527548bb75d9628fa503";
    // nodeID~ip~port~name~country(nation)~receiveAccount~imageURL~website~email~data(key1/value1-key2/value2....)
    NSString *receiveAccount = self.receiveAccountInfo.info.text?:@""; //接收账号
    NSDictionary *dataDic = @{@"id":nodeID,
                              @"ip":ip,
                              @"port":port,
                              @"rewardAccount":receiveAccount,
                              @"name":name,
                              @"nation":country,
                              @"image":headerImgStr,
                              @"website":homepageUrl,
                              @"email":email,
                              @"extraData":attributeData};
   
    
    NSString *dataStr = [dataDic toJSONString];
    if (dataStr == nil) {
        [MBProgressHUD showMessage:@"数据有误" toView:App_Delegate.window afterDelay:0.7 animted:YES];
        return;
    }
    
    [PasswordInputView showPasswordInputWithConfirmClock:^(NSString * _Nonnull password) {
        __block __weak typeof(self) tmpSelf = self;
        [MBProgressHUD showHUDAddedTo:tmpSelf.view animated:YES];
        
        [NetworkUtil rpc_requetWithURL:delegate.rpcHost params:@{@"jsonrpc":@"2.0",
                                                                 @"method":nonce_MethodName,
                                                                 @"params":@[[self.wallet.address add0xIfNeeded],@"latest"],@"id":@(1)}
                            completion:^(id  _Nullable responseObject, NSError * _Nullable error) {
                                if (error) {
                                    [MBProgressHUD hideHUDForView:tmpSelf.view animated:YES];
                                    [MBProgressHUD showMessage:NSLocalizedString(@"修改节点失败", @"修改节点失败") toView:tmpSelf.view afterDelay:1.5 animted:NO];
                                    return ;
                                }
                                NSDictionary *dic = (NSDictionary *)responseObject;
                                NSDecimalNumber *nonce = [dic[@"result"] decimalNumberFromHexString];
                                @try{
                                    TransactionSignedResult *signResult = [WalletManager ethSignTransactionWithWalletID:self.wallet.walletID nonce:[nonce stringValue] txType:TxType_updateNodeInfo gasPrice:@"200000" gasLimit:@"21000" to:[self.wallet.address add0xIfNeeded] value:@"0" data:[dataStr hexString] password:password chainID:kChainID];
                                    [NetworkUtil rpc_requetWithURL:delegate.rpcHost
                                                            params:@{@"jsonrpc":@"2.0",
                                                                     @"method":sendTran_MethodName,
                                                                     @"params":@[[signResult.signedTx add0xIfNeeded]],
                                                                     @"id":@(1)}
                                                        completion:^(id  _Nullable responseObject, NSError * _Nullable error) {
                                                            [MBProgressHUD hideHUDForView:tmpSelf.view animated:YES];
                                                            
                                                            if (error || responseObject[@"error"]) {
                                                                [MBProgressHUD showMessage:NSLocalizedString(@"修改节点失败", @"修改节点失败") toView:tmpSelf.view afterDelay:1.5 animted:NO];
                                                                return ;
                                                            }
                                                            NSLog(@"%@---%@",[responseObject  class], responseObject);
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                [MBProgressHUD showMessage:NSLocalizedString(@"修改节点成功", @"修改节点成功") toView:tmpSelf.view afterDelay:1.5 animted:NO];
                                                                [NotificationCenter postNotificationName:NOTI_BALANCE_CHANGE object:nil];
                                                            });
                                                        }];
                                }@catch (NSException *exception) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [MBProgressHUD hideHUDForView:tmpSelf.view animated:YES];
                                        [MBProgressHUD showMessage:@"密码错误" toView:tmpSelf.view afterDelay:1 animted:YES];
                                    });
                                    
                                } @finally {
                                    
                                }
                            }];
        
        
        
    }];
    
}

#pragma mark ----
-(void)setNode:(Node *)node{
    _node = node;
    self.headImg.text = _node.image;
    self.name.text = _node.name;
    self.intro.text = _node.intro;
    
    self.ipTF.text = _node.host;
    self.portTF.text = _node.port;
    [self.countryBtn setTitle:_node.countryName forState:UIControlStateNormal];
    self.countryCode = _node.countryCode;
    self.nodeID.text = _node.nodeId;
    
    self.receiveAccountInfo.info.text = @"";
    self.websiteInfo.info.text = _node.webSite;
    self.wechatInfo.info.text = _node.wechat;
    self.facebookInfo.info.text = _node.facebook;
    self.twitterInfo.info.text = _node.twitter;
//    self.githubInfo.info.text = _node.git
    self.emailInfo.info.text = _node.email;
    self.receiveAccountInfo.info.text = _node.rewardAccount;
    
    NSString *dataStr = _node.data;
    if(!dataStr){
        self.intro.text = @"";
    }else{
        NSData *jsonData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        self.intro.text = dataDic[@"intro"];
        self.facebookInfo.info.text = dataDic[@"facebook"];
        self.githubInfo.info.text = dataDic[@"github"];
        self.telegraphInfo.info.text = dataDic[@"telegraph"];
        self.twitterInfo.info.text = dataDic[@"twitter"];
        self.wechatInfo.info.text = dataDic[@"wechat"];
        
    }
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

-(UILabel *)ipStr{
    if (_ipStr == nil) {
        _ipStr = [[UILabel alloc] init];
        _ipStr.font = AdaptedFontSize(15);
        _ipStr.textColor = kColorTitle;
        _ipStr.text = @"节点IP";
    }
    return _ipStr;
}
-(UITextField *)ipTF{
    if (_ipTF == nil) {
        
        _ipTF = [[UITextField alloc] init];
        _ipTF.background = [UIImage imageNamed:@"textField_bg"];
        _ipTF.textColor = kColorTitle;
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 35)];
        _ipTF.leftView = leftView;
        _ipTF.leftViewMode = UITextFieldViewModeAlways;
        
        _ipTF.font = AdaptedFontSize(15);
        _ipTF.backgroundColor = [UIColor whiteColor];
        _ipTF.placeholder = @"请输入节点IP";
    }
    return _ipTF;
}

-(UILabel *)portStr{
    if (_portStr == nil) {
        _portStr = [[UILabel alloc] init];
        _portStr.font = AdaptedFontSize(15);
        _portStr.textColor = kColorTitle;
        _portStr.text = @"节点端口号";
    }
    return _portStr;
}
-(UITextField *)portTF{
    if (_portTF == nil) {
        
        _portTF = [[UITextField alloc] init];
        _portTF.background = [UIImage imageNamed:@"textField_bg"];
        _portTF.textColor = kColorTitle;
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 35)];
        _portTF.leftView = leftView;
        _portTF.leftViewMode = UITextFieldViewModeAlways;
        
        _portTF.font = AdaptedFontSize(15);
        _portTF.backgroundColor = [UIColor whiteColor];
        _portTF.placeholder = @"请输入节点端口号";
    }
    return _portTF;
}

-(UILabel *)countryStr{
    if (_countryStr == nil) {
        _countryStr = [[UILabel alloc] init];
        _countryStr.font = AdaptedFontSize(15);
        _countryStr.textColor = kColorTitle;
        _countryStr.text = @"国家";
    }
    return _countryStr;
}
-(UIButton *)countryBtn{
    if (_countryBtn == nil) {
        
        _countryBtn = [[UIButton alloc] init];
        [_countryBtn setBackgroundImage:[UIImage imageNamed:@"textField_bg"] forState:UIControlStateNormal];
        [_countryBtn setTitleColor:kColorTitle forState:UIControlStateNormal];
        
        _countryBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _countryBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _countryBtn.titleLabel.font = AdaptedFontSize(15);
        _countryBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
        
        [_countryBtn addTarget:self action:@selector(countrySelect:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _countryBtn;
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

-(UILabel *)idStr{
    if (_idStr == nil) {
        _idStr = [[UILabel alloc] init];
        _idStr.font = AdaptedFontSize(15);
        _idStr.textColor = kColorTitle;
        _idStr.text = @"节点ID";
    }
    return _idStr;
}
-(UIImageView *)idBg{
    if (_idBg == nil) {
        _idBg = [[UIImageView alloc] init];
        UIImage *img = [UIImage imageNamed:@"textView_bg"];
        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height/2.0, img.size.width/2.0, img.size.height/2.0, img.size.width/2.0) resizingMode:UIImageResizingModeStretch];
        _idBg.image = img;
    }
    return _idBg;
}
-(UITextView *)nodeID{
    if (_nodeID == nil) {
        _nodeID = [[UITextView alloc] init];
        
    }
    return _nodeID;
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

-(InfoView *)receiveAccountInfo{
    if(_receiveAccountInfo == nil){
        _receiveAccountInfo = [[InfoView alloc] init];
        _receiveAccountInfo.title.text = @"接收地址";
        _receiveAccountInfo.backgroundColor = [UIColor clearColor];
    }
    return _receiveAccountInfo;
}
-(InfoView *)websiteInfo{
    if(_websiteInfo == nil){
        _websiteInfo = [[InfoView alloc] init];
        _websiteInfo.title.text = @"官方网址";
        _websiteInfo.backgroundColor = [UIColor clearColor];
    }
    return _websiteInfo;
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

-(InfoView *)emailInfo{
    if(_emailInfo == nil){
        _emailInfo = [[InfoView alloc] init];
        _emailInfo.title.text = @"邮箱";
        
    }
    return _emailInfo;
}

-(UIButton *)submitBtn{
    if(_submitBtn == nil){
        _submitBtn = [[UIButton alloc] init];
        [_submitBtn setTitle:NSLocalizedString(@"vote.node.register.submit", @"提 交") forState:UIControlStateNormal];
        [_submitBtn setBackgroundColor:kColorBlue];
        [_submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
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
