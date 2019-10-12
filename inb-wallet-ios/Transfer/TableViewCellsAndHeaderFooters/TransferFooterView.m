//
//  TransferFooterView.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/19.
//  Copyright © 2019 apple. All rights reserved.
//

#import "TransferFooterView.h"
#import "UIImage+QRImage.h"

@interface TransferFooterView()
@property(nonatomic, strong) UIImageView *labelBg;
@property(nonatomic, strong) UILabel *textLabel;
@property(nonatomic, strong) UIImageView *qrImg;
@end

@implementation TransferFooterView

-(instancetype)init{
    if (self = [super init]) {
        [self makeConstraints];
        
        self.textLabel.text = @"";
        self.qrImg.image = [UIImage createQRImgae:self.textLabel.text size:AdaptedWidth(90) centerImg:nil centerImgSize:0];
    }
    return self;
}

-(void)makeConstraints{
//    [self addSubview:self.labelBg];
//    [self addSubview:self.textLabel];
    [self addSubview:self.qrImg];
    
//    [self.labelBg mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(0);
//        make.left.mas_equalTo(AdaptedWidth(15));
//        make.right.mas_equalTo(AdaptedWidth(-15));
//        make.height.mas_equalTo(AdaptedWidth(75));
//    }];
//    [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.labelBg.mas_top).mas_offset(AdaptedWidth(15));
//        make.left.mas_equalTo(self.labelBg.mas_left).mas_offset(AdaptedWidth(10));
//        make.right.mas_equalTo(self.labelBg.mas_right).mas_offset(AdaptedWidth(-10));
//    }];
    [self.qrImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(0).mas_offset(AdaptedWidth(20));
        make.height.width.mas_equalTo(AdaptedWidth(90));
    }];
}

-(UIImageView *)labelBg{
    if (_labelBg == nil) {
        _labelBg = [[UIImageView alloc] init];
        UIImage *img = [UIImage imageNamed:@"label_bg"];
        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height/2.0, img.size.width/2.0, img.size.width/2.0, img.size.height/2.0) resizingMode:UIImageResizingModeStretch];
        _labelBg.image = img;
    }
    return _labelBg;
}
-(UILabel *)textLabel{
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = AdaptedFontSize(15);
        _textLabel.textColor = kColorAuxiliary2;
        _textLabel.numberOfLines = 0;
    }
    return _textLabel;
}
-(UIImageView *)qrImg{
    if (_qrImg == nil) {
        _qrImg = [[UIImageView alloc] init];
    }
    return _qrImg;
}

-(void)setInfo:(NSString *)info{
    _info = info;
    self.textLabel.text = info;
}
@end
