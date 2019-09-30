//
//  VoteDetailHeaderView.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/23.
//  Copyright © 2019 apple. All rights reserved.
//

#import "VoteDetailHeaderView.h"

#import "UIButton+Layout.h"

#import "PaddingLabel.h"

@interface VoteDetailHeaderView()

@property(nonatomic, strong) UIImageView *bgImg;
@property(nonatomic, strong) UILabel *titleLabel; //"已抵押资源"
@property(nonatomic, strong) UILabel *mortgageValue; //已抵押的资源值 99.00 INB
@property(nonatomic, strong) UILabel *balanceValue; //"账户余额：1000.0000 INB"

@property(nonatomic, strong) UIImageView *contentBgImg;
@property(nonatomic, strong) UILabel *voteTotalLabel; //"投票"

@property(nonatomic, strong) UILabel *INBLabel_1;
@property(nonatomic, strong) UILabel *cpuLabel; //"+CPU"
@property(nonatomic, strong) UITextField *cpuValue;
@property(nonatomic, strong) UILabel *INBLabel_2; //"INB"

@property(nonatomic, strong) UIButton *addMortgageBtn; //新增抵押资源按钮
@property(nonatomic, strong) UILabel *addMortgageLabel; //"新增抵押资源"

@end

@implementation VoteDetailHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self makeSubViews];
        
        NSString *str = [NSString stringWithFormat:@"%.4f INB", self.mortgageINB];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:AdaptedBoldFontSize(30), NSForegroundColorAttributeName:[UIColor whiteColor]}];
        [attrStr setAttributes:@{NSFontAttributeName:AdaptedBoldFontSize(20), NSForegroundColorAttributeName:[UIColor whiteColor]} range:[str rangeOfString:@"INB"]];
        self.mortgageValue.attributedText = attrStr;
        
        self.balanceValue.text = [NSString stringWithFormat:@"%@: %.4f INB", NSLocalizedString(@"accountBalance", @"账户余额"), self.balanceINB];
        
        self.voteTotalValue.text = [NSString stringWithFormat:@"%.4f", 0.00];
        self.cpuValue.text = [NSString stringWithFormat:@"%d", 0]; 
    }
    return self;
}

-(void)makeSubViews{
    [self addSubview:self.bgImg];
    [self addSubview:self.titleLabel];
    [self addSubview:self.mortgageValue];
    [self addSubview:self.balanceValue];
    
    [self addSubview:self.contentBgImg];
    [self addSubview:self.voteTotalLabel];
    [self addSubview:self.voteTotalValue];
    [self addSubview:self.INBLabel_1];
    [self addSubview:self.cpuLabel];
    [self addSubview:self.cpuValue];
    [self addSubview:self.INBLabel_2];
    
    [self addSubview:self.addMortgageBtn];
    
    [self.bgImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(AdaptedHeight(264));
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        if(iPhoneX){
            make.top.mas_equalTo(AdaptedWidth(81)+24);
        }else{
            make.top.mas_equalTo(AdaptedWidth(81));
        }
    }];
    [self.mortgageValue mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.titleLabel.mas_centerX);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(AdaptedWidth(20));
    }];
    [self.balanceValue mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mortgageValue.mas_centerX);
        make.top.mas_equalTo(self.mortgageValue.mas_bottom).mas_offset(AdaptedWidth(20));
    }];
    [self.contentBgImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgImg.mas_bottom).mas_offset(AdaptedWidth(-60));
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.addMortgageBtn.mas_bottom).mas_offset(AdaptedWidth(20+20));
    }];
    [self.voteTotalLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentBgImg.mas_top).mas_offset(AdaptedWidth(30));
        make.left.mas_equalTo(self.contentBgImg.mas_left).mas_offset(AdaptedWidth(15+20));
    }];
    [self.voteTotalValue mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.voteTotalLabel.mas_centerY);
        make.right.mas_equalTo(self.INBLabel_1.mas_left).mas_offset(AdaptedWidth(-10));
    }];
    [self.INBLabel_1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.voteTotalValue.mas_centerY);
        make.right.mas_equalTo(self.contentBgImg.mas_right).mas_offset(AdaptedWidth(-(15+20)));
    }];
    [self.cpuLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.voteTotalLabel.mas_left);
        make.centerY.mas_equalTo(self.cpuValue);
    }];
    [self.cpuValue mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.voteTotalLabel.mas_bottom).mas_offset(AdaptedWidth(15));
        make.right.mas_equalTo(self.voteTotalValue.mas_right);
        make.height.mas_equalTo(AdaptedWidth(40));
        make.width.mas_equalTo(self.cpuValue.mas_height).multipliedBy(218.0/40.0);
    }];
    [self.INBLabel_2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.cpuValue);
        make.right.mas_equalTo(self.INBLabel_1);
    }];
    [self.addMortgageBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.cpuValue.mas_bottom).mas_offset(AdaptedWidth(20));
        make.centerX.mas_equalTo(self.contentBgImg);
        make.height.mas_equalTo(AdaptedWidth(60));
    }];
    
    
    [self layoutIfNeeded];
    [self.addMortgageBtn topImgbelowTitle:AdaptedWidth(5)];
    self.cpuValue.layer.cornerRadius = 4;
    self.cpuValue.layer.masksToBounds = YES;
    CGRect fr = self.frame;
    fr.size.height = CGRectGetMaxY(self.contentBgImg.frame);
    self.frame = fr;
}

-(void)setMortgageINB:(double)mortgageINB{
    _mortgageINB = mortgageINB;
    
    NSString *str = [NSString stringWithFormat:@"%.4f INB", self.mortgageINB];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:AdaptedBoldFontSize(30), NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [attrStr setAttributes:@{NSFontAttributeName:AdaptedBoldFontSize(20), NSForegroundColorAttributeName:[UIColor whiteColor]} range:[str rangeOfString:@"INB"]];
    self.mortgageValue.attributedText = attrStr;
}
-(void)setBalanceINB:(double)balanceINB{
    _balanceINB = balanceINB;
    self.balanceValue.text = [NSString stringWithFormat:@"%@: %.4f INB", NSLocalizedString(@"accountBalance", @"账户余额"), self.balanceINB];
}

#pragma mark ---- Button Action
//新增抵押资源
-(void)addMortgageAction:(UIButton *)sender{
    if (self.addMortgageBlock) {
        if ([self.cpuValue.text isEqualToString:@""] || self.cpuValue.text == nil) {
            self.addMortgageBlock(0);
        }else{
            self.addMortgageBlock([self.cpuValue.text doubleValue]);
        }
    }
}
#pragma mark ---- setter && getter
-(UIImageView *)bgImg{
    if (_bgImg == nil) {
        _bgImg = [[UIImageView alloc] init];
        UIImage *img = [UIImage imageNamed:@"voteDetail_header_bg"];
        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height-5, img.size.width/2.0, 5, img.size.width/2.0) resizingMode:UIImageResizingModeStretch];
        _bgImg.image = img;
    }
    return _bgImg;
}
-(UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = AdaptedFontSize(15);
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = NSLocalizedString(@"pledgedResources", @"已抵押资源");
    }
    return _titleLabel;
}
-(UILabel *)mortgageValue{
    if (_mortgageValue == nil) {
        _mortgageValue = [[UILabel alloc] init];
        _mortgageValue.textColor = [UIColor whiteColor];
        _mortgageValue.font = AdaptedBoldFontSize(30);
    }
    return _mortgageValue;
}
-(UILabel *)balanceValue{
    if (_balanceValue == nil) {
        _balanceValue = [[UILabel alloc] init];
        _balanceValue.font = AdaptedFontSize(15);
        _balanceValue.textColor = [UIColor whiteColor];
    }
    return _balanceValue;
}
-(UIImageView *)contentBgImg{
    if (_contentBgImg == nil) {
        _contentBgImg = [[UIImageView alloc] init];
        UIImage *img = [UIImage imageNamed:@"voteDetail_header_content_bg"];
        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height/2.0, img.size.width/2.0, img.size.height/2.0, img.size.width/2.0) resizingMode:UIImageResizingModeStretch];
        _contentBgImg.image = img;
    }
    return _contentBgImg;
}
-(UILabel *)voteTotalLabel{
    if (_voteTotalLabel == nil) {
        _voteTotalLabel = [[UILabel alloc] init];
        _voteTotalLabel.textColor = kColorTitle;
        _voteTotalLabel.font = AdaptedFontSize(15);
        _voteTotalLabel.text = NSLocalizedString(@"voteTotal", @"投票总数");
    }
    return _voteTotalLabel;
}
-(UILabel *)voteTotalValue{
    if (_voteTotalValue == nil) {
        _voteTotalValue = [[UILabel alloc] init];
        _voteTotalValue.font = AdaptedFontSize(15);
        _voteTotalValue.textColor = kColorBlue;
    }
    return _voteTotalValue;
}
-(UILabel *)INBLabel_1{
    if (_INBLabel_1 == nil) {
        _INBLabel_1 = [[UILabel alloc] init];
        _INBLabel_1.text = @"INB";
        _INBLabel_1.textColor = kColorBlue;
        _INBLabel_1.font = AdaptedFontSize(15);
    }
    return _INBLabel_1;
}
-(UILabel *)cpuLabel{
    if (_cpuLabel == nil ) {
        _cpuLabel = [[UILabel alloc] init];
        _cpuLabel.text = @"+NET";
        _cpuLabel.textColor = kColorTitle;
        _cpuLabel.font = AdaptedFontSize(15);
    }
    return _cpuLabel;
}
-(UITextField *)cpuValue{
    if (_cpuValue == nil) {
        _cpuValue = [[UITextField alloc] init];
        _cpuValue.font = AdaptedFontSize(15);
        _cpuValue.textColor = kColorBlue;
        _cpuValue.backgroundColor = kColorBackground;
        _cpuValue.layer.borderWidth = 1;
        _cpuValue.layer.borderColor = kColorSeparate.CGColor;
        _cpuValue.textAlignment = NSTextAlignmentRight;
//        _cpuValue.delegate = self;
        UIView *rightV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
        _cpuValue.rightView = rightV;
        _cpuValue.rightViewMode = UITextFieldViewModeAlways;
    }
    return _cpuValue;
}
-(UILabel *)INBLabel_2{
    if (_INBLabel_2 == nil) {
        _INBLabel_2 = [[UILabel alloc] init];
        _INBLabel_2.text = @"INB";
        _INBLabel_2.textColor = kColorTitle;
        _INBLabel_2.font = AdaptedFontSize(15);
    }
    return _INBLabel_2;
}
-(UIButton *)addMortgageBtn{
    if (_addMortgageBtn == nil) {
        _addMortgageBtn = [[UIButton alloc] init];
        [_addMortgageBtn setImage:[UIImage imageNamed:@"addMortgage"] forState:UIControlStateNormal];
        [_addMortgageBtn setTitle:NSLocalizedString(@"addMortgageResources", @"新增抵押") forState:UIControlStateNormal];
        [_addMortgageBtn setTitleColor:kColorTitle forState:UIControlStateNormal];
        _addMortgageBtn.titleLabel.font = AdaptedFontSize(15);
        _addMortgageBtn.titleLabel.textColor = kColorTitle;
        [_addMortgageBtn addTarget:self action:@selector(addMortgageAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addMortgageBtn;
}
@end
