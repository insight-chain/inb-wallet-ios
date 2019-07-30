//
//  UpdateView.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/6/25.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "UpdateView.h"
@interface UpdateView()
@property(nonatomic, strong) UIView *maskView;
@property(nonatomic, strong) UIImageView *bgView;

@property(nonatomic, strong) UILabel *versionLabel;
@property(nonatomic, strong) UILabel *updateTipLabel;
@property(nonatomic, strong) UILabel *updateDescriptionLabel; //更新描述
@property(nonatomic, strong) UIButton *updateBtn;
@property(nonatomic, strong) UIButton *cancelBtn;

@property(nonatomic, copy) void(^update)(void);

@end

@implementation UpdateView

+(void)showUpadate:(NSString *)version intro:(NSString *)intro updateBlock:(void(^)(void))updateBlock{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UpdateView *upda = [[UpdateView alloc] initWithFrame:window.bounds];
    upda.versionLabel.text = version;
//    upda.updateDescriptionLabel.text = intro;
    upda.update = updateBlock;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;  //设置行间距
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:intro];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [intro length])];
    upda.updateDescriptionLabel.attributedText = attributedString;
    
    [window addSubview:upda];
}

-(instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.maskView];
        [self addSubview:self.bgView];
        [self addSubview:self.versionLabel];
        [self addSubview:self.updateTipLabel];
        [self addSubview:self.updateDescriptionLabel];
        [self addSubview:self.updateBtn];
        [self addSubview:self.cancelBtn];
        [self makeConstraints];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self addSubview:self.maskView];
        [self addSubview:self.bgView];
        [self addSubview:self.versionLabel];
        [self addSubview:self.updateTipLabel];
        [self addSubview:self.updateDescriptionLabel];
        [self addSubview:self.updateBtn];
        [self addSubview:self.cancelBtn];
        [self makeConstraints];
    }
    return self;
}

-(void)makeConstraints{
    [self.maskView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.bottom.mas_equalTo(0);
    }];
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self).mas_offset(-30);
        make.bottom.mas_equalTo(self.updateBtn.mas_bottom).mas_offset(20);
    }];
    
    [self.versionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView.mas_top).mas_offset(58);
        make.left.mas_equalTo(self.bgView.mas_left).mas_offset(25);
    }];
    [self.updateTipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.versionLabel.mas_left);
        make.top.mas_equalTo(self.versionLabel.mas_bottom).mas_offset(15);
    }];
    [self.updateDescriptionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView.mas_top).mas_offset(165);
        make.left.mas_equalTo(self.bgView.mas_left).mas_offset(50);
        make.right.mas_equalTo(self.bgView.mas_right).mas_offset(-50);
    }];
    [self.updateBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.updateDescriptionLabel.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(self.updateDescriptionLabel.mas_left).mas_offset(5);
        make.right.mas_equalTo(self.updateDescriptionLabel.mas_right).mas_offset(-5);
        make.height.mas_equalTo(35);
    }];
    [self.cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.bgView.mas_bottom);
    }];
}

-(void)updateAction{
    if (self.update) {
        self.update();
    }
    [self removeFromSuperview];
}
-(void)cancelAction{
    [self removeFromSuperview];
}

-(UIView *)maskView{
    if (_maskView == nil) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = kColorWithRGBA(0, 0, 0, 0.3);
        _maskView.userInteractionEnabled = YES;
    }
    return _maskView;
}
-(UIImageView *)bgView{
    if(_bgView == nil){
        _bgView = [[UIImageView alloc] init];
        
        UIImage *img = [UIImage imageNamed:@"update_bg"];
        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height/2.0, img.size.width/2.0, img.size.height/2.0, img.size.width/2.0) resizingMode:UIImageResizingModeStretch];
        _bgView.image = img;
    }
    return _bgView;
}

-(UILabel *)versionLabel{
    if (_versionLabel == nil) {
        _versionLabel = [[UILabel alloc] init];
        _versionLabel.font = [UIFont systemFontOfSize:14];
        _versionLabel.textColor = [UIColor whiteColor];
    }
    return _versionLabel;
}
-(UILabel *)updateTipLabel{
    if (_updateTipLabel == nil) {
        _updateTipLabel = [[UILabel alloc] init];
        _updateTipLabel.font = [UIFont systemFontOfSize:20];
        _updateTipLabel.textColor = [UIColor whiteColor];
        _updateTipLabel.text = NSLocalizedString(@"version.update", @"更新版本");
    }
    return _updateTipLabel;
}
-(UILabel *)updateDescriptionLabel{
    if (_updateDescriptionLabel == nil) {
        _updateDescriptionLabel = [[UILabel alloc] init];
        _updateDescriptionLabel.font = [UIFont systemFontOfSize:15];
        _updateDescriptionLabel.textColor = kColorWithHexValue(0x666666);
        _updateDescriptionLabel.numberOfLines = 0;
    }
    return _updateDescriptionLabel;
}

-(UIButton *)updateBtn{
    if (_updateBtn == nil) {
        _updateBtn = [[UIButton alloc] init];
        [_updateBtn setTitle:NSLocalizedString(@"version.update.immediately", @"立即更新") forState:UIControlStateNormal];
        [_updateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _updateBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        UIImage *img = [UIImage imageNamed:@"btn_version"];
        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height/2.0, img.size.width/2.0, img.size.height/2.0, img.size.width/2.0) resizingMode:UIImageResizingModeStretch];
        [_updateBtn setBackgroundImage:img forState:UIControlStateNormal];
        [_updateBtn addTarget:self action:@selector(updateAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _updateBtn;
}
-(UIButton *)cancelBtn{
    if (_cancelBtn == nil) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"update_close"] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
@end
