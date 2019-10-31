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
@property (nonatomic, strong) UILabel *canUseNumber; //节点可用投票
@property (nonatomic, strong) UILabel *balanceStr; //余额
@property(nonatomic, strong) UILabel *balanceValue; //"账户余额：1000.0000 INB"

@property(nonatomic, strong) UIImageView *contentBgImg;

@property(nonatomic, strong) UILabel *cpuLabel; //"+CPU"
@property(nonatomic, strong) UITextField *cpuValue;
@property(nonatomic, strong) UILabel *INBLabel_2; //"INB"

@property (nonatomic, strong) UIImageView *tipImg;
@property (nonatomic, strong) UILabel *tipLabel;//"每抵押1个INB可为每个节点投一票"

@property(nonatomic, strong) UIButton *addMortgageBtn; //新增抵押资源按钮

@end

@implementation VoteDetailHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self makeSubViews];
        
        NSString *str = [NSString stringWithFormat:@"%@ INB", [NSString changeNumberFormatter:[NSString stringWithFormat:@"%f",self.mortgageINB]]];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:AdaptedBoldFontSize(30), NSForegroundColorAttributeName:[UIColor whiteColor]}];
        [attrStr setAttributes:@{NSFontAttributeName:AdaptedBoldFontSize(20), NSForegroundColorAttributeName:[UIColor whiteColor]} range:[str rangeOfString:@"INB"]];
        self.mortgageValue.attributedText = attrStr;
        
        self.balanceValue.text = [NSString stringWithFormat:@"%@: %@ INB", NSLocalizedString(@"accountBalance", @"账户余额"), [NSString changeNumberFormatter:[NSString stringWithFormat:@"%f",self.balanceINB]]];
        
        self.voteTotalValue.text = [NSString stringWithFormat:@"%.2f", 0.00];
    }
    return self;
}

-(void)makeSubViews{
    [self addSubview:self.bgImg];
    [self addSubview:self.titleLabel];
    [self addSubview:self.mortgageValue];
    [self addSubview:self.canUseNumber];
    
    [self addSubview:self.contentBgImg];
//    [self addSubview:self.cpuLabel];
    [self addSubview:self.cpuValue];
    [self addSubview:self.balanceStr];
    [self addSubview:self.balanceValue];
    
    [self addSubview:self.addMortgageBtn];
    [self addSubview:self.tipImg];
    [self addSubview:self.tipLabel];
    
    [self.bgImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(AdaptedHeight(264-kNavigationBarHeight));
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        if(iPhoneX){
            make.top.mas_equalTo(AdaptedWidth(81-kNavigationBarHeight)+24);
        }else{
            make.top.mas_equalTo(AdaptedWidth(81-kNavigationBarHeight));
        }
    }];
    [self.mortgageValue mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.titleLabel.mas_centerX);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(AdaptedWidth(20));
    }];
    [self.canUseNumber mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mortgageValue.mas_centerX);
        make.top.mas_equalTo(self.mortgageValue.mas_bottom).mas_offset(AdaptedWidth(20));
    }];
    [self.contentBgImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgImg.mas_bottom).mas_offset(AdaptedWidth(-60));
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.tipLabel.mas_bottom).mas_offset(AdaptedWidth(20+20));
    }];

    [self.cpuValue mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentBgImg.mas_top).mas_offset(AdaptedWidth(30));  make.right.mas_equalTo(self.contentBgImg.mas_right).mas_offset(AdaptedWidth(-(15+20)));
        make.height.mas_equalTo(AdaptedWidth(40));
        make.left.mas_equalTo(self.contentBgImg.mas_left).mas_offset(15+20);
    }];
    [self.balanceStr mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.cpuValue);
        make.top.mas_equalTo(self.cpuValue.mas_bottom).mas_offset(10);
    }];
    [self.balanceValue mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.cpuValue);
        make.top.mas_equalTo(self.cpuValue.mas_bottom).mas_offset(10);
    }];
    [self.addMortgageBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.balanceStr.mas_bottom).mas_offset(AdaptedWidth(20));
        make.centerX.mas_equalTo(self.contentBgImg);
        make.left.mas_equalTo(self.cpuValue.mas_left);
        make.right.mas_equalTo(self.cpuValue.mas_right);
        make.height.mas_equalTo(AdaptedWidth(35));
    }];
    [self.tipImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.addMortgageBtn);
        make.top.mas_equalTo(self.addMortgageBtn.mas_bottom).mas_offset(10);
        make.width.height.mas_equalTo(15);
    }];
    [self.tipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipImg);
        make.left.mas_equalTo(self.tipImg.mas_right).mas_offset(5);
        make.right.mas_equalTo(self.addMortgageBtn);
    }];
    
    
    [self layoutIfNeeded];
//    [self.addMortgageBtn topImgbelowTitle:AdaptedWidth(5)];
    [self.addMortgageBtn leftImgRightTitle:AdaptedWidth(5)];
    self.cpuValue.layer.cornerRadius = 4;
    self.cpuValue.layer.masksToBounds = YES;
    CGRect fr = self.frame;
    fr.size.height = CGRectGetMaxY(self.contentBgImg.frame);
    self.frame = fr;
}

-(void)setMortgageINB:(double)mortgageINB{
    _mortgageINB = mortgageINB;
    
    NSString *str = [NSString stringWithFormat:@"%@ INB", [NSString changeNumberFormatter:[NSString stringWithFormat:@"%f",self.mortgageINB]]];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:AdaptedBoldFontSize(30), NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [attrStr setAttributes:@{NSFontAttributeName:AdaptedBoldFontSize(20), NSForegroundColorAttributeName:[UIColor whiteColor]} range:[str rangeOfString:@"INB"]];
    self.mortgageValue.attributedText = attrStr;
    self.canUseNumber.text = [NSString stringWithFormat:@"%@: %d", NSLocalizedString(@"confirm.vote.canuse", @"节点可用投票"), (int)_mortgageINB];
}
-(void)setBalanceINB:(double)balanceINB{
    _balanceINB = balanceINB;
    self.balanceValue.text = [NSString stringWithFormat:@"%@ INB",[NSString changeNumberFormatter:[NSString stringWithFormat:@"%f",self.balanceINB]]];
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
-(UILabel *)canUseNumber{
    if (_canUseNumber == nil) {
        _canUseNumber = [[UILabel alloc] init];
        _canUseNumber.font = AdaptedFontSize(15);
        _canUseNumber.textColor = [UIColor whiteColor];
    }
    return _canUseNumber;
}
-(UILabel *)balanceValue{
    if (_balanceValue == nil) {
        _balanceValue = [[UILabel alloc] init];
        _balanceValue.font = [UIFont systemFontOfSize:13];
        _balanceValue.textColor = kColorBlue;
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


-(UILabel *)cpuLabel{
    if (_cpuLabel == nil ) {
        _cpuLabel = [[UILabel alloc] init];
        _cpuLabel.text = @"+RES";
        _cpuLabel.textColor = kColorTitle;
        _cpuLabel.font = AdaptedFontSize(15);
    }
    return _cpuLabel;
}
-(UITextField *)cpuValue{
    if (_cpuValue == nil) {
        _cpuValue = [[UITextField alloc] init];
        _cpuValue.font = AdaptedFontSize(15);
        _cpuValue.textColor = kColorTitle;
        _cpuValue.backgroundColor = kColorBackground;
        _cpuValue.layer.borderWidth = 1;
        _cpuValue.layer.borderColor = kColorSeparate.CGColor;
        _cpuValue.textAlignment = NSTextAlignmentLeft;
//        _cpuValue.delegate = self;
        UIView *leftV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
        _cpuValue.leftView = leftV;
        _cpuValue.leftViewMode = UITextFieldViewModeAlways;
        _cpuValue.placeholder = @"请输入抵押数量";
        
        UIView *rightV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
        self.INBLabel_2.frame = CGRectMake(0, 0, 40, 20);
        [rightV addSubview:self.INBLabel_2];
        _cpuValue.rightView = rightV;
        _cpuValue.rightViewMode = UITextFieldViewModeAlways;
        
        _cpuValue.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return _cpuValue;
}
-(UILabel *)balanceStr{
    if (_balanceStr == nil) {
        _balanceStr = [[UILabel alloc] init];
        _balanceStr.textColor = kColorTitle;
        _balanceStr.font = [UIFont systemFontOfSize:13];
        _balanceStr.text = NSLocalizedString(@"balance", @"余额");
    }
    return _balanceStr;
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
        [_addMortgageBtn setImage:[UIImage imageNamed:@"btn_add_icon"] forState:UIControlStateNormal];
        [_addMortgageBtn setTitle:NSLocalizedString(@"addMortgageResources", @"新增抵押") forState:UIControlStateNormal];
        [_addMortgageBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg_blue"] forState:UIControlStateNormal];
        [_addMortgageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _addMortgageBtn.titleLabel.font = AdaptedFontSize(15);
        _addMortgageBtn.titleLabel.textColor = kColorTitle;
        [_addMortgageBtn addTarget:self action:@selector(addMortgageAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addMortgageBtn;
}
-(UIImageView *)tipImg{
    if (_tipImg == nil) {
        _tipImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"horn"]];
    }
    return _tipImg;
}
-(UILabel *)tipLabel{
    if (_tipLabel == nil) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = NSLocalizedString(@"tip.addMortgage", @"每抵押1个INB可为每个节点投一票");
        _tipLabel.textColor = kColorBlue;
        _tipLabel.font = [UIFont systemFontOfSize:14];
    }
    return _tipLabel;
}
@end
