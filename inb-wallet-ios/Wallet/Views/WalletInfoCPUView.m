//
//  WalleInfoCPUView.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/3.
//  Copyright © 2019 apple. All rights reserved.
//

#import "WalletInfoCPUView.h"
#import "WalletInfoViewModel.h"

@interface WalletInfoCPUView()
@property(nonatomic, strong) UIImageView *bgImg;
@property(nonatomic, strong) UILabel *cpuResource; //"CPU资源"
@property(nonatomic, strong) UILabel *remaining;   //"剩余"

@property(nonatomic, strong) UILabel *total; //"总量"

@property(nonatomic, strong) UILabel *mortgage; //"抵押"

@property(nonatomic, strong) UIButton*moreBtn;//查看详情按钮

@property(nonatomic, strong) UIImageView *progressBlue;
@property(nonatomic, strong) UIImageView *progressGray;

@property (nonatomic, strong) UIButton *addMortgage; //新增抵押
@property (nonatomic, strong) UIButton *mortgageRecord;//抵押记录
@end

@implementation WalletInfoCPUView

-(instancetype)initWithViewModel:(WalletInfoViewModel *)viewModel{
    if(self = [super init]){
        [self addSubview:self.bgImg];
        [self addSubview:self.cpuResource];
        [self addSubview:self.remaining];
        [self addSubview:self.remainingValue];
        [self addSubview:self.total];
        [self addSubview:self.totalValue];
        [self addSubview:self.mortgage];
        [self addSubview:self.mortgageValue];
        [self addSubview:self.progressBlue];
        [self addSubview:self.progressGray];
        [self addSubview:self.addMortgage];
        [self addSubview:self.mortgageRecord];
//        [self addSubview:self.moreBtn];
        [self makeConstraints];
        
        self.remainingValue.text = @"0Kb";// viewModel.cpu_remaining;
        self.totalValue.text = @"0kb"; //viewModel.cpu_total;
        self.mortgageValue.text = @"0 INB"; //viewModel.mortgage;
    }
    return self;
}


-(void)makeConstraints{
    [self.bgImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    [self.cpuResource mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgImg).mas_offset(AdaptedWidth(20)+7);
        make.left.mas_equalTo(self.bgImg).mas_offset(AdaptedWidth(15)+7);
    }];
    
    [self.mortgage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.cpuResource.mas_bottom);
        make.right.mas_equalTo(self.mortgageValue.mas_left).mas_offset(-5);
    }];
    [self.mortgageValue mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mortgage);
        make.right.mas_equalTo(self.total.mas_right);
    }];
    
    [self.remaining mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.cpuResource);
        make.top.mas_equalTo(self.cpuResource.mas_bottom).mas_offset((25));//AdaptedWidth
    }];
    [self.remainingValue mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.remaining);
        make.top.mas_equalTo(self.remaining.mas_bottom).mas_offset((10)); //AdaptedWidth
    }];
    [self.total mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.remaining);
        make.right.mas_equalTo(self.bgImg).mas_offset(-AdaptedWidth(15)-7);
    }];
    [self.totalValue mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.remainingValue);
        make.right.mas_equalTo(self.total);
    }];
    [self.progressBlue mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.remainingValue.mas_bottom).mas_offset((5));//AdaptedWidth
        make.left.mas_equalTo(self.remainingValue.mas_left);
        make.right.mas_equalTo(self.progressGray.mas_left);
        make.width.mas_equalTo(self.progressGray.mas_width).multipliedBy(0.5);
        make.width.mas_greaterThanOrEqualTo((12)).priorityHigh();//AdaptedWidth
    }];
    [self.progressGray mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.progressBlue);
        make.right.mas_equalTo(self.totalValue.mas_right);
        make.width.mas_greaterThanOrEqualTo(AdaptedWidth(12));
    }];
    [self.addMortgage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgImg.mas_centerX);
        make.top.mas_equalTo(self.progressBlue.mas_bottom).mas_offset(AdaptedWidth(25));
//        make.bottom.mas_equalTo(self.bgImg.mas_bottom).mas_offset(-AdaptedWidth(20));
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(self.remainingValue.mas_left);
        make.right.mas_equalTo(self.totalValue.mas_right);
    }];
    [self.mortgageRecord mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgImg.mas_centerX);
        make.top.mas_equalTo(self.addMortgage.mas_bottom).mas_offset(AdaptedWidth(0));
        //        make.bottom.mas_equalTo(self.bgImg.mas_bottom).mas_offset(-AdaptedWidth(20));
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(self.remainingValue.mas_left);
        make.right.mas_equalTo(self.totalValue.mas_right);
    }];
}

//更改抵押图片比例
-(void)updataNet{
    double canUse = [self.remainingValue.text doubleValue];
    double total = [self.totalValue.text doubleValue];
    double ratio;
    if(total <= 0){
        ratio = 1;
    }else{
        ratio = canUse/total;
    }
    
//    // 告诉self.view约束需要更新
//    [self setNeedsUpdateConstraints];
//    // 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
//    [self updateConstraintsIfNeeded];
//
    [self layoutIfNeeded];
    
    CGFloat titleW = CGRectGetWidth(self.mortgageRecord.titleLabel.bounds);//titleLabel的宽度
    CGFloat imageW = CGRectGetWidth(self.mortgageRecord.imageView.frame);
    self.mortgageRecord.titleEdgeInsets = UIEdgeInsetsMake(0, -imageW - 2.5, 0, imageW + 2.5);
    self.mortgageRecord.imageEdgeInsets = UIEdgeInsetsMake(0, titleW+2.5, 0, -titleW-2.5);

    
    double totalWidth = CGRectGetWidth(self.progressBlue.frame)+CGRectGetWidth(self.progressGray.frame);
    CGRect blueRect = self.progressBlue.frame;
    blueRect.size = CGSizeMake((totalWidth*ratio >= totalWidth) ? totalWidth : totalWidth*ratio , blueRect.size.height);
//    self.progressBlue.frame = blueRect;
//    CGRect grayRect = self.progressGray.frame;
//    grayRect.origin = CGPointMake(CGRectGetMaxX(self.progressBlue.frame), grayRect.origin.y);
//    grayRect.size = CGSizeMake(totalWidth-CGRectGetWidth(self.progressBlue.frame), grayRect.size.height);
//    self.progressGray.frame = grayRect;
    
    [self.progressBlue mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.remainingValue.mas_bottom).mas_offset((5));//AdaptedWidth
        make.left.mas_equalTo(self.remainingValue.mas_left);
        make.right.mas_equalTo(self.progressGray.mas_left);
        make.width.mas_equalTo(blueRect.size.width);
        make.width.mas_greaterThanOrEqualTo((0)).priorityHigh();//AdaptedWidth
    }];
}

#pragma mark ---- UIButton Action
-(void)toAddMortgageAction:(UIButton *)sender{
    if (self.addMortgageBlock) {
        self.addMortgageBlock();
    }
}
-(void)toMortgageRecordAction:(UIButton *)sender{
    if(self.toMortgageBlock){
        self.toMortgageBlock();
    }
}

#pragma mark ----
-(UIImageView *)bgImg{
    if (_bgImg == nil) {
        UIImage *img = [UIImage imageNamed:@"wallet_cpu_bg"];
        _bgImg.contentMode = UIViewContentModeScaleAspectFit;
        _bgImg = [[UIImageView alloc] initWithImage:[img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height/2.0, img.size.width/2.0, img.size.height/2.0, img.size.width/2.0) resizingMode:UIImageResizingModeStretch]];
    }
    return _bgImg;
}
-(UILabel *)cpuResource{
    if (_cpuResource == nil) {
        _cpuResource = [[UILabel alloc] init];
        _cpuResource.text = NSLocalizedString(@"Resource", @"资源(RES)");
        _cpuResource.textColor = kColorTitle;
        _cpuResource.font = AdaptedBoldFontSize(15);
    }
    return _cpuResource;
}
-(UILabel *)remaining{
    if (_remaining == nil) {
        _remaining = [[UILabel alloc] init];
        _remaining.text = NSLocalizedString(@"remaining", @"剩余");
        _remaining.textColor = kColorAuxiliary2;
        _remaining.font = AdaptedFontSize(12);
    }
    return _remaining;
}
-(UILabel *)remainingValue{
    if (_remainingValue == nil) {
        _remainingValue = [[UILabel alloc] init];
        _remainingValue.textColor = kColorTitle;
        _remainingValue.font = AdaptedFontSize(15);
    }
    return _remainingValue;
}
-(UILabel *)total{
    if (_total == nil) {
        _total = [[UILabel alloc] init];
        _total.text = NSLocalizedString(@"total", @"总量");
        _total.textColor = kColorAuxiliary2;
        _total.font = AdaptedFontSize(12);
    }
    return _total;
}
-(UILabel *)totalValue{
    if (_totalValue == nil) {
        _totalValue = [[UILabel alloc] init];
        _totalValue.textColor = kColorTitle;
        _totalValue.font = AdaptedFontSize(15);
    }
    return _totalValue;
}
-(UILabel *)mortgage{
    if (_mortgage == nil) {
        _mortgage = [[UILabel alloc] init];
        _mortgage.text = NSLocalizedString(@"Resource.hasMortgage", @"已抵押");
        _mortgage.textColor = kColorBlue;
        _mortgage.font = AdaptedFontSize(15);
    }
    return _mortgage;
}
-(UILabel *)mortgageValue{
    if (_mortgageValue == nil) {
        _mortgageValue = [[UILabel alloc] init];
        _mortgageValue.textColor = kColorBlue;
        _mortgageValue.font = AdaptedFontSize(15);
    }
    return _mortgageValue;
}
-(UIImageView *)progressBlue{
    if (_progressBlue == nil) {
        UIImage *img = [UIImage imageNamed:@"wallet_progress_blue"];
        _progressBlue = [[UIImageView alloc] initWithImage:[img resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, img.size.width-1) resizingMode:UIImageResizingModeStretch]];
    }
    return _progressBlue;
}
-(UIImageView *)progressGray{
    if (_progressGray == nil) {
        UIImage *img = [UIImage imageNamed:@"wallet_progress_gray"];
        _progressGray = [[UIImageView alloc] initWithImage:[img resizableImageWithCapInsets:UIEdgeInsetsMake(1, img.size.width-1, 1, 1) resizingMode:UIImageResizingModeStretch]];
    }
    return _progressGray;
}
-(UIButton *)addMortgage{
    if (_addMortgage == nil) {
        _addMortgage = [[UIButton alloc] init];
        [_addMortgage setBackgroundImage:[UIImage imageNamed:@"btn_bg_blue"] forState:UIControlStateNormal];
        [_addMortgage setImage:[UIImage imageNamed:@"btn_add_icon"] forState:UIControlStateNormal];
        [_addMortgage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _addMortgage.titleLabel.font = [UIFont systemFontOfSize:15];
        [_addMortgage setTitle:NSLocalizedString(@"addMortgageResources", @"新增抵押资源") forState:UIControlStateNormal];
        _addMortgage.titleEdgeInsets = UIEdgeInsetsMake(0, _addMortgage.imageView.frame.size.width/2+5, 0, -_addMortgage.imageView.frame.size.width/2-5);
        _addMortgage.imageEdgeInsets = UIEdgeInsetsMake(0, -_addMortgage.imageView.frame.size.width/2-5, 0, _addMortgage.imageView.frame.size.width/2+5);
        [_addMortgage addTarget:self action:@selector(toAddMortgageAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _addMortgage;
}
-(UIButton *)mortgageRecord{
    if (_mortgageRecord == nil) {
        _mortgageRecord = [[UIButton alloc] init];
        
        [_mortgageRecord setImage:[UIImage imageNamed:@"more_arrow_blue"] forState:UIControlStateNormal];
        [_mortgageRecord setTitleColor:kColorBlue forState:UIControlStateNormal];
        _mortgageRecord.titleLabel.font = [UIFont systemFontOfSize:15];
        [_mortgageRecord setTitle:NSLocalizedString(@"Resource.record", @"抵押记录") forState:UIControlStateNormal];

        [self.mortgageRecord addTarget:self action:@selector(toMortgageRecordAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mortgageRecord;
}
-(UIButton *)moreBtn{
    if (_moreBtn == nil) {
        _moreBtn = [[UIButton alloc] init];
        [_moreBtn setBackgroundImage:[UIImage imageNamed:@"more_arrow"] forState:UIControlStateNormal];
    }
    return _moreBtn;
}
@end
