//
//  PasswordInputView.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/6/17.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "PasswordInputView.h"
@interface PasswordInputView()
@property(nonatomic, copy) void (^confirmBlock)(NSString * _Nonnull password);
@end

@interface PasswordInputView()
@property(nonatomic, strong) UIView *maskView;
@property(nonatomic, strong) UIImageView *bgImgView;

@property(nonatomic, strong) UIView *lineView;
@property(nonatomic, strong) UITextField *passwordTF;

@property(nonatomic, strong) UIButton *cancelBtn;
@property(nonatomic, strong) UIButton *confirmBtn; //确认按钮
@end


@implementation PasswordInputView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self makeConstraints];
        [self.passwordTF becomeFirstResponder];
        
        #pragma mark -键盘弹出添加监听事件
        // 键盘出现的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
        // 键盘消失的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHiden:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}
-(instancetype)init{
    if (self = [super init]) {
        
        [self makeConstraints];
       
        [self.passwordTF becomeFirstResponder];
        #pragma mark -键盘弹出添加监听事件
        // 键盘出现的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
        // 键盘消失的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHiden:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)makeConstraints{
    [self addSubview:self.maskView];
    [self addSubview:self.bgImgView];
    [self addSubview:self.cancelBtn];
    [self addSubview:self.passwordTF];
    [self addSubview:self.lineView];
    [self addSubview:self.confirmBtn];
    
    [self.maskView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    [self.bgImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(275);
        make.height.mas_equalTo(self.bgImgView.mas_width).multipliedBy(67.0/69.0);
    }];
    [self.cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgImgView.mas_top).mas_offset(5);
        make.right.mas_equalTo(self.bgImgView.mas_right).mas_offset(-5);
        make.width.height.mas_equalTo(20);
    }];
    [self.passwordTF mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgImgView.mas_left).mas_offset(20);
        make.right.mas_equalTo(self.bgImgView.mas_right).mas_offset(-20);
        make.bottom.mas_equalTo(self.lineView.mas_top).mas_offset(-10);
    }];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgImgView.mas_left).mas_offset(15);
        make.right.mas_equalTo(self.bgImgView.mas_right).mas_offset(-15);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(self.confirmBtn.mas_top).mas_offset(-20);
    }];
    [self.confirmBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bgImgView.mas_bottom).mas_offset(-20);
        make.centerX.mas_equalTo(self.bgImgView.mas_centerX);
        make.width.mas_equalTo(AdaptedWidth(195));
        make.height.mas_equalTo(40);
    }];
}

+(instancetype)showPasswordInputWithConfirmClock:(void (^)(NSString * _Nonnull))confirmBlock{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    PasswordInputView *passwordView = [[PasswordInputView alloc] initWithFrame:window.bounds];
    passwordView.confirmBlock = confirmBlock;
    [window addSubview:passwordView];
    return passwordView;
}

#pragma mark ---- 通知action
-(void)keyboardWasShown:(NSNotification *)noti{
    CGRect rect = self.frame;
    rect.origin.y -= 50;
    self.frame = rect;
}
-(void)keyboardWillBeHiden:(NSNotification *)noti{
    self.frame = CGRectMake(0, 0, KWIDTH, KHEIGHT);
}

#pragma mark ---- Action
//取消
-(void)cancelAction:(UIButton *)sender{
    [self removeFromSuperview];
}
-(void)confirmAction:(UIButton *)sender{
    if(![self.passwordTF.text isEqualToString:@""]){
        if (self.confirmBlock) {
            self.confirmBlock(self.passwordTF.text);
        }
    }else{
        
    }
}
-(void)hidePasswordInput{
    [self removeFromSuperview];
}

#pragma mark ----
-(UIView *)maskView{
    if (_maskView == nil) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = kColorWithRGBA(0, 0, 0, 0.3);
        _maskView.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideListView)];
//        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}
-(UIButton *)cancelBtn{
    if (_cancelBtn == nil) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

-(UIImageView *)bgImgView{
    if (_bgImgView == nil) {
        _bgImgView = [[UIImageView alloc] init];
        UIImage *bgImg = [UIImage imageNamed:@"passwordInput_bg"];
//        bgImg = [bgImg resizableImageWithCapInsets:UIEdgeInsetsMake(bgImg.size.height-10, bgImg.size.width/2.0, 10, bgImg.size.width/2.0)
//                                      resizingMode:UIImageResizingModeStretch];
        _bgImgView.image = bgImg;
    }
    return _bgImgView;
}
-(UIButton *)confirmBtn{
    if (_confirmBtn == nil) {
        _confirmBtn = [[UIButton alloc] init];
        UIImage *bgImg = [UIImage imageNamed:@"btn_bg_blue"];
        bgImg = [bgImg resizableImageWithCapInsets:UIEdgeInsetsMake(bgImg.size.height/2.0, bgImg.size.width/2.0, bgImg.size.height/2.0, bgImg.size.width/2.0) resizingMode:UIImageResizingModeStretch];
        [_confirmBtn setBackgroundImage:bgImg forState:UIControlStateNormal];
        [_confirmBtn setTitle:NSLocalizedString(@"confirm", @"确认") forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}
-(UITextField *)passwordTF{
    if (_passwordTF == nil) {
        _passwordTF = [[UITextField alloc] init];
        _passwordTF.secureTextEntry = YES;
        _passwordTF.textColor = kColorTitle;
        _passwordTF.font = [UIFont systemFontOfSize:14];
        _passwordTF.placeholder = NSLocalizedString(@"backup.password.inputTip", @"请输入密码");
    }
    return _passwordTF;
}
-(UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = kColorWithHexValue(0xe5e5e5);
    }
    return _lineView;
}
@end
