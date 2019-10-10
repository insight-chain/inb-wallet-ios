//
//  TransferVC.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/7.
//  Copyright © 2019 apple. All rights reserved.
//

#import "TransferVC.h"

#import "RequestVC.h"

#import "WalletManager.h"

#import "PasswordInputView.h"
#import "SWQRCode.h"
#import "NetworkUtil.h"

#import "NSString+Extension.h"

@interface TransferVC ()<UITextFieldDelegate>

@property(nonatomic, strong) UITextField *coinTF; //数币

@property(nonatomic, strong) UILabel *accountLabel; //"收款账号"
@property(nonatomic, strong) UITextField *accountTF;
@property(nonatomic, strong) UILabel *accountPlaceholder;

@property(nonatomic, strong) UILabel *numberLabel; //"数量"
@property(nonatomic, strong) UITextField *numberTF;
@property(nonatomic, strong) UILabel *balanceLabel; //“可用余额”

@property(nonatomic, strong) UILabel *noteLabel; //“备注信息”
@property(nonatomic, strong) UITextField *noteTF;

@property(nonatomic, strong) UIButton *senderBtn; //发送按钮

@end

@implementation TransferVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorBackground;
    
    /** View被导航栏遮挡问题的解决 **/
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    [self initNavi];
    
    [self.view addSubview:self.coinTF];
    [self.view addSubview:self.accountLabel];
    [self.view addSubview:self.accountTF];
    [self.view addSubview:self.numberLabel];
    [self.view addSubview:self.numberTF];
    [self.view addSubview:self.balanceLabel];
    [self.view addSubview:self.noteLabel];
    [self.view addSubview:self.noteTF];
    [self.view addSubview:self.senderBtn];
    
    self.coinTF.text = @"INB";
    self.coinTF.enabled = NO; //不可编辑，不可相应其他点击事件
    self.balanceLabel.text = [NSString stringWithFormat:@"可用余额 %.2f INB", self.balance];
    
    [self.coinTF mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(45);
    }];
    [self.accountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.coinTF.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(20);
    }];
    [self.accountTF mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.coinTF);
        make.top.mas_equalTo(self.accountLabel.mas_bottom).mas_offset(10);
    }];
    [self.numberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.accountLabel);
        make.top.mas_equalTo(self.accountTF.mas_bottom).mas_offset(20);
    }];
    [self.numberTF mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.accountTF);
        make.top.mas_equalTo(self.numberLabel.mas_bottom).mas_offset(10);
    }];
    [self.balanceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.numberLabel);
         make.top.mas_equalTo(self.numberTF.mas_bottom).mas_offset(5);
    }];
    [self.noteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.numberLabel);
        make.top.mas_equalTo(self.balanceLabel.mas_bottom).mas_offset(20);
    }];
    [self.noteTF mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.numberTF);
        make.top.mas_equalTo(self.noteLabel.mas_bottom).mas_offset(10);
    }];
    [self.senderBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.noteTF.mas_bottom).mas_offset(30);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(195);
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
#pragma mark ---- 导航栏
-(void)initNavi{
    /** 导航栏返回按钮文字 **/
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];
    
    UIButton *collecBtn = [[UIButton alloc] init];
    [collecBtn setTitle:NSLocalizedString(@"collection", @"收款") forState:UIControlStateNormal];
    [collecBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [collecBtn addTarget:self action:@selector(collecAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:collecBtn];
}
#pragma mark ---- Button Action
//收款
-(void)collecAction:(UIButton *)sender{
    RequestVC *requestVC = [[RequestVC alloc] init];
    requestVC.addressStr = App_Delegate.selectAddr;
    requestVC.navigationItem.title = NSLocalizedString(@"collection", @"收款");
    requestVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:requestVC animated:YES];
}
//扫一扫
-(void)scanAction:(UIButton *)sender{
    SWQRCodeConfig *qrConfig = [[SWQRCodeConfig alloc] init];
    qrConfig.scannerType = SWScannerTypeBoth;
    
    SWQRCodeViewController *qrVC = [[SWQRCodeViewController alloc] init];
    qrVC.scanBlock = ^(BOOL success, NSString *value) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.accountTF.text = value;
        });
    };
    qrVC.codeConfig = qrConfig;
    qrVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:qrVC animated:YES];
}
//粘贴账户名
-(void)pasteAction:(UIButton *)sender{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    self.accountTF.text = pasteboard.string;
}
//可转金额的全部
-(void)numberFullAction:(UIButton *)sender{
    self.numberTF.text = [NSString stringWithFormat:@"%f", self.balance]; //全部余额
}
//清空备注信息
-(void)cancelNoteAction:(UIButton *)sender{
    self.noteTF.text = @"";
}
//发送交易
-(void)transformAction:(UIButton *)sender{
    
    if(!([self.accountTF.text hasPrefix:@"0x95"] && [self.accountTF.text length] == 42)){
        [MBProgressHUD showMessage:NSLocalizedString(@"transfer.failed.noAddress", @"地址格式不正确") toView:self.view afterDelay:1 animted:YES];
        return;
    }
    
    NSDecimalNumber *value = [NSDecimalNumber decimalNumberWithString:self.numberTF.text];
    if(self.wallet.balanceINB < value.doubleValue){
        [MBProgressHUD showMessage:NSLocalizedString(@"transfer.failed.noBalance", @"余额不足") toView:self.view afterDelay:1 animted:YES];
        return;
    }
    
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
                                        NSDecimalNumber *value = [NSDecimalNumber decimalNumberWithString:tmpSelf.numberTF.text];
                                        NSDecimalNumber *bitValue = [value decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:kWei]];
                                        TransactionSignedResult *signResult = [WalletManager ethSignTransactionWithWalletID:tmpSelf.wallet.walletID nonce:[nonce stringValue] txType:TxType_transfer gasPrice:@"200000" gasLimit:@"21000" to:tmpSelf.accountTF.text value:[bitValue stringValue] data:tmpSelf.noteTF.text password:password chainID:kChainID]; //41，3
                                        NSString *requestUrl = [NSString stringWithFormat:@"https://api-ropsten.etherscan.io/api?module=proxy&action=eth_sendRawTransaction&hex=%@",signResult.signedTx]; //&apikey=SJMGV3C6S3CSUQQXC7CTQ72UCM966KD2XZ
                                        //https://api-kovan.etherscan.io/api?module=proxy&action=eth_sendRawTransaction&hex=%@
                                        
                                        
                                        [NetworkUtil rpc_requetWithURL:delegate.rpcHost
                                                                params:@{@"jsonrpc":@"2.0",
                                                                         @"method":sendTran_MethodName,
                                                                         @"params":@[[signResult.signedTx add0xIfNeeded]],
                                                                         @"id":@(1)}
                                                            completion:^(id  _Nullable responseObject, NSError * _Nullable error) {
                                                                [MBProgressHUD hideHUDForView:tmpSelf.view animated:YES];
                                                                
                                                                if (error) {
                                                                    [MBProgressHUD showMessage:NSLocalizedString(@"transfer.result.failed", @"转账失败") toView:tmpSelf.view afterDelay:1 animted:NO];
                                                                    return ;
                                                                }
                                                                NSString *errorStr = responseObject[@"error"];
                                                                if(errorStr){
                                                                    [MBProgressHUD showMessage:NSLocalizedString(@"transfer.result.failed", @"转账失败") toView:tmpSelf.view afterDelay:1 animted:NO];
                                                                    return ;
                                                                }
                                                                NSLog(@"%@---%@",[responseObject  class], responseObject);
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    [MBProgressHUD showMessage:NSLocalizedString(@"transfer.result.success", @"转账成功") toView:tmpSelf.view afterDelay:1 animted:NO];
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

#pragma mark ---- UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(nonnull NSString *)string{
    // 提升交互:动态设置按钮可行不可行
    NSArray *tfs = @[_accountTF, _numberTF];
    if([self getButtonEnableByCurrentTF:textField shouldChangeCharactersInRange:range replacementString:string tfArr:tfs]){
        [self.senderBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg_blue"] forState:UIControlStateNormal];
        self.senderBtn.userInteractionEnabled = YES;
    }else{
        [self.senderBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg_lightBlue"] forState:UIControlStateNormal];
        self.senderBtn.userInteractionEnabled = NO;
    }
    return YES;
}
- (BOOL)getButtonEnableByCurrentTF:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string tfArr:(NSArray *)tfArr;{
    if (string.length) {// 文本增加
        NSMutableArray *newTFs = [NSMutableArray arrayWithArray:tfArr];
        [newTFs removeObject:textField];
        for (UITextField *tempTF in newTFs) {
            if (tempTF.text.length==0) return NO;
        }
    }else{// 文本删除
        if (textField.text.length-range.length==0) {// 当前TF文本被删完
            return NO;
        }else{
            NSMutableArray *newTFs = [NSMutableArray arrayWithArray:tfArr];
            [newTFs removeObject:textField];
            for (UITextField *tempTF in newTFs) {
                if (tempTF.text.length==0) return NO;
            }
        }
    }
    return YES;
}

#pragma mark ----
-(UITextField *)coinTF{
    if (_coinTF == nil) {
        _coinTF = [[UITextField alloc] init];
        _coinTF.textColor = kColorBlue;
        _coinTF.font = AdaptedFontSize(15);
        _coinTF.background = [UIImage imageNamed:@"textField_bg"];
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 45)];
        _coinTF.leftViewMode = UITextFieldViewModeAlways;
        _coinTF.leftView = leftView;
    }
    return _coinTF;
}
-(UILabel *)accountLabel{
    if (_accountLabel == nil) {
        _accountLabel = [[UILabel alloc] init];
        _accountLabel.text = NSLocalizedString(@"transfer.account.receive", @"收款账号");
        _accountLabel.font = AdaptedFontSize(15);
        _accountLabel.textColor = kColorTitle;
    }
    return _accountLabel;
}
-(UITextField *)accountTF{
    if (_accountTF == nil) {
        _accountTF = [[UITextField alloc] init];
        _accountTF.textColor = kColorBlue;
        _accountTF.font = AdaptedFontSize(15);
        _accountTF.textColor = kColorTitle;
        _accountTF.background = [UIImage imageNamed:@"textField_bg"];
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 45)];
        _accountTF.leftViewMode = UITextFieldViewModeAlways;
        _accountTF.leftView = leftView;
        _accountTF.delegate = self;
        
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5+25+5+25+5, 45)];
        UIButton *pasteBtn = [[UIButton alloc] init]; //粘贴
        UIButton *scanBtn = [[UIButton alloc] init]; //扫一扫
        
        [rightView addSubview:pasteBtn];
        [rightView addSubview:scanBtn];
        
        [pasteBtn setImage:[UIImage imageNamed:@"copy"] forState:UIControlStateNormal];
        [pasteBtn addTarget:self action:@selector(pasteAction:) forControlEvents:UIControlEventTouchUpInside];
        [scanBtn setImage:[UIImage imageNamed:@"scan_gray"] forState:UIControlStateNormal];
        [scanBtn addTarget:self action:@selector(scanAction:) forControlEvents:UIControlEventTouchUpInside];
         
         [pasteBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
             make.height.width.mas_equalTo(25);
             make.centerY.mas_equalTo(rightView);
             make.left.mas_equalTo(scanBtn.mas_right).mas_offset(5);
             make.right.mas_equalTo(rightView).mas_offset(-5);
        }];
        [scanBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(pasteBtn);
            make.centerY.mas_equalTo(rightView);
            make.left.mas_equalTo(rightView).mas_offset(5);
        }];
        
        _accountTF.rightViewMode = UITextFieldViewModeAlways;
        _accountTF.rightView = rightView;
        
        NSAttributedString *paceStr= [[NSAttributedString alloc] initWithString:NSLocalizedString(@"placeholder.transfer.account.receive", @"请输入收款账号") attributes:@{NSFontAttributeName:_accountTF.font, NSForegroundColorAttributeName:kColorAuxiliary2}];
        _accountTF.attributedPlaceholder = paceStr;
    }
    return _accountTF;
}

-(UILabel *)numberLabel{
    if (_numberLabel == nil) {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.text = NSLocalizedString(@"transfer.number", @"数量");
        _numberLabel.font = AdaptedFontSize(15);
        _numberLabel.textColor = kColorTitle;
    }
    return _numberLabel;
}
-(UITextField *)numberTF{
    if (_numberTF == nil) {
        _numberTF = [[UITextField alloc] init];
        _numberTF.textColor = kColorBlue;
        _numberTF.font = AdaptedFontSize(15);
        _numberTF.background = [UIImage imageNamed:@"textField_bg"];
        _numberTF.textColor = kColorTitle;
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 45)];
        _numberTF.leftViewMode = UITextFieldViewModeAlways;
        _numberTF.leftView = leftView;
        _numberTF.delegate = self;
        
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10+AdaptedWidth(30)+10, 45)];
        UIButton *fullBtn = [[UIButton alloc] init]; //全部
        [fullBtn setTitle:NSLocalizedString(@"full", @"全部") forState:UIControlStateNormal];
        [fullBtn setTitleColor:kColorAuxiliary2 forState:UIControlStateNormal];
        fullBtn.titleLabel.font = AdaptedFontSize(14);
        [fullBtn addTarget:self action:@selector(numberFullAction:) forControlEvents:UIControlEventTouchUpInside];
        [rightView addSubview:fullBtn];
       
        [fullBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(AdaptedWidth(30));
            make.centerY.mas_equalTo(rightView);
            make.centerX.mas_equalTo(rightView);
        }];
        _numberTF.rightViewMode = UITextFieldViewModeAlways;
        _numberTF.rightView = rightView;
        _numberTF.keyboardType = UIKeyboardTypeDecimalPad; //数字键盘
        NSAttributedString *paceStr= [[NSAttributedString alloc] initWithString:NSLocalizedString(@"placeholder.transfer.number", @"请输入转账金额") attributes:@{NSFontAttributeName:_numberTF.font, NSForegroundColorAttributeName:kColorAuxiliary2}];
        _numberTF.attributedPlaceholder = paceStr;
    }
    return _numberTF;
}

-(UILabel *)balanceLabel{
    if (_balanceLabel == nil) {
        _balanceLabel = [[UILabel alloc] init];
        _balanceLabel.textColor = kColorBlue;
        _balanceLabel.font = AdaptedFontSize(13);
    }
    return _balanceLabel;
}
-(UILabel *)noteLabel{
    if (_noteLabel == nil) {
        _noteLabel = [[UILabel alloc] init];
        _noteLabel.text = NSLocalizedString(@"transfer.note", @"备注信息");
        _noteLabel.font = AdaptedFontSize(15);
        _noteLabel.textColor = kColorTitle;
    }
    return _noteLabel;
}
-(UITextField *)noteTF{
    if (_noteTF == nil) {
        _noteTF = [[UITextField alloc] init];
        _noteTF.textColor = kColorBlue;
        _noteTF.font = AdaptedFontSize(15);
        _noteTF.background = [UIImage imageNamed:@"textField_bg"];
        _noteTF.textColor = kColorTitle;
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 45)];
        _noteTF.leftViewMode = UITextFieldViewModeAlways;
        _noteTF.leftView = leftView;
        
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5+25+5, 45)];
        UIButton *cancelBtn = [[UIButton alloc] init]; //取消
        [cancelBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelNoteAction:) forControlEvents:UIControlEventTouchUpInside];
        [rightView addSubview:cancelBtn];
        
        [cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(25);
            make.centerY.mas_equalTo(rightView);
            make.centerX.mas_equalTo(rightView);
        }];
        _noteTF.rightViewMode = UITextFieldViewModeWhileEditing;
        _noteTF.rightView = rightView;
        
        NSAttributedString *paceStr= [[NSAttributedString alloc] initWithString:NSLocalizedString(@"placeholder.transfer.note", @"请输入备注信息") attributes:@{NSFontAttributeName:_noteTF.font, NSForegroundColorAttributeName:kColorAuxiliary2}];
        _noteTF.attributedPlaceholder = paceStr;
    }
    return _noteTF;
}
-(UIButton *)senderBtn{
    if (_senderBtn == nil) {
        _senderBtn = [[UIButton alloc] init];
        UIImage *img = [UIImage imageNamed:@"btn_bg_lightBlue"];
        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height/2.0, img.size.width/2.0, img.size.height/2.0, img.size.width/2.0) resizingMode:UIImageResizingModeStretch];
        _senderBtn.userInteractionEnabled = NO;
        [_senderBtn setBackgroundImage:img forState:UIControlStateNormal];
        [_senderBtn setTitle:NSLocalizedString(@"transfer.send", @"发送") forState:UIControlStateNormal];
        [_senderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_senderBtn addTarget:self action:@selector(transformAction:) forControlEvents:UIControlEventTouchUpInside];
        _senderBtn.titleLabel.font = AdaptedFontSize(15);
    }
    return _senderBtn;
}
@end
