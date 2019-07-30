//
//  PasswordChangeVC.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/24.
//  Copyright © 2019 apple. All rights reserved.
//

#import "PasswordChangeVC.h"
#import "BasicWallet.h"

#import "WalletManager.h"

@interface PasswordChangeVC ()

@property(nonatomic, strong) UILabel *originPassword;
@property(nonatomic, strong) UIImageView *passwordBg_1;
@property(nonatomic, strong) UITextField *password_1;
@property(nonatomic, strong) UIButton *eyeBtn_1;

@property(nonatomic, strong) UILabel *passwordNew;
@property(nonatomic, strong) UIImageView *passwordBg_2;
@property(nonatomic, strong) UITextField *password_2;
@property(nonatomic, strong) UIButton *eyeBtn_2;

@property(nonatomic, strong) UILabel *rePassword;
@property(nonatomic, strong) UIImageView *passwordBg_3;
@property(nonatomic, strong) UITextField *password_3;
@property(nonatomic, strong) UIButton *eyeBtn_3;

@property(nonatomic, strong) UIButton *doneBtn;

@end

@implementation PasswordChangeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColorBackground;
    
    /** View被导航栏遮挡问题的解决 **/
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
    [self.view addSubview:self.originPassword];
    [self.view addSubview:self.passwordBg_1];
    [self.view addSubview:self.password_1];
    [self.view addSubview:self.eyeBtn_1];
    
    [self.view addSubview:self.passwordNew];
    [self.view addSubview:self.passwordBg_2];
    [self.view addSubview:self.password_2];
    [self.view addSubview:self.eyeBtn_2];
    
    [self.view addSubview:self.rePassword];
    [self.view addSubview:self.passwordBg_3];
    [self.view addSubview:self.password_3];
    [self.view addSubview:self.eyeBtn_3];
    
    [self.view addSubview:self.doneBtn];
    
    [self makeConstraints];
}

-(void)makeConstraints{
    [self.originPassword mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(AdaptedWidth(20));
        make.left.mas_equalTo(AdaptedWidth(15));
    }];
    [self.passwordBg_1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.originPassword.mas_bottom).mas_offset(AdaptedWidth(10));
        make.left.mas_equalTo(AdaptedWidth(15));
        make.right.mas_equalTo(AdaptedWidth(-15));
        make.height.mas_equalTo(AdaptedWidth(40));
    }];
    [self.password_1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.passwordBg_1.mas_centerY);
        make.left.mas_equalTo(self.passwordBg_1.mas_left).mas_offset(AdaptedWidth(10));
        make.right.mas_equalTo(self.eyeBtn_1.mas_left).mas_offset(10);
    }];
    [self.eyeBtn_1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.passwordBg_1);
        make.height.mas_equalTo(self.passwordBg_1.mas_height);
        make.width.mas_equalTo(self.eyeBtn_1.mas_height);
        make.right.mas_equalTo(self.passwordBg_1.mas_right);
    }];
    
    [self.passwordNew mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.passwordBg_1.mas_bottom).mas_offset(AdaptedWidth(20));
        make.left.mas_equalTo(self.originPassword);
    }];
    [self.passwordBg_2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.passwordNew.mas_bottom).mas_offset(AdaptedWidth(10));
        make.left.right.mas_equalTo(self.passwordBg_1);
        make.height.mas_equalTo(self.passwordBg_1.mas_height);
    }];
    [self.password_2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.passwordBg_2.mas_centerY);
        make.left.mas_equalTo(self.passwordBg_2.mas_left).mas_offset(AdaptedWidth(10));
        make.right.mas_equalTo(self.eyeBtn_2.mas_left).mas_offset(10);
    }];
    [self.eyeBtn_2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.passwordBg_2);
        make.height.mas_equalTo(self.passwordBg_2.mas_height);
        make.width.mas_equalTo(self.eyeBtn_2.mas_height);
        make.right.mas_equalTo(self.passwordBg_2.mas_right);
    }];
    
    [self.rePassword mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.passwordBg_2.mas_bottom).mas_offset(AdaptedWidth(20));
        make.left.mas_equalTo(self.passwordNew);
    }];
    [self.passwordBg_3 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.rePassword.mas_bottom).mas_offset(AdaptedWidth(10));
        make.left.right.mas_equalTo(self.passwordBg_2);
        make.height.mas_equalTo(self.passwordBg_2.mas_height);
    }];
    [self.password_3 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.passwordBg_3.mas_centerY);
        make.left.mas_equalTo(self.passwordBg_3.mas_left).mas_offset(AdaptedWidth(10));
        make.right.mas_equalTo(self.eyeBtn_3.mas_left).mas_offset(10);
    }];
    [self.eyeBtn_3 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.passwordBg_3);
        make.height.mas_equalTo(self.passwordBg_3.mas_height);
        make.width.mas_equalTo(self.eyeBtn_3.mas_height);
        make.right.mas_equalTo(self.passwordBg_3.mas_right);
    }];
    
    [self.doneBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.passwordBg_3.mas_bottom).mas_offset(AdaptedWidth(20));
        make.width.mas_equalTo(AdaptedWidth(195));
        make.height.mas_equalTo(AdaptedWidth(40));
        
    }];
}

#pragma mark ---- Button Action
-(void)passwordHideAction:(UIButton *)sender{
    
}

-(void)doneAction:(UIButton *)sender{
    if (![self.password_2.text isEqualToString:self.password_3.text]) {
        [MBProgressHUD showMessage:@"新密码不一致" toView:self.view afterDelay:0.3 animted:YES];
        return ;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __block __weak typeof(self) tmpSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         BasicWallet *wallet = [WalletManager modifyWalletPasswordByWalletID:self.wallet.walletID oldPassword:self.password_1.text newPassword:self.password_2.text];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if(!wallet){
                [MBProgressHUD showMessage:@"原密码不正确" toView:self.view afterDelay:1 animted:YES];
            }else{
                [MBProgressHUD showMessage:@"密码修改成功" toView:self.view afterDelay:1 animted:YES];
                tmpSelf.wallet = wallet;
                [NotificationCenter postNotificationName:NOTI_ADD_WALLET object:wallet];
                [tmpSelf.navigationController popViewControllerAnimated:YES];
            }
        });
    });
}

#pragma mark ---- setter && getter
-(UILabel *)originPassword{
    if (_originPassword == nil) {
        _originPassword = [[UILabel alloc] init];
        _originPassword.text = NSLocalizedString(@"password.original", @"原密码");
        _originPassword.font = AdaptedFontSize(15);
        _originPassword.textColor = kColorTitle;
    }
    return _originPassword;
}
-(UIImageView *)passwordBg_1{
    if (_passwordBg_1 == nil) {
        _passwordBg_1 = [[UIImageView alloc] init];
        UIImage *img = [UIImage imageNamed:@"textField_bg"];
        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height/2.0, img.size.width/2.0, img.size.height/2.0, img.size.height/2.0) resizingMode:UIImageResizingModeStretch];
        _passwordBg_1.image = img;
    }
    return _passwordBg_1;
}
-(UITextField *)password_1{
    if (_password_1 == nil) {
        _password_1 = [[UITextField alloc] init];
        _password_1.textColor = kColorTitle;
        _password_1.font = AdaptedFontSize(15);
        _password_1.placeholder = NSLocalizedString(@"placeholder.originPassword", @"请输入当前密码");
    }
    return _password_1;
}
-(UIButton *)eyeBtn_1{
    if (_eyeBtn_1 == nil) {
        _eyeBtn_1 = [[UIButton alloc] init];
        [_eyeBtn_1 setImage:[UIImage imageNamed:@"eye_close_blue"] forState:UIControlStateNormal];
        [_eyeBtn_1 setImage:[UIImage imageNamed:@"eye_open_blue"] forState:UIControlStateSelected];
        [_eyeBtn_1 addTarget:self action:@selector(passwordHideAction:)
          forControlEvents:UIControlEventTouchUpInside];
    }
    return _eyeBtn_1;
}

-(UILabel *)passwordNew{
    if (_passwordNew == nil) {
        _passwordNew = [[UILabel alloc] init];
        _passwordNew.text = NSLocalizedString(@"password.new", @"新密码");
        _passwordNew.font = AdaptedFontSize(15);
        _passwordNew.textColor = kColorTitle;
    }
    return _passwordNew;
}
-(UIImageView *)passwordBg_2{
    if (_passwordBg_2 == nil) {
        _passwordBg_2 = [[UIImageView alloc] init];
        UIImage *img = [UIImage imageNamed:@"textField_bg"];
        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height/2.0, img.size.width/2.0, img.size.height/2.0, img.size.height/2.0) resizingMode:UIImageResizingModeStretch];
        _passwordBg_2.image = img;
    }
    return _passwordBg_2;
}
-(UITextField *)password_2{
    if (_password_2 == nil) {
        _password_2 = [[UITextField alloc] init];
        _password_2.textColor = kColorTitle;
        _password_2.font = AdaptedFontSize(15);
        _password_2.placeholder = NSLocalizedString(@"placeholder.newPassword", @"请输入新密码");
    }
    return _password_2;
}
-(UIButton *)eyeBtn_2{
    if (_eyeBtn_2 == nil) {
        _eyeBtn_2 = [[UIButton alloc] init];
        [_eyeBtn_2 setImage:[UIImage imageNamed:@"eye_close_blue"] forState:UIControlStateNormal];
        [_eyeBtn_2 setImage:[UIImage imageNamed:@"eye_open_blue"] forState:UIControlStateSelected];
        [_eyeBtn_2 addTarget:self action:@selector(passwordHideAction:)
            forControlEvents:UIControlEventTouchUpInside];
    }
    return _eyeBtn_2;
}

-(UILabel *)rePassword{
    if (_rePassword == nil) {
        _rePassword = [[UILabel alloc] init];
        _rePassword.text = NSLocalizedString(@"password.replay", @"确认新密码");
        _rePassword.font = AdaptedFontSize(15);
        _rePassword.textColor = kColorTitle;
    }
    return _rePassword;
}
-(UIImageView *)passwordBg_3{
    if (_passwordBg_3 == nil) {
        _passwordBg_3 = [[UIImageView alloc] init];
        UIImage *img = [UIImage imageNamed:@"textField_bg"];
        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height/2.0, img.size.width/2.0, img.size.height/2.0, img.size.height/2.0) resizingMode:UIImageResizingModeStretch];
        _passwordBg_3.image = img;
    }
    return _passwordBg_3;
}
-(UITextField *)password_3{
    if (_password_3 == nil) {
        _password_3 = [[UITextField alloc] init];
        _password_3.textColor = kColorTitle;
        _password_3.font = AdaptedFontSize(15);
        _password_3.placeholder = NSLocalizedString(@"placeholder.rePassword", @"再次输入新密码");
    }
    return _password_3;
}
-(UIButton *)eyeBtn_3{
    if (_eyeBtn_3 == nil) {
        _eyeBtn_3 = [[UIButton alloc] init];
        [_eyeBtn_3 setImage:[UIImage imageNamed:@"eye_close_blue"] forState:UIControlStateNormal];
        [_eyeBtn_3 setImage:[UIImage imageNamed:@"eye_open_blue"] forState:UIControlStateSelected];
        [_eyeBtn_3 addTarget:self action:@selector(passwordHideAction:)
            forControlEvents:UIControlEventTouchUpInside];
    }
    return _eyeBtn_3;
}

-(UIButton *)doneBtn{
    if (_doneBtn == nil) {
        _doneBtn = [[UIButton alloc] init];
        [_doneBtn setTitle:NSLocalizedString(@"done", @"完成") forState:UIControlStateNormal];
        [_doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_doneBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg_blue"] forState:UIControlStateNormal];
        [_doneBtn addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneBtn;
}

@end
