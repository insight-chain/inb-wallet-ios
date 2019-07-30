//
//  WalletDetailVC.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/9.
//  Copyright © 2019 apple. All rights reserved.
//

#import "WalletDetailVC.h"
#import "SavePrivatekeyWaringView.h"
#import "PasswordChangeVC.h"
#import "WalletBackupVC.h"

#import "WalletManager.h"
#import "PasswordInputView.h"

#define topMargin 20
#define midMargin 10

@interface WalletDetailVC ()

@property(nonatomic, strong) UILabel *accountStr; //“账户名”
@property(nonatomic, strong) UILabel *accountName;
@property(nonatomic, strong) UIImageView *accountBg;

@property(nonatomic, strong) UILabel *addressStr; //“钱包地址”
@property(nonatomic, strong) UILabel *address;
@property(nonatomic, strong) UIImageView *addressBg;

@property(nonatomic, strong) UILabel *createTimeStr; //“创建时间”
@property(nonatomic, strong) UILabel *createTime;
@property(nonatomic, strong) UIImageView *createTimeBg;

@property(nonatomic, strong) MoreView *exportView; //导出私钥
@property(nonatomic, strong) MoreView *changePasswordView; //修改密码
@end

@implementation WalletDetailVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    /** View被导航栏遮挡问题的解决 **/
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
    [self initNavitaion];
    __block __weak typeof(self) tmpSelf = self;
    self.exportView = [[MoreView alloc] initWithTitle:NSLocalizedString(@"exportPrivateKey", @"导出当前私钥") click:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [SavePrivatekeyWaringView showSaveWaringWith:^{
                [PasswordInputView showPasswordInputWithConfirmClock:^(NSString * _Nonnull password) {
                    [MBProgressHUD showHUDAddedTo:tmpSelf.view animated:YES];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        @try {
                            NSString *private = [tmpSelf.wallet privateKey:password];
                            NSString *menmonry = [tmpSelf.wallet exportMnemonic:password];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [MBProgressHUD hideHUDForView:tmpSelf.view animated:YES];
                                WalletBackupVC *backupVC = [[WalletBackupVC alloc] init];
                                backupVC.privateKey = private;
                                backupVC.menmonryKey = menmonry;
                                backupVC.name = tmpSelf.wallet.name;
                                backupVC.hidesBottomBarWhenPushed = YES;
                                [tmpSelf.navigationController pushViewController:backupVC animated:YES];
                            });
                        } @catch (NSException *exception) {
                            if([exception.name isEqualToString:@"PasswordError"]){
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [MBProgressHUD hideHUDForView:tmpSelf.view animated:YES];
                                    [MBProgressHUD showMessage:@"密码错误" toView:tmpSelf.view afterDelay:0.5 animted:YES];
                                });
                            }
                        } @finally {
                            
                        }
                        
                    });
                }];
            }];
            });

    }];
    self.changePasswordView = [[MoreView alloc] initWithTitle:NSLocalizedString(@"changePassword_wallet", @"修改钱包密码") click:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            /** 导航栏返回按钮文字 **/
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
            self.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];
            
            PasswordChangeVC *changePwdVC = [[PasswordChangeVC alloc] init];
            changePwdVC.wallet = tmpSelf.wallet;
            changePwdVC.navigationItem.title = NSLocalizedString(@"password.change", @"修改密码");
            [self.navigationController pushViewController:changePwdVC animated:YES];
        });
    }];
    
    [self makeConstrainView];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    self.accountName.text = self.wallet.name; //@"Insight Chain 123";
    self.address.text = [self.wallet.address hasPrefix:@"0x"] ? self.wallet.address : [NSString stringWithFormat:@"0x%@", self.wallet.address];
    self.createTime.text = [NSDate timestampSwitchTime:self.wallet.imTokenMeta.timestamp formatter:@"yyyy-MM-dd HH:mm:ss"];
}

-(void)initNavitaion{
    UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"nav_delete"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteWalletAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:deleteBtn];
}

-(void)makeConstrainView{
    [self.view addSubview:self.accountStr];
    [self.view addSubview:self.accountBg];
    [self.view addSubview:self.accountName];
    
    [self.view addSubview:self.addressStr];
    [self.view addSubview:self.addressBg];
    [self.view addSubview:self.address];
    
    [self.view addSubview:self.createTimeStr];
    [self.view addSubview:self.createTimeBg];
    [self.view addSubview:self.createTime];
    
    
    UIView *sepView = [[UIView alloc] init];
    sepView.backgroundColor = kColorBackground;
    [self.view addSubview:sepView];
    
    [self.view addSubview:self.exportView];
    [self.view addSubview:self.changePasswordView];
    
    [self.accountStr mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(AdaptedHeight(topMargin));
        make.left.mas_equalTo(AdaptedWidth(20));
    }];
    [self.accountBg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.accountStr.mas_left).mas_offset(AdaptedWidth(-5));
        make.right.mas_equalTo(AdaptedWidth(-15));
        make.top.mas_equalTo(self.accountStr.mas_bottom).mas_offset(AdaptedHeight(midMargin));
        make.height.mas_equalTo(AdaptedHeight(45));
    }];
    [self.accountName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.accountBg.mas_centerY);
        make.left.mas_equalTo(self.accountBg.mas_left).mas_offset(AdaptedWidth(midMargin));
        make.right.mas_equalTo(self.accountBg.mas_right).mas_offset(AdaptedWidth(-midMargin));
    }];
    [self.addressStr mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.accountStr);
        make.top.mas_equalTo(self.accountBg.mas_bottom).mas_offset(AdaptedHeight(topMargin));
    }];
    [self.addressBg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.accountBg);
        make.top.mas_equalTo(self.addressStr.mas_bottom).mas_offset(AdaptedHeight(midMargin));
        make.height.mas_equalTo(AdaptedHeight(100));
    }];
    [self.address mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.accountName);
        make.top.mas_equalTo(self.addressBg.mas_top).mas_offset(AdaptedHeight(15));
    }];
    [self.createTimeStr mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.addressBg.mas_bottom).mas_offset(AdaptedHeight(topMargin));
        make.left.mas_equalTo(self.accountStr);
    }];
    [self.createTimeBg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.createTimeStr.mas_bottom).mas_offset(AdaptedWidth(midMargin));
        make.left.right.mas_equalTo(self.accountBg);
        make.height.mas_equalTo(self.accountBg);
    }];
    [self.createTime mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.createTimeBg.mas_centerY);
        make.left.mas_equalTo(self.createTimeBg.mas_left).mas_offset(AdaptedWidth(midMargin));
    }];
    
    [sepView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.createTimeBg.mas_bottom).mas_offset(AdaptedHeight(topMargin));
        make.height.mas_equalTo(AdaptedHeight(8));
    }];
    
    [self.exportView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(sepView.mas_bottom);
    }];
    [self.changePasswordView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.exportView);
        make.top.mas_equalTo(self.exportView.mas_bottom);
    }];
}

#pragma mark ---- Button Action
//删除账户
-(void)deleteWalletAction:(UIButton *)sender{
    [self.wallet deleteWallet];
    [self.navigationController popViewControllerAnimated:YES];
    [NotificationCenter postNotificationName:NOTI_DELETE_WALLET object:self.wallet];
}

#pragma mark ---- getter
-(UILabel *)accountStr{
    if (_accountStr == nil) {
        _accountStr = [[UILabel alloc] init];
        _accountStr.font = AdaptedFontSize(15);
        _accountStr.textColor = kColorTitle;
        _accountStr.text = NSLocalizedString(@"accountName", @"账号名");
    }
    return _accountStr;
}
-(UILabel *)accountName{
    if (_accountName == nil) {
        _accountName = [[UILabel alloc] init];
        _accountName.font = AdaptedFontSize(15);
        _accountName.textColor = kColorAuxiliary2;
    }
    return _accountName;
}
-(UIImageView *)accountBg{
    if (_accountBg == nil) {
        _accountBg = [[UIImageView alloc] init];
        UIImage *img = [UIImage imageNamed:@"label_bg"];
        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height/2.0, img.size.width/2.0, img.size.width/2.0, img.size.height/2.0) resizingMode:UIImageResizingModeStretch];
        _accountBg.image = img;
    }
    return _accountBg;
}
-(UILabel *)addressStr{
    if (_addressStr == nil) {
        _addressStr = [[UILabel alloc] init];
        _addressStr.font = AdaptedFontSize(15);
        _addressStr.textColor = kColorTitle;
        _addressStr.text = NSLocalizedString(@"walletAddress", @"钱包地址");
    }
    return _addressStr;
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
        _address.font = AdaptedFontSize(15);
        _address.textColor = kColorAuxiliary2;
    }
    return _address;
}
-(UILabel *)createTimeStr{
    if (_createTimeStr == nil) {
        _createTimeStr = [[UILabel alloc] init];
        _createTimeStr.font = AdaptedFontSize(15);
        _createTimeStr.textColor = kColorTitle;
        _createTimeStr.text = NSLocalizedString(@"createdTime", @"创建时间");
    }
    return _createTimeStr;
}
-(UIImageView *)createTimeBg{
    if (_createTimeBg == nil) {
        _createTimeBg = [[UIImageView alloc] init];
        UIImage *img = [UIImage imageNamed:@"label_bg"];
        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height/2.0, img.size.width/2.0, img.size.width/2.0, img.size.height/2.0) resizingMode:UIImageResizingModeStretch];
        _createTimeBg.image = img;
    }
    return _createTimeBg;
}
-(UILabel *)createTime{
    if (_createTime == nil) {
        _createTime = [[UILabel alloc] init];
        _createTime.numberOfLines = 0;
        _createTime.font = AdaptedFontSize(15);
        _createTime.textColor = kColorAuxiliary2;
    }
    return _createTime;
}
@end


#pragma mark ---- 点击按钮
@interface MoreView()
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIImageView *moreImg;
@property(nonatomic, strong) UIView *lineView;
@property(nonatomic, copy) void(^click)(void); // block作为属性
@end

@implementation MoreView

-(instancetype)initWithTitle:(NSString *)title click:(nonnull void (^)(void))click{
    if (self = [super init]) {
        self.titleLabel.text = title;
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.moreImg];
        [self addSubview:self.lineView];
        self.click = click;
        [self makeContraintsView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}
-(void)makeContraintsView{
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(AdaptedHeight(topMargin));
        make.left.mas_equalTo(self).mas_offset(AdaptedWidth(topMargin));
    }];
    [self.moreImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLabel);
        make.right.mas_equalTo(self).mas_offset(AdaptedWidth(-15));
    }];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(AdaptedHeight(15));
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.right.mas_equalTo(self.moreImg.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom);
        
    }];
}

-(void)tapClick{
    if (self.click) {
        self.click();
    }
}

-(UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = AdaptedFontSize(15);
        _titleLabel.textColor = kColorTitle;
    }
    return _titleLabel;
}
-(UIImageView *)moreImg{
    if (_moreImg == nil) {
        _moreImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"more_arrow"]];
    }
    return _moreImg;
}
-(UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = kColorSeparate;
    }
    return _lineView;
}

@end
