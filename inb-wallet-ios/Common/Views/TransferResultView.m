//
//  TransferResultView.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/10/29.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "TransferResultView.h"

#import "UIImage+QRImage.h"

@interface TransferResultView()
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *contenView;

@property (nonatomic, strong) UILabel *titleStr;

@property (nonatomic, strong) UILabel *itemStr_1;
@property (nonatomic, strong) UILabel *itemValue_1;

@property (nonatomic, strong) UILabel *itemStr_2;
@property (nonatomic, strong) UILabel *itemValue_2;

@property (nonatomic, strong) UILabel *itemStr_3;
@property (nonatomic, strong) UILabel *itemValue_3;

@property (nonatomic, strong) UILabel *voteStr;
@property (nonatomic, strong) UILabel *voteValue;
@property (nonatomic, strong) UIImageView *voteImg;

@property (nonatomic, strong) UIImageView *qrImgView;
@property (nonatomic, strong) UILabel *qrTipLabel;

@property (nonatomic, strong) UIButton *knownBtn;

@property (nonatomic, assign) BOOL isLock;
@end

@implementation TransferResultView

+(instancetype)resultFailedWithTitle:(NSString *)title message:(NSString *)message{
    TransferResultView *resultView = [[TransferResultView alloc] initWithTitle:title];
    resultView.frame = CGRectMake(0, 0, KWIDTH, KHEIGHT);
    [resultView makeFiledViewWithError:(NSString *)message];
    [resultView layoutIfNeeded];
    resultView.contenView.layer.cornerRadius = 4;
    resultView.contenView.layer.masksToBounds = YES;
    [App_Delegate.window addSubview:resultView];
    return resultView;
}
+(instancetype)resultSuccessLockWithTitle:(NSString *)title value:(double)value lcokNumber:(NSInteger)lockNumber{
    TransferResultView *resultView = [[TransferResultView alloc] initWithTitle:title];
    resultView.frame = CGRectMake(0, 0, KWIDTH, KHEIGHT);
    [resultView makeLockViewWithLockNumber:lockNumber value:value];
    [resultView layoutIfNeeded];
    resultView.contenView.layer.cornerRadius = 4;
    resultView.contenView.layer.masksToBounds = YES;
    [App_Delegate.window addSubview:resultView];
    return resultView;
}
+(instancetype)resultSuccessVoteWithTitle:(NSString *)title voteNumber:(NSInteger)voteNumber voteNames:(NSArray *)names{
    TransferResultView *resultView = [[TransferResultView alloc] initWithTitle:title];
    resultView.frame = CGRectMake(0, 0, KWIDTH, KHEIGHT);
    [resultView makeVoteViewWithValue:voteNumber voteName:names];
    [resultView layoutIfNeeded];
    resultView.contenView.layer.cornerRadius = 4;
    resultView.contenView.layer.masksToBounds = YES;
    [App_Delegate.window addSubview:resultView];
    return resultView;
}
+(instancetype)resultSuccessRedeemWithTitle:(NSString *)title value:(double)value{
    TransferResultView *resultView = [[TransferResultView alloc] initWithTitle:title];
    resultView.frame = CGRectMake(0, 0, KWIDTH, KHEIGHT);
    [resultView makeRedeemViewWithValue:value];
    [resultView layoutIfNeeded];
    resultView.contenView.layer.cornerRadius = 4;
    resultView.contenView.layer.masksToBounds = YES;
    [App_Delegate.window addSubview:resultView];
    return resultView;
}
+(instancetype)resultSuccessRewardWithTitle:(NSString *)title value:(double)value{
    TransferResultView *resultView = [[TransferResultView alloc] initWithTitle:title];
    resultView.frame = CGRectMake(0, 0, KWIDTH, KHEIGHT);
    [resultView makeRewardViewWithValue:value];
    [resultView layoutIfNeeded];
    resultView.contenView.layer.cornerRadius = 4;
    resultView.contenView.layer.masksToBounds = YES;
    [App_Delegate.window addSubview:resultView];
    return resultView;
}
+(instancetype)QRViewWithTitle:(NSString *)title value:(NSString *)value qrTip:(NSString *)tip{
TransferResultView *resultView = [[TransferResultView alloc] initWithTitle:title];
   resultView.frame = CGRectMake(0, 0, KWIDTH, KHEIGHT);
   [resultView makeQRViewWithValue:value];
    resultView.qrTipLabel.text = tip;
   [resultView layoutIfNeeded];
   resultView.contenView.layer.cornerRadius = 4;
   resultView.contenView.layer.masksToBounds = YES;
   [App_Delegate.window addSubview:resultView];
   return resultView;
}
-(instancetype)initWithTitle:(NSString *)title{
    if(self = [super init]){
        [self addSubview:self.maskView];
        [self addSubview:self.contenView];
        
        [self.contenView addSubview:self.titleStr];
        [self.contenView addSubview:self.knownBtn];
        
        self.titleStr.text = title;
        
        [self makeBaseConstraints];
    }
    return self;
}
-(void)makeBaseConstraints{
    [self.maskView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.contenView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(275);
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self);
        make.bottom.mas_equalTo(self.knownBtn.mas_bottom).mas_offset(25);
    }];
    [self.titleStr mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contenView);
        make.top.mas_equalTo(self.contenView.mas_top).mas_offset(25);
    }];
}
-(void)makeLockViewWithLockNumber:(NSInteger)lockNumber value:(double)value{
    
    self.itemStr_1.text = NSLocalizedString(@"confirm.mortgage.value", @"抵押金额");
    self.itemValue_1.text = [NSString stringWithFormat:@"%@ INB", [NSString changeNumberFormatter:[NSString stringWithFormat:@"%f", value]]];
    
    [self.contenView addSubview:self.itemStr_1];
    [self.contenView addSubview:self.itemValue_1];
    
    if (lockNumber <= 0) {
        self.isLock = NO;
    }else{
        self.isLock = YES;
        
        self.itemStr_2.text = NSLocalizedString(@"confirm.mortgage.day", @"抵押期限");
        self.itemValue_2.text = [NSString stringWithFormat:NSLocalizedString(@"Resource.mortgage.block", @"%@万区块高度"), [NSString stringWithFormat:@"%.2f", lockNumber*1.0/10000]];
        self.itemStr_3.text = NSLocalizedString(@"confirm.mortgage.rate", @"年化率");
        self.itemValue_3.text = [NSString stringWithFormat:@"%.2f%%", [self getRate:lockNumber]];
        
        [self.contenView addSubview:self.itemStr_2];
        [self.contenView addSubview:self.itemValue_2];
        [self.contenView addSubview:self.itemStr_3];
        [self.contenView addSubview:self.itemValue_3];
    }
    
    [self makeLockConstraints];
}
-(void)makeLockConstraints{
    if(self.isLock){
        [self.itemStr_1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleStr.mas_bottom).mas_offset(30);
            make.left.mas_equalTo(self.contenView.mas_left).mas_offset(25);
        }];
        [self.itemValue_1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.itemStr_1);
            make.right.mas_equalTo(self.contenView.mas_right).mas_offset(-25);
        }];
        [self.itemStr_2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.itemStr_1.mas_bottom).mas_offset(20);
            make.left.mas_equalTo(self.itemStr_1.mas_left);
        }];
        [self.itemValue_2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.itemStr_2);
            make.right.mas_equalTo(self.itemValue_1.mas_right);
        }];
        [self.itemStr_3 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.itemStr_2.mas_bottom).mas_offset(20);
            make.left.mas_equalTo(self.itemStr_2.mas_left);
        }];
        [self.itemValue_3 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.itemStr_3);
            make.right.mas_equalTo(self.itemValue_2.mas_right);
        }];
        [self.knownBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.titleStr.mas_centerX);
            make.top.mas_equalTo(self.itemValue_3.mas_bottom).mas_offset(30);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(200);
        }];
    }else{
        [self.itemStr_1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleStr.mas_bottom).mas_offset(30);
            make.left.mas_equalTo(self.contenView.mas_left).mas_offset(25);
        }];
        [self.itemValue_1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.itemStr_1);
            make.right.mas_equalTo(self.contenView.mas_right).mas_offset(-25);
        }];
        [self.knownBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.titleStr.mas_centerX);
            make.top.mas_equalTo(self.itemStr_1.mas_bottom).mas_offset(30);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(200);
        }];
    }
    [self layoutIfNeeded];
    self.contenView.layer.cornerRadius = 4;
    self.contenView.layer.masksToBounds = YES;
}

-(void)makeVoteViewWithValue:(double)value voteName:(NSArray *)voteNames{
    self.itemStr_1.text = NSLocalizedString(@"confirm.vote.canuse", @"可用票数");
    self.itemValue_1.text = [NSString stringWithFormat:@"%@ INB", [NSString changeNumberFormatter:[NSString stringWithFormat:@"%f",value]]];
    self.voteStr.text = NSLocalizedString(@"confirm.vote.node", @"投票节点");
    self.voteValue.text = [voteNames componentsJoinedByString:@"、"];
    
    [self.contenView addSubview:self.itemStr_1];
    [self.contenView addSubview:self.itemValue_1];
    [self.contenView addSubview:self.voteStr];
    [self.contenView addSubview:self.voteImg];
    [self.contenView addSubview:self.voteValue];
    [self makeVoteViewConstraints];
}
-(void)makeVoteViewConstraints{
    [self.itemStr_1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleStr.mas_bottom).mas_offset(30);
        make.left.mas_equalTo(self.contenView.mas_left).mas_offset(25);
    }];
    [self.itemValue_1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.itemStr_1);
        make.right.mas_equalTo(self.contenView.mas_right).mas_offset(-25);
    }];
    [self.voteStr mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.itemStr_1.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(self.itemStr_1);
    }];
    [self.voteImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.voteStr.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(self.voteStr);
        make.right.mas_equalTo(self.itemValue_1);
        make.bottom.mas_equalTo(self.voteValue.mas_bottom).mas_offset(10);
    }];
    [self.voteValue mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.voteImg.mas_top).mas_offset(10);
        make.left.mas_equalTo(self.voteImg.mas_left).mas_offset(10);
        make.right.mas_equalTo(self.voteImg.mas_right).mas_offset(-10);
    }];
    
    [self.knownBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.titleStr.mas_centerX);
        make.top.mas_equalTo(self.voteImg.mas_bottom).mas_offset(30);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(200);
    }];
   
}

-(void)makeRedeemViewWithValue:(double)value{
    self.itemStr_1.text = NSLocalizedString(@"confirm.redeem.valur", @"赎回数量");
    self.itemValue_1.text = [NSString stringWithFormat:@"%@ INB", [NSString changeNumberFormatter:[NSString stringWithFormat:@"%f",value]]];
    [self.contenView addSubview:self.itemStr_1];
    [self.contenView addSubview:self.itemValue_1];
   
    [self makeRedeemViewConstraints];
}
-(void)makeRedeemViewConstraints{
    [self.knownBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.titleStr.mas_centerX);
        make.top.mas_equalTo(self.titleStr.mas_bottom).mas_offset(30);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(200);
    }];
}

-(void)makeRewardViewWithValue:(double)value{
     [self makeRedeemViewConstraints];
}

-(void)makeQRViewWithValue:(NSString *)value{
    [self.contenView addSubview:self.qrImgView];
    [self.contenView addSubview:self.qrTipLabel];
    self.qrImgView.image = [UIImage createQRImgae:value size:122 centerImg:nil centerImgSize:0];
    [self makeQRViewConstraints];
}
-(void)makeQRViewConstraints{
    [self.qrImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleStr.mas_bottom).mas_offset(30);
        make.centerX.mas_equalTo(self.titleStr);
        make.width.height.mas_equalTo(122);
    }];
    [self.qrTipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.qrImgView.mas_bottom).mas_offset(15);
        make.centerX.mas_equalTo(self.qrImgView.mas_centerX);
        make.left.mas_equalTo(self.contenView.mas_left).mas_offset(20);
        make.right.mas_equalTo(self.contenView.mas_right).mas_offset(-20);
    }];
    
    [self.knownBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.titleStr.mas_centerX);
        make.top.mas_equalTo(self.qrTipLabel.mas_bottom).mas_offset(15);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(200);
    }];
}

-(void)makeFiledViewWithError:(NSString *)message{
    self.voteValue.text = message;
    
    [self.contenView addSubview:self.voteValue];
    [self makeFailedViewConstraints];
}
-(void)makeFailedViewConstraints{
    [self.voteValue mas_remakeConstraints:^(MASConstraintMaker *make) {
          make.top.mas_equalTo(self.titleStr.mas_bottom).mas_offset(30);
          make.left.mas_equalTo(self.contenView.mas_left).mas_offset(25);
          make.right.mas_equalTo(self.contenView.mas_right).mas_offset(-25);
      }];
      
      [self.knownBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
          make.centerX.mas_equalTo(self.titleStr.mas_centerX);
          make.top.mas_equalTo(self.voteValue.mas_bottom).mas_offset(30);
          make.height.mas_equalTo(40);
          make.width.mas_equalTo(200);
      }];
}

-(double)getRate:(NSInteger)lockNumber{
    long day = lockNumber/kDayNumbers;
    switch (day) {
        case 30:
            return kRateReturn7_30;
            break;
        case 90:
            return kRateReturn7_90;
        case 180:
            return kRateReturn7_180;
        case 360:
            return kRateReturn7_360;
            
        default:
            return 0;
            break;
    }
}
#pragma mark ----
-(void)knownAction:(UIButton *)sender{
    [self removeFromSuperview];
}

#pragma mark ---- getter && setter
-(UIView *)maskView{
    if (_maskView == nil) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = kColorWithRGBA(0, 0, 0, 0.4);
    }
    return _maskView;
}
-(UIView *)contenView{
    if (_contenView == nil) {
        _contenView = [[UIView alloc] init];
        _contenView.backgroundColor = [UIColor whiteColor];
    }
    return _contenView;
}
-(UILabel *)titleStr{
    if (_titleStr == nil) {
        _titleStr = [[UILabel alloc] init];
        _titleStr.font = [UIFont boldSystemFontOfSize:16];
        _titleStr.textColor = kColorTitle;
    }
    return _titleStr;
}
-(UILabel *)itemStr_1{
    if (_itemStr_1 == nil) {
        _itemStr_1 = [[UILabel alloc] init];
        _itemStr_1.textColor = kColorAuxiliary2;
        _itemStr_1.font = [UIFont systemFontOfSize:15];
    }
    return _itemStr_1;
}
-(UILabel *)itemValue_1{
    if (_itemValue_1 == nil) {
        _itemValue_1 = [[UILabel alloc] init];
        _itemValue_1.textColor = kColorTitle;
        _itemValue_1.font = [UIFont boldSystemFontOfSize:15];
    }
    return _itemValue_1;
}
-(UILabel *)itemStr_2{
    if (_itemStr_2 == nil) {
        _itemStr_2 = [[UILabel alloc] init];
        _itemStr_2.textColor = kColorAuxiliary2;
        _itemStr_2.font = [UIFont systemFontOfSize:15];
    }
    return _itemStr_2;
}
-(UILabel *)itemValue_2{
    if (_itemValue_2 == nil) {
        _itemValue_2 = [[UILabel alloc] init];
        _itemValue_2.textColor = kColorTitle;
        _itemValue_2.font = [UIFont boldSystemFontOfSize:15];
    }
    return _itemValue_2;
}
-(UILabel *)itemStr_3{
    if (_itemStr_3 == nil) {
        _itemStr_3 = [[UILabel alloc] init];
        _itemStr_3.textColor = kColorAuxiliary2;
        _itemStr_3.font = [UIFont systemFontOfSize:15];
    }
    return _itemStr_3;
}
-(UILabel *)itemValue_3{
    if (_itemValue_3 == nil) {
        _itemValue_3 = [[UILabel alloc] init];
        _itemValue_3.textColor = kColorTitle;
        _itemValue_3.font = [UIFont boldSystemFontOfSize:15];
    }
    return _itemValue_3;
}
-(UILabel *)voteStr{
    if (_voteStr == nil) {
        _voteStr = [[UILabel alloc] init];
        _voteStr.textColor = kColorAuxiliary2;
        _voteStr.font = [UIFont systemFontOfSize:15];
    }
    return _voteStr;
}
-(UILabel *)voteValue{
    if (_voteValue == nil) {
        _voteValue = [[UILabel alloc] init];
        _voteValue.textColor = kColorTitle;
        _voteValue.font = [UIFont systemFontOfSize:12];
        _voteValue.numberOfLines = 0;
    }
    return _voteValue;
}
-(UIImageView *)voteImg{
    if (_voteImg == nil) {
        _voteImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"label_bg"]];
    }
    return _voteImg;
}

-(UIImageView *)qrImgView{
    if (_qrImgView == nil) {
        _qrImgView = [[UIImageView alloc] init];
    }
    return _qrImgView;
}
-(UILabel *)qrTipLabel{
    if (_qrTipLabel == nil) {
        _qrTipLabel = [[UILabel alloc] init];
        _qrTipLabel.textColor = kColorBlue;
        _qrTipLabel.font = [UIFont systemFontOfSize:13];
        _qrTipLabel.textAlignment = NSTextAlignmentCenter;
        _qrTipLabel.numberOfLines = 0;
    }
    return _qrTipLabel;
}

-(UIButton *)knownBtn{
    if (_knownBtn == nil) {
        _knownBtn = [[UIButton alloc] init];
        [_knownBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg_blue"] forState:UIControlStateNormal];
        [_knownBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _knownBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_knownBtn addTarget:self action:@selector(knownAction:) forControlEvents:UIControlEventTouchUpInside];
        [_knownBtn setTitle:NSLocalizedString(@"I_know", @"我知道了") forState:UIControlStateNormal];
    }
    return _knownBtn;
}
@end
