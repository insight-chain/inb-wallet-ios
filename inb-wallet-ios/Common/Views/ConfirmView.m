//
//  ConfirmView.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/10/28.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "ConfirmView.h"
@interface ConfirmView()
@property(nonatomic, copy) ConfirmAction confirm;
@property(nonatomic, copy) CancelAction cancel;
@property (nonatomic, strong) NSString *title;

@property(nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *contentView;

@property(nonatomic, strong) UILabel *titleL; //标题
@property (nonatomic, strong) UIView *subTypeView; //类型view
@property(nonatomic, strong) UIButton *cancelBtn;
@property(nonatomic, strong) UIButton *confirmBtn;
@property(nonatomic, strong) TransferView *transferView;
@property(nonatomic, strong) LockView *lockView;
@property(nonatomic, strong) RedeemView *redeemView;
@property (nonatomic, strong) VoteView *voteView;
@end

@implementation ConfirmView

+(instancetype)transferConfirmWithTitle:(NSString *)title toAddr:(NSString *)toAddr value:(double)value note:(NSString *)note confirm:(ConfirmAction)confirm cancel:(CancelAction)cancel{
    ConfirmView *confirmView = [[ConfirmView alloc] init];
    confirmView.frame = CGRectMake(0, 0, KWIDTH, KHEIGHT);
    confirmView.confirm = confirm;
    confirmView.cancel = cancel;
    confirmView.title= title;
    [confirmView.confirmBtn setTitle:NSLocalizedString(@"confirm.transter", @"确定") forState:UIControlStateNormal];
    
    confirmView.transferView = [[TransferView alloc] initWithNumber:value toAddr:toAddr note:note];
    [confirmView makeTransferView];
    [App_Delegate.window addSubview:confirmView];
    return confirmView;
}

+(instancetype)lockConfirmWithTitle:(NSString *)title value:(double)value lockNumber:(NSInteger)lockNumber confirm:(ConfirmAction)confirm cancel:(CancelAction)cancel{
    ConfirmView *confirmView = [[ConfirmView alloc] init];
       confirmView.frame = CGRectMake(0, 0, KWIDTH, KHEIGHT);
       confirmView.confirm = confirm;
       confirmView.cancel = cancel;
       confirmView.title= title;
       [confirmView.confirmBtn setTitle:NSLocalizedString(@"confirm.transter", @"确定") forState:UIControlStateNormal];
       
       confirmView.lockView = [[LockView alloc] initWithNumber:value lockNumber:lockNumber];
       [confirmView makeLockView];
       [App_Delegate.window addSubview:confirmView];
       return confirmView;
}

+(instancetype)redeemConfirmWithTitle:(NSString *)title addr:(NSString *)addr value:(double)value confirm:(ConfirmAction)confirm cancel:(CancelAction)cancel{
    ConfirmView *confirmView = [[ConfirmView alloc] init];
    confirmView.frame = CGRectMake(0, 0, KWIDTH, KHEIGHT);
    confirmView.confirm = confirm;
    confirmView.cancel = cancel;
    confirmView.title= title;
    [confirmView.confirmBtn setTitle:NSLocalizedString(@"confirm.transter", @"确定") forState:UIControlStateNormal];
    
    confirmView.redeemView = [[RedeemView alloc] initWithNumber:value addr:addr];
    [confirmView makeRedeemView];
    [App_Delegate.window addSubview:confirmView];
    return confirmView;
}
//创建投票
+(instancetype)voteConfirmWithTitle:(NSString *)title nodeName:(NSArray *)names value:(NSInteger)value confirm:(ConfirmAction)confirm cancel:(CancelAction)cancel{
    ConfirmView *confirmView = [[ConfirmView alloc] init];
    confirmView.frame = CGRectMake(0, 0, KWIDTH, KHEIGHT);
    confirmView.confirm = confirm;
    confirmView.cancel = cancel;
    confirmView.title= title;
    [confirmView.confirmBtn setTitle:NSLocalizedString(@"confirm.transter", @"确定") forState:UIControlStateNormal];
    
    confirmView.voteView = [[VoteView alloc] initWithNodeNames:names voteNumber:value];
    [confirmView makeVoteView];
    [App_Delegate.window addSubview:confirmView];
    return confirmView;
}
-(instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.maskView];
        [self addSubview:self.contentView];
        
        [self.contentView addSubview:self.subTypeView];
        [self.contentView addSubview:self.titleL];
        [self.contentView addSubview:self.cancelBtn];
        [self.contentView addSubview:self.confirmBtn];
        [self makeConstraints];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.maskView];
        [self addSubview:self.contentView];
        
        [self.contentView addSubview:self.titleL];
        [self.contentView addSubview:self.subTypeView];
        [self.contentView addSubview:self.cancelBtn];
        [self.contentView addSubview:self.confirmBtn];
        [self makeConstraints];
    }
    return self;
}

-(void)makeConstraints{
    [self.maskView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.top.mas_equalTo(self.titleL.mas_top).mas_offset(-20);
    }];
    
    
    [self.confirmBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.width.mas_equalTo(195);
        make.height.mas_equalTo(40);
        iPhoneX ? make.bottom.mas_equalTo(-(20+34)):make.bottom.mas_equalTo(-20);
    }];
    
    [self.subTypeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.confirmBtn.mas_top).mas_offset(-20);
        make.height.mas_equalTo(0);
    }];
    
    [self.titleL mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.subTypeView.mas_top).mas_offset(-20);
        make.centerX.mas_equalTo(self.contentView);
    }];
    [self.cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleL.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
    }];
    
    
}


-(void)makeTransferView{
    [self.subTypeView addSubview:self.transferView];
    [self.transferView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.subTypeView);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    
    [self.subTypeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.confirmBtn.mas_top).mas_offset(-20);
        make.height.mas_equalTo(self.transferView.viewHeight);
    }];
    [self layoutIfNeeded];
}
-(void)makeLockView{
    [self.subTypeView addSubview:self.lockView];
    [self.lockView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.subTypeView);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    
    [self.subTypeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.confirmBtn.mas_top).mas_offset(-20);
        make.height.mas_equalTo(self.lockView.viewHeight);
    }];
    [self layoutIfNeeded];
}
-(void)makeRedeemView{
    [self.subTypeView addSubview:self.redeemView];
    [self.redeemView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.subTypeView);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    
    [self.subTypeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.confirmBtn.mas_top).mas_offset(-20);
        make.height.mas_equalTo(self.redeemView.viewHeight);
    }];
    [self layoutIfNeeded];
}
-(void)makeVoteView{
    [self.subTypeView addSubview:self.voteView];
    [self.voteView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.subTypeView);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    
    [self.subTypeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.confirmBtn.mas_top).mas_offset(-20);
        make.height.mas_equalTo(self.voteView.viewHeight);
    }];
    [self layoutIfNeeded];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    if(self.transferView){
        [self.subTypeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(self.confirmBtn.mas_top).mas_offset(-20);
            make.height.mas_equalTo(self.transferView.viewHeight);
        }];
    }else if (self.lockView){
        [self.subTypeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(self.confirmBtn.mas_top).mas_offset(-20);
            make.height.mas_equalTo(self.lockView.viewHeight);
        }];
    }else if (self.redeemView){
        [self.subTypeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(self.confirmBtn.mas_top).mas_offset(-20);
            make.height.mas_equalTo(self.redeemView.viewHeight);
        }];
    }else if (self.voteView){
        [self.subTypeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(self.confirmBtn.mas_top).mas_offset(-20);
            make.height.mas_equalTo(self.voteView.viewHeight);
        }];
    }
}
#pragma mark ---- Button Action
//取消
-(void)cancelAction:(UIButton *)sender{
    if(self.cancel){
        self.cancel();
    }
    [self removeFromSuperview];
}
//确认
-(void)confirmAction:(UIButton *)sender{
    [self removeFromSuperview];
    if (self.confirm) {
        self.confirm();
    }
}
#pragma mark ---- setter && getter
-(UIView *)maskView{
    if (_maskView == nil) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = kColorWithRGBA(0, 0, 0, 0.4);
    }
    return _maskView;
}
-(UIView *)contentView{
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}
-(UIView *)subTypeView{
    if(_subTypeView == nil){
        _subTypeView = [[UIView alloc] init];
    }
    return _subTypeView;
}
-(UILabel *)titleL{
    if (_titleL == nil) {
        _titleL = [[UILabel alloc] init];
        _titleL.font = [UIFont boldSystemFontOfSize:16];
        _titleL.textColor = kColorTitle;
    }
    return _titleL;
}
-(UIButton *)cancelBtn{
    if (_cancelBtn == nil) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:NSLocalizedString(@"confirm.cancel", @"取消") forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cancelBtn setTitleColor:kColorAuxiliary2 forState:UIControlStateNormal];
    }
    return _cancelBtn;
}
-(UIButton *)confirmBtn{
    if (_confirmBtn == nil) {
        _confirmBtn = [[UIButton alloc] init];
        [_confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
        [_confirmBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg_blue"] forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _confirmBtn;
}
-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleL.text = _title;
}
-(void)setTransferView:(TransferView *)transferView{
    _transferView = transferView;
}
@end

#pragma mark ---- 转账view
@interface TransferView()

@property (nonatomic, assign) double viewHeight;

@property (nonatomic, strong) UILabel *numberStr;
@property (nonatomic, strong) UILabel *numberValue;

@property (nonatomic, strong) UILabel *toAddrStr;
@property (nonatomic, strong) UILabel *toAddrValue;

@property (nonatomic, strong) UILabel *noteStr;
@property (nonatomic, strong) UILabel *noteValue;

@end

@implementation TransferView

-(instancetype)initWithNumber:(double)number toAddr:(NSString *)toAddr note:(NSString *)note{
    if (self = [super init]) {
        [self addSubview:self.numberStr];
        [self addSubview:self.numberValue];
        [self addSubview:self.toAddrStr];
        [self addSubview:self.toAddrValue];
        [self addSubview:self.noteStr];
        [self addSubview:self.noteValue];
    
        self.numberValue.text = [NSString stringWithFormat:@"%@ INB", [NSString changeNumberFormatter:[NSString stringWithFormat:@"%f",number]]];
        self.toAddrValue.text = toAddr;
        self.noteValue.text = note;
        
        [self makeConstraints];
    }
    return self;
}

-(void)makeConstraints{
    [self.numberStr mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(70);
    }];
    [self.numberValue mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.numberStr.mas_right).mas_offset(5);
        make.right.mas_equalTo(self);
        make.centerY.mas_equalTo(self.numberStr.mas_centerY);
    }];
    [self.toAddrStr mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.numberStr);
        make.top.mas_equalTo(self.numberStr.mas_bottom).mas_offset(18);
    }];
    [self.toAddrValue mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.toAddrStr);
        make.left.right.mas_equalTo(self.numberValue);
    }];
    [self.noteStr mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.toAddrStr);
        make.top.mas_equalTo(self.toAddrValue.mas_bottom).mas_offset(18);
    }];
    [self.noteValue mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.toAddrValue);
        make.top.mas_equalTo(self.noteStr);
    }];
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    double hei = CGRectGetMaxY(self.noteValue.frame) > CGRectGetMaxY(self.noteStr.frame) ? CGRectGetMaxY(self.noteValue.frame): CGRectGetMaxY(self.noteStr.frame);
    self.viewHeight = hei;
}
-(UILabel *)numberStr{
    if (_numberStr == nil) {
        _numberStr = [[UILabel alloc] init];
        _numberStr.textColor = kColorAuxiliary2;
        _numberStr.font = [UIFont systemFontOfSize:15];
        _numberStr.text = NSLocalizedString(@"transfer.number", @"数量");
    }
    return _numberStr;
}
-(UILabel *)numberValue{
    if (_numberValue == nil) {
        _numberValue = [[UILabel alloc] init];
        _numberValue.textColor = kColorTitle;
        _numberValue.font = [UIFont systemFontOfSize:15];
    }
    return _numberValue;
}
-(UILabel *)toAddrStr{
    if (_toAddrStr == nil) {
        _toAddrStr = [[UILabel alloc] init];
        _toAddrStr.textColor = kColorAuxiliary2;
        _toAddrStr.font = [UIFont systemFontOfSize:15];
        _toAddrStr.text = NSLocalizedString(@"transfer.toAddr", @"转入地址");
    }
    return _toAddrStr;
}
-(UILabel *)toAddrValue{
    if (_toAddrValue == nil) {
        _toAddrValue = [[UILabel alloc] init];
        _toAddrValue.textColor = kColorTitle;
        _toAddrValue.font = [UIFont systemFontOfSize:15];
        _toAddrValue.numberOfLines = 0;
    }
    return _toAddrValue;
}
-(UILabel *)noteStr{
    if (_noteStr == nil) {
        _noteStr = [[UILabel alloc] init];
        _noteStr.textColor = kColorAuxiliary2;
        _noteStr.font = [UIFont systemFontOfSize:15];
        _noteStr.text = NSLocalizedString(@"transfer.note", @"备注");
    }
    return _noteStr;
}
-(UILabel *)noteValue{
    if (_noteValue == nil) {
        _noteValue = [[UILabel alloc] init];
        _noteValue.textColor = kColorTitle;
        _noteValue.font = [UIFont systemFontOfSize:15];
        _noteValue.numberOfLines = 0;
    }
    return _noteValue;
}
@end

#pragma mark ---- 锁仓view
@interface LockView()
@property (nonatomic, assign) double viewHeight;
@property (nonatomic, assign) BOOL isLock; //是否是锁仓

@property (nonatomic, strong) UILabel *moneyNumberStr;
@property (nonatomic, strong) UILabel *moneyNumberValue;
@property (nonatomic, strong) UILabel *lockNumberStr;
@property (nonatomic, strong) UILabel *lockNumberValue;
@property (nonatomic, strong) UILabel *rateStr;
@property (nonatomic, strong) UILabel *rateValue;

@property (nonatomic, strong) UIImageView *tipImg_1;
@property (nonatomic, strong) UILabel *tipLabel_1;
@property (nonatomic, strong) UIImageView *tipImg_2;
@property (nonatomic, strong) UILabel *tipLabel_2;
@end
@implementation LockView

-(instancetype)initWithNumber:(double)number lockNumber:(NSInteger)lockNumber{
    if (self = [super init]) {
        
        [self addSubview:self.moneyNumberStr];
        [self addSubview:self.moneyNumberValue];
        [self addSubview:self.tipImg_1];
        [self addSubview:self.tipLabel_1];
        [self addSubview:self.tipImg_2];
        [self addSubview:self.tipLabel_2];
        self.isLock = (lockNumber == 0 ? NO : YES);
        
        if(self.isLock){
            [self addSubview:self.lockNumberStr];
            [self addSubview:self.lockNumberValue];
            [self addSubview:self.rateStr];
            [self addSubview:self.rateValue];
            
            NSString *lockStr = [NSString stringWithFormat:NSLocalizedString(@"Resource.mortgage.block",@"%@万区块高度"), [NSString stringWithFormat:@"%.2f", lockNumber*1.0/10000]];
            int day = (int)(lockNumber/kDayNumbers);
            self.lockNumberValue.text = [NSString stringWithFormat:@"%@(≈%d天)",lockStr, day];
            if (day == 30) {
                self.rateValue.text = [NSString stringWithFormat:@"%.2f %%",kRateReturn7_30];
            }else if (day == 90){
                self.rateValue.text = [NSString stringWithFormat:@"%.2f %%",kRateReturn7_90];
            }else if (day == 180){
                self.rateValue.text = [NSString stringWithFormat:@"%.2f %%",kRateReturn7_180];
            }else if (day == 360){
                self.rateValue.text = [NSString stringWithFormat:@"%.2f %%",kRateReturn7_360];
            }
            self.tipLabel_1.text = NSLocalizedString(@"tip.confir.lock_1", @"锁仓抵押最多能抵押5次，请您谨慎选择抵押金额与期限。");
            self.tipLabel_2.text = NSLocalizedString(@"tip.confir.lock_2", @"赎回的资源与抵押奖励收益需要您手动领取。");
        }else{
            self.tipLabel_1.text = NSLocalizedString(@"tip.confir.morgage_1", @"您可以在任何时候赎回抵押的资源，但是会有三天的等待期。");
            self.tipLabel_2.text = NSLocalizedString(@"tip.confir.morgage_2", @"赎回的资源与抵押奖励收益需要您手动领取。");
        }
        
        self.moneyNumberValue.text = [NSString stringWithFormat:@"%@ INB", [NSString changeNumberFormatter:[NSString stringWithFormat:@"%f", number]]];
        [self makeConstraints];
    }
    return self;
}

-(void)makeConstraints{
    [self.moneyNumberStr mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
    }];
    [self.moneyNumberValue mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.moneyNumberStr.mas_right).mas_offset(5);
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(self.moneyNumberStr);
    }];
    
    if(self.isLock){
        [self.lockNumberStr mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.moneyNumberStr);
            make.top.mas_equalTo(self.moneyNumberStr.mas_bottom).mas_offset(18);
        }];
        [self.lockNumberValue mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.moneyNumberValue);
            make.top.mas_equalTo(self.lockNumberStr);
        }];
        [self.rateStr mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.lockNumberStr);
            make.top.mas_equalTo(self.lockNumberStr.mas_bottom).mas_offset(18);
        }];
        [self.rateValue mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.lockNumberValue);
            make.top.mas_equalTo(self.rateStr);
        }];
        [self.tipImg_1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.rateStr);
            make.width.height.mas_equalTo(15);
            make.top.mas_equalTo(self.rateStr.mas_bottom).mas_offset(18);
        }];
        [self.tipLabel_1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.tipImg_1);
            make.left.mas_equalTo(self.tipImg_1.mas_right).mas_offset(10);
            make.right.mas_equalTo(self);
        }];
        [self.tipImg_2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.tipImg_1);
            make.top.mas_equalTo(self.tipLabel_1.mas_bottom).mas_offset(13);
        }];
        [self.tipLabel_2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.tipLabel_1);
            make.top.mas_equalTo(self.tipImg_2);
        }];
    }else{
        [self.tipImg_1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.moneyNumberStr);
            make.top.mas_equalTo(self.moneyNumberStr.mas_bottom).mas_offset(18);
        }];
        [self.tipLabel_1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.tipImg_1);
            make.left.mas_equalTo(self.tipImg_1.mas_right).mas_offset(10);
            make.right.mas_equalTo(self);
        }];
        [self.tipImg_2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.tipImg_1);
            make.top.mas_equalTo(self.tipLabel_1.mas_bottom).mas_offset(13);
        }];
        [self.tipLabel_2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.tipLabel_1);
            make.top.mas_equalTo(self.tipImg_2);
        }];
    }
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    double hei = CGRectGetMaxY(self.tipLabel_2.frame);
    self.viewHeight = hei;
}

-(UILabel *)moneyNumberStr{
    if (_moneyNumberStr == nil) {
        _moneyNumberStr = [[UILabel alloc] init];
        _moneyNumberStr.textColor = kColorAuxiliary2;
        _moneyNumberStr.text = NSLocalizedString(@"confirm.mortgage.value", @"抵押金额");
        _moneyNumberStr.font = [UIFont systemFontOfSize:15];
    }
    return _moneyNumberStr;
}
-(UILabel *)moneyNumberValue{
    if (_moneyNumberValue == nil) {
        _moneyNumberValue = [[UILabel alloc] init];
        _moneyNumberValue.textColor = kColorTitle;
        _moneyNumberValue.font = [UIFont systemFontOfSize:15];
    }
    return _moneyNumberValue;
}
-(UILabel *)lockNumberStr{
    if (_lockNumberStr == nil) {
           _lockNumberStr = [[UILabel alloc] init];
           _lockNumberStr.textColor = kColorAuxiliary2;
           _lockNumberStr.text = NSLocalizedString(@"confirm.mortgage.day", @"抵押期限");
           _lockNumberStr.font = [UIFont systemFontOfSize:15];
    }
    return _lockNumberStr;
}
-(UILabel *)lockNumberValue{
    if (_lockNumberValue == nil) {
        _lockNumberValue = [[UILabel alloc] init];
        _lockNumberValue.textColor = kColorTitle;
        _lockNumberValue.font = [UIFont systemFontOfSize:15];
    }
    return _lockNumberValue;
}
-(UILabel *)rateStr{
    if (_rateStr == nil) {
           _rateStr = [[UILabel alloc] init];
           _rateStr.textColor = kColorAuxiliary2;
           _rateStr.text = NSLocalizedString(@"confirm.mortgage.rate", @"年化率");
           _rateStr.font = [UIFont systemFontOfSize:15];
    }
    return _rateStr;
}
-(UILabel *)rateValue{
    if (_rateValue == nil) {
        _rateValue = [[UILabel alloc] init];
        _rateValue.textColor = kColorTitle;
        _rateValue.font = [UIFont systemFontOfSize:15];
    }
    return _rateValue;
}
-(UIImageView *)tipImg_1{
    if (_tipImg_1 == nil) {
        _tipImg_1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"horn"]];
    }
    return _tipImg_1;
}
-(UILabel *)tipLabel_1{
    if (_tipLabel_1 == nil) {
        _tipLabel_1 = [[UILabel alloc] init];
        _tipLabel_1.font = [UIFont systemFontOfSize:13];
        _tipLabel_1.textColor = kColorBlue;
        _tipLabel_1.numberOfLines = 0;
    }
    return _tipLabel_1;
}
-(UIImageView *)tipImg_2{
    if (_tipImg_2 == nil) {
        _tipImg_2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"horn"]];
    }
    return _tipImg_2;
}
-(UILabel *)tipLabel_2{
    if (_tipLabel_2 == nil) {
        _tipLabel_2 = [[UILabel alloc] init];
        _tipLabel_2.font = [UIFont systemFontOfSize:13];
        _tipLabel_2.textColor = kColorBlue;
        _tipLabel_2.numberOfLines = 0;
    }
    return _tipLabel_2;
}
@end


#pragma mark ---- 赎回view
@interface RedeemView()
@property (nonatomic, assign) double viewHeight;

@property (nonatomic, strong) UILabel *moneyNumberStr;
@property (nonatomic, strong) UILabel *moneyNumberValue;
@property (nonatomic, strong) UILabel *addrStr;
@property (nonatomic, strong) UILabel *addrValue;

@property (nonatomic, strong) UIImageView *tipImg_1;
@property (nonatomic, strong) UILabel *tipLabel_1;
@property (nonatomic, strong) UIImageView *tipImg_2;
@property (nonatomic, strong) UILabel *tipLabel_2;
@end
@implementation RedeemView
-(instancetype)initWithNumber:(double)number addr:(nonnull NSString *)addr{
    if (self = [super init]) {
        
        [self addSubview:self.addrStr];
        [self addSubview:self.addrValue];
        [self addSubview:self.moneyNumberStr];
        [self addSubview:self.moneyNumberValue];
        [self addSubview:self.tipImg_1];
        [self addSubview:self.tipLabel_1];
        [self addSubview:self.tipImg_2];
        [self addSubview:self.tipLabel_2];
        
        self.addrValue.text = addr;
        self.moneyNumberValue.text = [NSString stringWithFormat:@"%@ INB", [NSString changeNumberFormatter:[NSString stringWithFormat:@"%f", number]]];
        self.tipLabel_1.text = NSLocalizedString(@"confirm.redeem.tip_1", @"赎回的资源到期后需要您手动领取，请注意查收");
        self.tipLabel_2.text = NSLocalizedString(@"confirm.redeem.tip_2", @"所有正在赎回的INB资源将在最后一次赎回操作的三天后返还");
        
        [self makeConstraints];
    }
    return self;
}
-(void)makeConstraints{
    [self.addrStr mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.width.mas_equalTo(70);
    }];
    [self.addrValue mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.addrStr);
        make.left.mas_equalTo(self.addrStr.mas_right).mas_offset(5);
        make.right.mas_equalTo(self);
    }];
    [self.moneyNumberStr mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.addrStr);
        make.top.mas_equalTo(self.addrValue.mas_bottom).mas_offset(18);
    }];
    [self.moneyNumberValue mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.addrValue);
        make.top.mas_equalTo(self.moneyNumberStr);
    }];
    
    [self.tipImg_1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(15);
        make.left.mas_equalTo(self.moneyNumberStr);
        make.top.mas_equalTo(self.moneyNumberValue.mas_bottom).mas_offset(18);
    }];
    [self.tipLabel_1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tipImg_1.mas_right).mas_offset(10);
        make.top.mas_equalTo(self.tipImg_1);
        make.right.mas_equalTo(self);
    }];
    [self.tipImg_2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tipImg_1);
        make.top.mas_equalTo(self.tipLabel_1.mas_bottom).mas_offset(13);
    }];
    [self.tipLabel_2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.tipLabel_1);
        make.top.mas_equalTo(self.tipImg_2);
    }];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    double hei = CGRectGetMaxY(self.tipLabel_2.frame);
    self.viewHeight = hei;
}

-(UILabel *)moneyNumberStr{
    if (_moneyNumberStr == nil) {
        _moneyNumberStr = [[UILabel alloc] init];
        _moneyNumberStr.textColor = kColorAuxiliary2;
        _moneyNumberStr.text = NSLocalizedString(@"confirm.redeem.valur", @"赎回数量");
        _moneyNumberStr.font = [UIFont systemFontOfSize:15];
    }
    return _moneyNumberStr;
}
-(UILabel *)moneyNumberValue{
    if (_moneyNumberValue == nil) {
        _moneyNumberValue = [[UILabel alloc] init];
        _moneyNumberValue.textColor = kColorTitle;
        _moneyNumberValue.font = [UIFont systemFontOfSize:15];
    }
    return _moneyNumberValue;
}
-(UILabel *)addrStr{
    if (_addrStr == nil) {
           _addrStr = [[UILabel alloc] init];
           _addrStr.textColor = kColorAuxiliary2;
           _addrStr.text = NSLocalizedString(@"confirm.redeem.addr", @"赎回地址");
           _addrStr.font = [UIFont systemFontOfSize:15];
    }
    return _addrStr;
}
-(UILabel *)addrValue{
    if (_addrValue == nil) {
        _addrValue = [[UILabel alloc] init];
        _addrValue.textColor = kColorTitle;
        _addrValue.font = [UIFont systemFontOfSize:15];
        _addrValue.numberOfLines = 0;
    }
    return _addrValue;
}
-(UIImageView *)tipImg_1{
    if (_tipImg_1 == nil) {
        _tipImg_1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"horn"]];
    }
    return _tipImg_1;
}
-(UILabel *)tipLabel_1{
    if (_tipLabel_1 == nil) {
        _tipLabel_1 = [[UILabel alloc] init];
        _tipLabel_1.font = [UIFont systemFontOfSize:13];
        _tipLabel_1.textColor = kColorBlue;
        _tipLabel_1.numberOfLines = 0;
    }
    return _tipLabel_1;
}
-(UIImageView *)tipImg_2{
    if (_tipImg_2 == nil) {
        _tipImg_2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"horn"]];
    }
    return _tipImg_2;
}
-(UILabel *)tipLabel_2{
    if (_tipLabel_2 == nil) {
        _tipLabel_2 = [[UILabel alloc] init];
        _tipLabel_2.font = [UIFont systemFontOfSize:13];
        _tipLabel_2.textColor = kColorBlue;
        _tipLabel_2.numberOfLines = 0;
    }
    return _tipLabel_2;
}
@end


#pragma mark ---- 投票view
@interface VoteView()
@property (nonatomic, assign) double viewHeight;

@property (nonatomic, strong) UILabel *nodeStr;
@property (nonatomic, strong) UILabel *nodeValue;
@property (nonatomic, strong) UIImageView *nodeImg;

@property (nonatomic, strong) UILabel *voteStr;
@property (nonatomic, strong) UILabel *voteValue;

@property (nonatomic, strong) UIImageView *tipImg_1;
@property (nonatomic, strong) UILabel *tipLabel_1;
@property (nonatomic, strong) UIImageView *tipImg_2;
@property (nonatomic, strong) UILabel *tipLabel_2;

@end

@implementation VoteView
-(instancetype)initWithNodeNames:(NSArray *)names voteNumber:(NSInteger)voteNumber{
    if (self = [super init]) {
        [self addSubview:self.nodeStr];
        [self addSubview:self.nodeImg];
        [self addSubview:self.nodeValue];
        [self addSubview:self.voteStr];
        [self addSubview:self.voteValue];
        [self addSubview:self.tipImg_1];
        [self addSubview:self.tipLabel_1];
        [self addSubview:self.tipImg_2];
        [self addSubview:self.tipLabel_2];
        
        self.nodeValue.text = [names componentsJoinedByString:@"、"];
        self.voteValue.text = [NSString stringWithFormat:@"%ld", (long)voteNumber];
        self.tipLabel_1.text = NSLocalizedString(@"confirm.vote.tip_1", @"可通过抵押INB来增加节点票数，每抵押一个INB可为每个投票节点增加一票。");
        self.tipLabel_2.text = NSLocalizedString(@"confirm.vote.tip_2", @"投票的用户可获得投票收益，请注意领取。");
        [self makeConstraints];
    }
    return self;
}
-(void)makeConstraints{
    [self.nodeStr mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
    }];
    [self.nodeImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nodeStr.mas_bottom).mas_offset(18);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.nodeValue.mas_bottom).mas_offset(10);
    }];
    [self.nodeValue mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nodeImg.mas_top).mas_offset(10);
        make.left.mas_equalTo(self.nodeImg.mas_left).mas_offset(10);
        make.right.mas_equalTo(self.nodeImg.mas_right).mas_offset(-10);
    }];
    [self.voteStr mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nodeStr);
        make.top.mas_equalTo(self.nodeImg.mas_bottom).mas_offset(18);
    }];
    [self.voteValue mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.voteStr.mas_right).mas_offset(5);
        make.centerY.mas_equalTo(self.voteStr);
    }];
    [self.tipImg_1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.voteStr);
        make.width.height.mas_equalTo(15);
        make.top.mas_equalTo(self.voteValue.mas_bottom).mas_offset(18);
    }];
    [self.tipLabel_1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipImg_1);
        make.left.mas_equalTo(self.tipImg_1.mas_right).mas_offset(5);
        make.right.mas_equalTo(0);
    }];
    [self.tipImg_2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipLabel_1.mas_bottom).mas_offset(13);
        make.left.mas_equalTo(self.tipImg_1);
    }];
    [self.tipLabel_2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipImg_2);
        make.left.right.mas_equalTo(self.tipLabel_1);
    }];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    double hei = CGRectGetMaxY(self.tipLabel_2.frame);
    self.viewHeight = hei;
}

-(UILabel *)nodeStr{
    if (_nodeStr == nil) {
        _nodeStr = [[UILabel alloc] init];
        _nodeStr.textColor = kColorAuxiliary2;
        _nodeStr.text = NSLocalizedString(@"confirm.vote.node", @"投票节点");
        _nodeStr.font = [UIFont systemFontOfSize:15];
    }
    return _nodeStr;
}
-(UILabel *)nodeValue{
    if (_nodeValue == nil) {
        _nodeValue = [[UILabel alloc] init];
        _nodeValue.textColor = kColorTitle;
        _nodeValue.font = [UIFont systemFontOfSize:15];
    }
    return _nodeValue;
}
-(UIImageView *)nodeImg{
    if (_nodeImg == nil) {
        _nodeImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"label_bg"]];
//        _nodeImg.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _nodeImg;
}

-(UILabel *)voteStr{
    if (_voteStr == nil) {
        _voteStr = [[UILabel alloc] init];
        _voteStr.textColor = kColorAuxiliary2;
        _voteStr.text = NSLocalizedString(@"confirm.vote.canuse", @"节点可用投票");
        _voteStr.font = [UIFont systemFontOfSize:15];
    }
    return _voteStr;
}
-(UILabel *)voteValue{
    if (_voteValue == nil) {
        _voteValue = [[UILabel alloc] init];
        _voteValue.textColor = kColorTitle;
        _voteValue.font = [UIFont systemFontOfSize:15];
    }
    return _voteValue;
}
-(UIImageView *)tipImg_1{
    if (_tipImg_1 == nil) {
        _tipImg_1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"horn"]];
    }
    return _tipImg_1;
}
-(UILabel *)tipLabel_1{
    if (_tipLabel_1 == nil) {
        _tipLabel_1 = [[UILabel alloc] init];
        _tipLabel_1.font = [UIFont systemFontOfSize:13];
        _tipLabel_1.textColor = kColorBlue;
        _tipLabel_1.numberOfLines = 0;
    }
    return _tipLabel_1;
}
-(UIImageView *)tipImg_2{
    if (_tipImg_2 == nil) {
        _tipImg_2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"horn"]];
    }
    return _tipImg_2;
}
-(UILabel *)tipLabel_2{
    if (_tipLabel_2 == nil) {
        _tipLabel_2 = [[UILabel alloc] init];
        _tipLabel_2.font = [UIFont systemFontOfSize:13];
        _tipLabel_2.textColor = kColorBlue;
        _tipLabel_2.numberOfLines = 0;
    }
    return _tipLabel_2;
}
@end
