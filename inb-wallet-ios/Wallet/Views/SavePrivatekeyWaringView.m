//
//  SavePrivatekeyWaringView.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/24.
//  Copyright © 2019 apple. All rights reserved.
//

#import "SavePrivatekeyWaringView.h"

@interface SavePrivatekeyWaringView()
@property(nonatomic, strong) UIView *maskView;
@property(nonatomic, strong) UIImageView *bgImg;

@property (nonatomic, strong) UIButton *cancelBtn; //取消
@property(nonatomic, strong) UILabel *tipLabel;
@property(nonatomic, strong) UIButton *knowBtn;
@property(nonatomic, copy) void(^konwBlock)(void);
@property(nonatomic, copy) void(^cancelBlock)(void);
@end

@implementation SavePrivatekeyWaringView

+(void)showSaveWaringWith:(void(^)(void))konwBlock{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    SavePrivatekeyWaringView *saveWaring = [[SavePrivatekeyWaringView alloc] initWithFrame:window.bounds];
    saveWaring.konwBlock = konwBlock;
    [window addSubview:saveWaring];
    
}

+(void)showBackupTipWithImg:(UIImage *)tipImg title:(NSString *)tipTitle confirmTitle:(NSString *)confirmTitle konwBlock:(void(^)(void))konwBlock cancelBlock:(void(^)(void))cancelBlock{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
   SavePrivatekeyWaringView *saveWaring = [[SavePrivatekeyWaringView alloc] initWithFrame:window.bounds];
    saveWaring.bgImg.image = tipImg;
    saveWaring.tipLabel.text = tipTitle;
   saveWaring.konwBlock = konwBlock;
    saveWaring.cancelBlock = cancelBlock;
    [saveWaring.knowBtn setTitle:confirmTitle forState:UIControlStateNormal];
   [window addSubview:saveWaring];
}


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.maskView];
        [self addSubview:self.bgImg];
        [self addSubview:self.tipLabel];
        [self addSubview:self.knowBtn];
        [self addSubview:self.cancelBtn];
        
        [self makeConstraints];
    }
    return self;
}

-(void)makeConstraints{
    [self.maskView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    [self.bgImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.maskView.mas_centerX);
        make.centerY.mas_equalTo(self.maskView.mas_centerY);
        make.width.mas_equalTo(AdaptedWidth(295));
        make.height.mas_equalTo(self.bgImg.mas_width).multipliedBy(67.0/59.0);
    }];
    [self.cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(self.bgImg);
        make.width.height.mas_equalTo(30);
    }];
    [self.tipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgImg.mas_left).mas_offset(25);
        make.right.mas_equalTo(self.bgImg.mas_right).mas_offset(-25);
        make.bottom.mas_equalTo(self.knowBtn.mas_top).mas_offset(-30);
    }];
    [self.knowBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bgImg.mas_bottom).mas_offset(-30);
        make.centerX.mas_equalTo(self.tipLabel.mas_centerX);
        make.width.mas_equalTo(195);
        make.height.mas_equalTo(40);
    }];
}

-(void)hideView{
    [self removeFromSuperview];
    self.hidden = YES;
    if(self.cancelBlock){
        self.cancelBlock();
    }
}

-(void)knowAction:(UIButton *)sender{
    [self hideView];
    if (self.konwBlock) {
        self.konwBlock();
    }
}

#pragma mark ----
-(UIView *)maskView{
    if (_maskView == nil) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = kColorWithRGBA(0, 0, 0, 0.6);
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
        [_maskView addGestureRecognizer:tapGesture];
    }
    return _maskView;
}
-(UIImageView *)bgImg{
    if (_bgImg == nil) {
        _bgImg = [[UIImageView alloc] init];
        _bgImg.image = [UIImage imageNamed:@"saveWaringBg"];
    }
    return _bgImg;
}
-(UILabel *)tipLabel{
    if (_tipLabel == nil) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = NSLocalizedString(@"saveWaringTip", @"如果有人获取到您的私钥将直接获取您的财产！请抄写下私钥并存放在安全的地方。");
        _tipLabel.font = AdaptedFontSize(14);
        _tipLabel.textColor = kColorWithHexValue(0xf5a623);
        _tipLabel.numberOfLines = 0;
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:_tipLabel.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        [attrStr addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle, NSFontAttributeName:_tipLabel.font, NSForegroundColorAttributeName:_tipLabel.textColor} range:NSMakeRange(0, _tipLabel.text.length)];
        _tipLabel.attributedText = attrStr;
        [_tipLabel sizeToFit]; //调用sizeThatFits:使用当前视图边界并更改边界大小。
    }
    return _tipLabel;
}
-(UIButton *)knowBtn{
    if (_knowBtn == nil) {
        _knowBtn = [[UIButton alloc] init];
        [_knowBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg_blue"] forState:UIControlStateNormal];
        [_knowBtn setTitle:NSLocalizedString(@"I_know", @"我知道了") forState:UIControlStateNormal];
        [_knowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_knowBtn addTarget:self action:@selector(knowAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _knowBtn;
}
-(UIButton *)cancelBtn{
    if (_cancelBtn == nil) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
@end
