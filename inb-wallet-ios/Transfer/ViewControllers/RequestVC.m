//
//  RequestVC.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/10.
//  Copyright © 2019 apple. All rights reserved.
//

#import "RequestVC.h"

#import "TZImageManager.h"
#import "UIImage+QRImage.h"

@interface RequestVC ()

@property(nonatomic, strong) UIView *maskView; //蒙版遮罩
@property(nonatomic, strong) UIImageView *bgView; //收款背景图

@property(nonatomic, strong) UIImageView *QRImg; //地址二维码图片
@property(nonatomic, strong) UILabel *address;//地址
@property(nonatomic, strong) UIButton *addressaCopy; //复制地址
@property(nonatomic, strong) UIButton *saveQR; //保存二维码

@end

@implementation RequestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.address.text = self.addressStr;
    self.QRImg.image = [UIImage createQRImgae:self.address.text size:AdaptedWidth(195) centerImg:nil centerImgSize:0];
    
    self.addressaCopy.selected = NO;
}

-(void)viewWillAppear:(BOOL)animated{
   
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self.maskView];
    
    self.maskView.frame = CGRectMake(0, window.frame.size.height, window.frame.size.width, 0);
    [self.maskView addSubview:self.bgView];
    
    [self.maskView addSubview:self.QRImg];
    [self.maskView addSubview:self.address];
    [self.maskView addSubview:self.addressaCopy];
    [self.maskView addSubview:self.saveQR];
    
    
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.maskView.mas_centerX);
        make.centerY.mas_equalTo(self.maskView.mas_centerY);
        make.width.mas_equalTo(AdaptedWidth(320));
        make.height.mas_equalTo(AdaptedWidth(430));
    }];
    
    [self.QRImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView.mas_centerX);
        make.top.mas_equalTo(self.bgView.mas_top).mas_offset(AdaptedWidth(40));
        make.height.width.mas_equalTo(AdaptedWidth(195));
    }];
    [self.address mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.QRImg.mas_centerX);
        make.top.mas_equalTo(self.QRImg.mas_bottom).mas_offset(AdaptedWidth(25));
    }];
    [self.addressaCopy mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.address.mas_centerX);
        make.top.mas_equalTo(self.address.mas_bottom).mas_offset(AdaptedWidth(15));
        make.width.mas_equalTo(AdaptedWidth(75));
        make.height.mas_equalTo(AdaptedWidth(30));
    }];
    [self.saveQR mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView.mas_centerX);
        make.bottom.mas_equalTo(self.bgView.mas_bottom).mas_offset(AdaptedWidth(-30));
        make.width.mas_equalTo(AdaptedWidth(195));
        make.height.mas_equalTo(AdaptedWidth(40));
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
       self.maskView.frame = CGRectMake(0, 0, window.frame.size.width, window.frame.size.height);
    }];
}

#pragma mark ---- Action
-(void)backAction:(UITapGestureRecognizer *)gesture{
    [self.maskView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}
//复制地址
-(void)addressCopyAction:(UIButton *)sender{
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    board.string = self.addressStr;
    [MBProgressHUD showMessage:@"地址已复制到剪贴板" toView:[[UIApplication sharedApplication].windows lastObject] afterDelay:0.5 animted:YES];
    self.addressaCopy.selected = YES;
}
//保存二维码
-(void)saveQRAction:(UIButton *)sender{
    [[TZImageManager manager] savePhotoWithImage:self.QRImg.image completion:^(NSError *error) {
        if (error) {
            [MBProgressHUD showMessage:@"保存二维码失败" toView:[[UIApplication sharedApplication].windows lastObject] afterDelay:0.5 animted:YES];
        }else{
            [MBProgressHUD showMessage:@"保存二维码成功" toView:[[UIApplication sharedApplication].windows lastObject] afterDelay:0.5 animted:YES];
        }
    }];
}

#pragma mark ---- getter
-(UIView *)maskView{
    if (_maskView == nil) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = kColorWithHexValueA(0x303030, 0.3);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backAction:)];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}
-(UIImageView *)bgView{
    if (_bgView == nil) {
        _bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"transfer_request_bg"]];
    }
    return _bgView;
}

-(UIImageView *)QRImg{
    if (_QRImg == nil) {
        _QRImg = [[UIImageView alloc] init];
    }
    return _QRImg;
}
-(UILabel *)address{
    if (_address == nil) {
        _address = [[UILabel alloc] init];
        _address.font = AdaptedFontSize(12);
        _address.textColor = kColorAuxiliary2;
    }
    return _address;
}
-(UIButton *)addressaCopy{
    if (_addressaCopy == nil) {
        _addressaCopy = [[UIButton alloc] init];
        [_addressaCopy setTitle:NSLocalizedString(@"copyAddress", @"复制地址") forState:UIControlStateNormal];
        _addressaCopy.titleLabel.font  = AdaptedFontSize(12);
        UIImage *img = [UIImage imageNamed:@"btn_bg_blue"];
        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height/2.0, img.size.width/2.0, img.size.height/2.0, img.size.width/2.0) resizingMode:UIImageResizingModeStretch];
        UIImage *lightImg = [UIImage imageNamed:@"btn_bg_lightBlue"];
        lightImg = [lightImg resizableImageWithCapInsets:UIEdgeInsetsMake(lightImg.size.height/2.0, lightImg.size.width/2.0, lightImg.size.height/2.0, lightImg.size.width/2.0) resizingMode:UIImageResizingModeStretch];
        [_addressaCopy setBackgroundImage:img forState:UIControlStateNormal];
        [_addressaCopy setBackgroundImage:lightImg forState:UIControlStateSelected];
        [_addressaCopy addTarget:self action:@selector(addressCopyAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _addressaCopy;
}
-(UIButton *)saveQR{
    if (_saveQR == nil) {
        _saveQR = [[UIButton alloc] init];
        [_saveQR setTitle:NSLocalizedString(@"saveQRCode", @"保存二维码") forState:UIControlStateNormal];
        UIImage *img = [UIImage imageNamed:@"btn_bg_blue"];
        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height/2.0, img.size.width/2.0, img.size.height/2.0, img.size.width/2.0) resizingMode:UIImageResizingModeStretch];
        [_saveQR setBackgroundImage:img forState:UIControlStateNormal];
        [_saveQR addTarget:self action:@selector(saveQRAction:) forControlEvents:UIControlEventTouchUpInside];
        _saveQR.titleLabel.font = AdaptedFontSize(15);
    }
    return _saveQR;
}

-(void)setAddressStr:(NSString *)addressStr{
    if ([addressStr hasPrefix:@"0x"]) {
        _addressStr = addressStr;
    }else{
        NSString *str = [NSString stringWithFormat:@"0x%@", addressStr];
        _addressStr = str;
    }
}
@end
