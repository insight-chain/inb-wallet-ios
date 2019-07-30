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
