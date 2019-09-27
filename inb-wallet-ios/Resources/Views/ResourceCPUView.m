//
//  ResourceCPUView.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/8.
//  Copyright © 2019 apple. All rights reserved.
//

#import "ResourceCPUView.h"
@interface ResourceCPUView()
@property(nonatomic, strong) UIImageView *bgImg;

@property(nonatomic, strong) UILabel *cpuLabel; //"CPU资源"
@property(nonatomic, strong) UILabel *balanceLabel; //"剩余资源"

@property(nonatomic, strong) UILabel *totalLabel;   //"总量"

@property(nonatomic, strong) UIImageView *balaceImg;
@property(nonatomic, strong) UIImageView *totalImg;
@property(nonatomic, strong) UILabel *mortgageLabel; //抵押

@property(nonatomic, strong) UILabel *redemptionLabel; //赎回

@property (nonatomic, strong) UIButton *resetBtn; //资源重置

@end

@implementation ResourceCPUView
-(instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.bgImg];
        [self addSubview:self.cpuLabel];
        [self addSubview:self.balanceLabel];
        [self addSubview:self.balanceValue];
        [self addSubview:self.totalLabel];
        [self addSubview:self.totalValue];
        [self addSubview:self.balaceImg];
        [self addSubview:self.totalImg];
        [self addSubview:self.mortgageLabel];
        [self addSubview:self.mortgageValue];
        [self addSubview:self.redemptionLabel];
        [self addSubview:self.redemptionValue];
        [self addSubview:self.mortgageLabel];
        [self addSubview:self.mortgageValue];
        [self addSubview:self.redemptionLabel];
        [self addSubview:self.redemptionValue];
        
        [self makeConstraints];
        
        self.balanceValue.text = @"122ms";
        self.totalValue.text = @"320ms";
        self.mortgageValue.text = @"99.99 INB";
        self.redemptionValue.text = @"--";
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.bgImg];
        [self addSubview:self.cpuLabel];
        [self addSubview:self.balanceLabel];
        [self addSubview:self.balanceValue];
        [self addSubview:self.totalLabel];
        [self addSubview:self.totalValue];
        [self addSubview:self.balaceImg];
        [self addSubview:self.totalImg];
        [self addSubview:self.mortgageLabel];
        [self addSubview:self.mortgageValue];
        [self addSubview:self.redemptionLabel];
        [self addSubview:self.redemptionValue];
        
        self.balanceValue.text = @"122kb";
        self.totalValue.text = @"320kb";
        self.mortgageValue.text = @"99.99 INB";
        self.redemptionValue.text = @"--";
        
        [self makeConstraints];
        [self layoutIfNeeded];
        frame.size.height = CGRectGetMaxY(self.bgImg.frame);
        self.frame = frame;
    }
    return self;
}
-(void)makeConstraints{
    [self.bgImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20-7);
        make.left.mas_equalTo(15-7);
        make.right.mas_equalTo(-(15-7));
        make.bottom.mas_equalTo(self.redemptionLabel.mas_bottom).mas_offset(20+7);
    }];
    [self.cpuLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgImg.mas_top).mas_offset(20+7);
        make.left.mas_equalTo(self.bgImg.mas_left).mas_offset(15+7);
    }];
    [self.balanceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.cpuLabel.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(self.cpuLabel.mas_left);
    }];
    [self.balanceValue mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.balanceLabel.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(self.balanceLabel.mas_left);
    }];
    [self.totalLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.balanceLabel);
        make.right.mas_equalTo(self.bgImg.mas_right).mas_offset(-(15+7));
    }];
    [self.totalValue mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.balanceValue);
        make.right.mas_equalTo(self.totalLabel.mas_right);
    }];
    
    [self.balaceImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.balanceValue.mas_bottom).mas_offset(15);//AdaptedWidth
        make.left.mas_equalTo(self.balanceValue.mas_left);
        make.right.mas_equalTo(self.totalImg.mas_left);
        make.width.mas_equalTo(self.totalImg.mas_width).multipliedBy(0.5);
        make.width.mas_greaterThanOrEqualTo((12)).priorityHigh();//AdaptedWidth
    }];
    [self.totalImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.balaceImg);
        make.right.mas_equalTo(self.totalValue.mas_right);
        make.width.mas_greaterThanOrEqualTo(AdaptedWidth(12));
    }];
    [self.mortgageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.balaceImg.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(self.balaceImg.mas_left);
    }];
    [self.mortgageValue mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mortgageLabel);
        make.right.mas_equalTo(self.totalImg.mas_right);
    }];
    [self.redemptionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mortgageLabel.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(self.mortgageLabel);
    }];
    [self.redemptionValue mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.redemptionLabel);
        make.right.mas_equalTo(self.mortgageValue.mas_right);
    }];
}

-(void)updataProgress{
    double canUse = [self.balanceValue.text doubleValue];
    double total = [self.totalValue.text doubleValue];
    double ratio;
    if(total <= 0){
        ratio = 1;
    }else{
        ratio = canUse/total;
    }
    
    // 告诉self.view约束需要更新
    [self setNeedsUpdateConstraints];
    // 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
    [self updateConstraintsIfNeeded];
    
    [self layoutIfNeeded];
    double totalWidth = CGRectGetWidth(self.balaceImg.frame)+CGRectGetWidth(self.totalImg.frame);
    CGRect blueRect = self.balaceImg.frame;
    blueRect.size = CGSizeMake((totalWidth*ratio >= totalWidth-12) ? totalWidth-12 : totalWidth*ratio , blueRect.size.height);
    self.balaceImg.frame = blueRect;
    CGRect grayRect = self.totalImg.frame;
    grayRect.origin = CGPointMake(CGRectGetMaxX(self.balaceImg.frame), grayRect.origin.y);
    grayRect.size = CGSizeMake(totalWidth-CGRectGetWidth(self.balaceImg.frame), grayRect.size.height);
    self.totalImg.frame = grayRect;
}

-(UIImageView *)bgImg{
    if (_bgImg == nil) {
        _bgImg = [[UIImageView alloc] init];
        
        UIImage *img = [UIImage imageNamed:@"wallet_cpu_bg"];
        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height/2.0, img.size.width/2.0, img.size.height/2.0, img.size.width/2.0) resizingMode:UIImageResizingModeStretch];
        _bgImg.image = img;
    }
    return _bgImg;
}
-(UILabel *)cpuLabel{
    if (_cpuLabel == nil) {
        _cpuLabel = [[UILabel alloc] init];
        _cpuLabel.text = NSLocalizedString(@"Resource", @"资源(RES)");
        _cpuLabel.font = AdaptedBoldFontSize(15);
        _cpuLabel.textColor = kColorTitle;
    }
    return _cpuLabel;
}
-(UILabel *)balanceLabel{
    if (_balanceLabel == nil) {
        _balanceLabel = [[UILabel alloc] init];
        _balanceLabel.text = NSLocalizedString(@"remaining", @"剩余");
        _balanceLabel.font = AdaptedFontSize(12);
        _balanceLabel.textColor = kColorAuxiliary2;
    }
    return _balanceLabel;
}
-(UILabel *)balanceValue{
    if (_balanceValue == nil) {
        _balanceValue = [[UILabel alloc] init];
        _balanceValue.font = AdaptedFontSize(15);
        _balanceValue.textColor = kColorTitle;
    }
    return _balanceValue;
}
-(UILabel *)totalLabel{
    if (_totalLabel == nil) {
        _totalLabel = [[UILabel alloc] init];
        _totalLabel.text = NSLocalizedString(@"total", @"总量");
        _totalLabel.font = AdaptedFontSize(12);
        _totalLabel.textColor = kColorAuxiliary2;
    }
    return _totalLabel;
}
-(UILabel *)totalValue{
    if (_totalValue == nil) {
        _totalValue = [[UILabel alloc] init];
        _totalValue.font = AdaptedFontSize(15);
        _totalValue.textColor = kColorTitle;
    }
    return _totalValue;
}

-(UIImageView *)balaceImg{
    if (_balaceImg == nil) {
        UIImage *img = [UIImage imageNamed:@"wallet_progress_blue"];
        _balaceImg = [[UIImageView alloc] initWithImage:[img resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, img.size.width-1) resizingMode:UIImageResizingModeStretch]];
    }
    return _balaceImg;
}
-(UIImageView *)totalImg{
    if(_totalImg == nil){
        UIImage *img = [UIImage imageNamed:@"wallet_progress_gray"];
        _totalImg = [[UIImageView alloc] initWithImage:[img resizableImageWithCapInsets:UIEdgeInsetsMake(0, img.size.width-1, 0, 1) resizingMode:UIImageResizingModeStretch]];
    }
    return _totalImg;
}
-(UILabel *)mortgageLabel{
    if (_mortgageLabel == nil) {
        _mortgageLabel = [[UILabel alloc] init];
        _mortgageLabel.text = NSLocalizedString(@"Resource.hasMortgage", @"已抵押");
        _mortgageLabel.font = AdaptedFontSize(15);
        _mortgageLabel.textColor = kColorTitle;
    }
    return _mortgageLabel;
}
-(UILabel *)mortgageValue{
    if (_mortgageValue == nil) {
        _mortgageValue = [[UILabel alloc] init];
        _mortgageValue.textColor = kColorBlue;
        _mortgageValue.font = AdaptedFontSize(15);
    }
    return _mortgageValue;
}
-(UILabel *)redemptionLabel{
    if (_redemptionLabel == nil) {
        _redemptionLabel = [[UILabel alloc] init];
        _redemptionLabel.text = NSLocalizedString(@"redemption", @"赎回");
        _redemptionLabel.textColor = kColorTitle;
        _redemptionLabel.font = AdaptedFontSize(15);
    }
    return _redemptionLabel;
}
-(UILabel *)redemptionValue{
    if (_redemptionValue == nil) {
        _redemptionValue = [[UILabel alloc] init];
        _redemptionValue.textColor = kColorBlue;
        _redemptionValue.font = AdaptedFontSize(15);
    }
    return _redemptionValue;
}
@end
