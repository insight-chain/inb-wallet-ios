//
//  TransferHeaderView.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/18.
//  Copyright © 2019 apple. All rights reserved.
//

#import "TransferHeaderView.h"
@interface TransferHeaderView()
@property(nonatomic, strong) UIImageView *img;

@end

@implementation TransferHeaderView

-(instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.img];
        [self addSubview:self.resultLabel];
        [self addSubview:self.valueLabel];
        UIView *sepView = [[UIView alloc] init];
        sepView.backgroundColor = kColorBackground;
        [self addSubview:sepView];
        
        [self.img mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(AdaptedWidth(25));
            make.width.height.mas_equalTo(AdaptedWidth(50));
        }];
        [self.resultLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.img.mas_centerX);
            make.top.mas_equalTo(self.img.mas_bottom).mas_offset(AdaptedWidth(20));
        }];
        [self.valueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.resultLabel.mas_centerX);
            make.top.mas_equalTo(self.resultLabel.mas_bottom).mas_offset(AdaptedWidth(20));
            make.width.mas_lessThanOrEqualTo(KWIDTH - 30);
        }];
        [sepView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(AdaptedWidth(8));
            make.top.mas_equalTo(self.valueLabel.mas_bottom).mas_offset(AdaptedWidth(20));
            make.bottom.mas_equalTo(self);
        }];
        
    }
    return self;
}
#pragma mark ----
-(UIImageView *)img{
    if (_img == nil) {
        _img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success"]];
    }
    return _img;
}
-(UILabel *)resultLabel{
    if (_resultLabel == nil) {
        _resultLabel = [[UILabel alloc] init];
        _resultLabel.font = AdaptedFontSize(15);
        _resultLabel.textColor = kColorTitle;
    }
    return _resultLabel;
}
-(UILabel *)valueLabel{
    if (_valueLabel == nil) {
        _valueLabel = [[PaddingLabel alloc] init];
        _valueLabel.textColor = kColorBlue;
        _valueLabel.font = AdaptedBoldFontSize(30);
        _valueLabel.textAlignment = NSTextAlignmentLeft;
        _valueLabel.numberOfLines = 0;
    }
    return _valueLabel;
}
@end


#pragma mark ----
@interface TransferHeaderVoteView()
@property (nonatomic, strong) UIImageView *bgImg;
@end

@implementation TransferHeaderVoteView

-(instancetype)initWithTitle:(NSString *)title info:(NSString *)info{
    if (self = [super init]) {
        self.titleLabel.text = title;
        self.infoLabel.text = info;
        
        self.frame = CGRectMake(0, 0, KWIDTH, 200);
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.bgImg];
        [self addSubview:self.infoLabel];
        
        [self makeconstrains];
        
        [self layoutIfNeeded];
    }
    return self;
}

-(void)makeconstrains{
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self).mas_offset(10);
    }];
    [self.bgImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(self.mas_left).mas_offset(15);
        make.right.mas_equalTo(self.mas_right).mas_offset(-15);
        make.bottom.mas_equalTo(self.infoLabel.mas_bottom).mas_offset(10);
    }];
    [self.infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgImg.mas_top).mas_offset(10);
        make.left.mas_equalTo(self.bgImg.mas_left).mas_offset(10);
        make.right.mas_equalTo(self.bgImg.mas_right).mas_offset(-10);
    }];
}

-(double)viewHeight{
//    [self.infoLabel sizeToFit];
    [self layoutSubviews];
    [self layoutIfNeeded];
    return CGRectGetMaxY(self.bgImg.frame);
}

-(UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = AdaptedFontSize(15);
        _titleLabel.textColor = kColorTitle;
    }
    return _titleLabel;
}
-(UIImageView *)bgImg{
    if (_bgImg == nil) {
        _bgImg = [[UIImageView alloc] init];
        _bgImg.image = [UIImage imageNamed:@"label_bg"];
    }
    return _bgImg;
}
-(UILabel *)infoLabel{
    if (_infoLabel == nil) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.font = [UIFont systemFontOfSize:15];
        _infoLabel.textColor = kColorBlue;
        _infoLabel.numberOfLines = 0;
    }
    return _infoLabel;
}
@end
