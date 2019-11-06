//
//  SettingAboutUsHeaderView.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/26.
//  Copyright © 2019 apple. All rights reserved.
//

#import "SettingAboutUsHeaderView.h"
@interface SettingAboutUsHeaderView()
@property(nonatomic, strong) UIImageView *logoImg;
@property(nonatomic, strong) UIImageView *logoTitleImg;
@property(nonatomic, strong) UILabel *versionLabel;
@end

@implementation SettingAboutUsHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.logoImg];
        [self addSubview:self.logoTitleImg];
        [self addSubview:self.versionLabel];
        
        self.versionLabel.text = [NSString stringWithFormat:@"%@ V%@", NSLocalizedString(@"version.current", @"当前版本"), APP_VERSION];
        
        
        [self makeConstraints];
    }
    return self;
}
-(void)makeConstraints{
    [self.logoImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(AdaptedWidth(50));
        make.height.with.mas_equalTo(50);
    }];
    [self.logoTitleImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.logoImg.mas_centerX);
        make.top.mas_equalTo(self.logoImg.mas_bottom).mas_offset(25);
    }];
    [self.versionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.logoTitleImg.mas_centerX);
        make.top.mas_equalTo(self.logoTitleImg.mas_bottom).mas_offset(15);
    }];
    
    [self layoutIfNeeded];
    CGRect re = self.frame;
    re.size.height = CGRectGetMaxY(self.versionLabel.frame)+AdaptedWidth(50);
    self.frame = re;
}

-(UIImageView *)logoImg{
    if (_logoImg == nil) {
        _logoImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    }
    return _logoImg;
}
-(UIImageView *)logoTitleImg{
    if(_logoTitleImg == nil){
        _logoTitleImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"inb_wallet"]];
    }
    return _logoTitleImg;
}
-(UILabel *)versionLabel{
    if (_versionLabel == nil) {
        _versionLabel = [[UILabel alloc] init];
        _versionLabel.font = AdaptedFontSize(13);
        _versionLabel.textColor = kColorAuxiliary2;
    }
    return _versionLabel;
}
@end
