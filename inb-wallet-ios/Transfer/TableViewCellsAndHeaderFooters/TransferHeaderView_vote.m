//
//  TransferHeaderView_vote.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/19.
//  Copyright © 2019 apple. All rights reserved.
//

#import "TransferHeaderView_vote.h"

@interface TransferHeaderView_vote ()
@property(nonatomic, strong) UIImageView *resultImg;
@property(nonatomic, strong) UILabel *resultLabel; //“节点投票”
@property(nonatomic, strong) UIImageView *nodesBg;   //节点背景色
@property(nonatomic, strong) UILabel *nodesLabel; //节点
@end

@implementation TransferHeaderView_vote

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self makeConstrains];
    }
    return self;
}

-(void)makeConstrains{
    [self addSubview:self.resultImg];
    [self addSubview:self.resultLabel];
    [self addSubview:self.nodesBg];
    [self addSubview:self.nodesLabel];
    
    [self.resultImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(AdaptedWidth(25));
        make.width.height.mas_equalTo(AdaptedWidth(50));
    }];
    [self.resultLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.resultImg.mas_centerX);
        make.top.mas_equalTo(self.resultImg.mas_bottom).mas_offset(AdaptedWidth(10));
    }];
    [self.nodesBg mas_remakeConstraints:^(MASConstraintMaker *make) {
        
    }];
    [self.nodesLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
    }];
}

-(UIImageView *)rsultImg{
    if (_resultImg == nil) {
        _resultImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success"]];
    }
    return _resultImg;
}
-(UILabel *)resultLabel{
    if (_resultLabel == nil) {
        _resultLabel = [[UILabel alloc] init];
        _resultLabel.textColor = kColorTitle;
        _resultLabel.font = AdaptedFontSize(15);
        _resultLabel.text = NSLocalizedString(@"transfer.vote", @"节点投票");
    }
    return _resultLabel;
}
-(UIImageView *)nodesBg{
    if (_nodesBg == nil) {
        _nodesBg = [[UIImageView alloc] init];
        UIImage *img = [UIImage imageNamed:@"label_bg"];
        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height/2.0, img.size.width/2.0, img.size.width/2.0, img.size.height/2.0) resizingMode:UIImageResizingModeStretch];
        _nodesBg.image = img;
    }
    return _nodesBg;
}
-(UILabel *)nodesLabel{
    if (_nodesLabel == nil) {
        _nodesLabel = [[UILabel alloc] init];
        _nodesLabel.textColor = kColorAuxiliary2;
        _nodesLabel.font = AdaptedFontSize(15);
    }
    return _nodesLabel;
}
@end
