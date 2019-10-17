//
//  LXAlertView.m
//  LXAlertViewDemo
//
//  Created by 刘鑫 on 16/4/15.
//  Copyright © 2016年 liuxin. All rights reserved.
//
#define MainScreenRect [UIScreen mainScreen].bounds
#define AlertView_W     270.0f
#define longMsgAlertView_W     300.0f
#define MessageMin_H    60.0f       //messagelab的最小高度
#define MessageMAX_H    200.0f      //messagelab的最大高度，当超过时，文本会以...结尾
#define LXATitle_H      20.0f
#define LXABtn_H        40.0f

#define SFQBlueColor        [UIColor colorWithRed:9/255.0 green:170/255.0 blue:238/255.0 alpha:1]
#define SFQRedColor         [UIColor colorWithRed:255/255.0 green:92/255.0 blue:79/255.0 alpha:1]
#define SFQLightGrayColor   [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1]

#define LXADTitleFont       [UIFont boldSystemFontOfSize:16];
#define LXADMessageFont     [UIFont boldSystemFontOfSize:12];
#define LXADBtnTitleFont    [UIFont systemFontOfSize:15];



#import "LXAlertView.h"
#import "UILabel+LXAdd.h"
//#import "ResourceUtils.h"
//#import "UIUtils.h"

@interface LXAlertView()
@property (nonatomic,strong)UIWindow *alertWindow;

@property (nonatomic,strong)UILabel *titleLab;

@property (nonatomic,strong)UIButton *cancelBtn;
@property (nonatomic,strong)UIButton *otherBtn;

@property (nonatomic,strong)UIButton *searchBtn;

@property (nonatomic, strong) UIImageView *logoImage;
@property (nonatomic, strong) UIView *conteView;


@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, assign) int count;

@end

@implementation LXAlertView

@synthesize delegateId = _delegateId, cancelFun = _cancelFun, certainFun = _certainFun;

/**
 兑换货币用
 */
- (id)initAlert:(id)delegate titleContent:(NSString *)titleContent messageContent:(NSString *)messageContent cancelButtonTitle:(NSString *) cacelButtonTitle cancelFun:(NSString*)cancel certainButtonTitle:(NSString *)certainButtonTitle certainFun:(NSString *)certain
{

//    delegate = self;
    if(self=[super init]){
        self.frame=MainScreenRect;
//        self.backgroundColor=[UIColor colorWithWhite:.3 alpha:.7];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        _alertView=[[UIView alloc] init];
        _alertView.backgroundColor=[UIColor whiteColor];
        _alertView.layer.cornerRadius=4.0;
        _alertView.layer.masksToBounds=YES;
        _alertView.userInteractionEnabled=YES;
        
        
        if (titleContent) {
            _titleLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 15, AlertView_W, LXATitle_H)];
            _titleLab.text=titleContent;
            _titleLab.textAlignment=NSTextAlignmentCenter;
            _titleLab.textColor=kColorWithHexValue(0x333333);
            _titleLab.font=LXADTitleFont;
        }
        
        CGFloat messageLabSpace = 20;
        _messageLab=[[UILabel alloc] init];
        _messageLab.backgroundColor=[UIColor whiteColor];
        _messageLab.text=messageContent;
        _messageLab.textColor = kColorWithHexValue(0x333333);;
//        _messageLab.font=LXADMessageFont;
        _messageLab.font = [UIFont boldSystemFontOfSize:13];
        _messageLab.numberOfLines=0;
        _messageLab.textAlignment=NSTextAlignmentCenter;
        _messageLab.lineBreakMode=NSLineBreakByTruncatingTail;
//        _messageLab.characterSpace=2;
        _messageLab.lineSpace=3;
        CGSize labSize = [_messageLab getLableRectWithMaxWidth:AlertView_W-messageLabSpace*2];
        CGFloat messageLabAotuH = labSize.height < MessageMin_H?MessageMin_H:labSize.height;
        CGFloat endMessageLabH = messageLabAotuH > MessageMAX_H?MessageMAX_H:messageLabAotuH;
        if (!titleContent || [titleContent isEqualToString:@""]) {
            _messageLab.frame=CGRectMake(messageLabSpace, 20, AlertView_W-messageLabSpace*2, endMessageLabH);
        }else{
            _messageLab.frame=CGRectMake(messageLabSpace, _titleLab.frame.size.height+_titleLab.frame.origin.y+5, AlertView_W-messageLabSpace*2, 45);
        }
        
        //计算_alertView的高度
        _alertView.frame=CGRectMake(0, 0, AlertView_W, 145);//_messageLab.frame.size.height+LXATitle_H+LXABtn_H+40
        _alertView.center=self.center;
        [self addSubview:_alertView];
        [_alertView addSubview:_titleLab];
        [_alertView addSubview:_messageLab];
        
        if (cacelButtonTitle) {
            _cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [_cancelBtn setTitle:cacelButtonTitle forState:UIControlStateNormal];
            [_cancelBtn setTitleColor:kColorWithHexValue(0x7b7b7b) forState:UIControlStateNormal];
//            [_cancelBtn setImage:[UIImage imageNamed:@"alert_view_x"] forState:UIControlStateNormal];
//            [_cancelBtn setBackgroundImage:[UIImage imageWithColor:[ResourceUtils UIColorFromRGB:0xf1f1f1]] forState:UIControlStateSelected];
//            [_cancelBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
            _cancelBtn.titleLabel.font=LXADBtnTitleFont;
//            _cancelBtn.layer.cornerRadius=3;
            _cancelBtn.layer.masksToBounds=YES;
            _cancelBtn.layer.borderWidth = 1;
            _cancelBtn.layer.borderColor = kColorWithHexValue(0xf1f1f1).CGColor;
            [_cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [_alertView addSubview:_cancelBtn];
        }
        
        if (certainButtonTitle) {
            _otherBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [_otherBtn setTitle:certainButtonTitle forState:UIControlStateNormal];
            [_otherBtn setTitleColor:kColorWithHexValue(0x333333) forState:UIControlStateNormal];
//            [_otherBtn setImage:[UIImage imageNamed:@"alert_view_o"] forState:UIControlStateNormal];

            _otherBtn.titleLabel.font=LXADBtnTitleFont;
//            _otherBtn.layer.cornerRadius=3;
            _otherBtn.layer.masksToBounds=YES;
            _otherBtn.layer.borderWidth = 1;
            _otherBtn.layer.borderColor = kColorWithHexValue(0xf1f1f1).CGColor;
//            [_otherBtn setBackgroundImage:[UIImage imageWithColor:SFQRedColor] forState:UIControlStateNormal];
//            [_otherBtn setBackgroundImage:[UIImage imageWithColor:[ResourceUtils UIColorFromRGB:0xf1f1f1]] forState:UIControlStateSelected];
//            [_otherBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];

            [_otherBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_alertView addSubview:_otherBtn];
        }else{
            [_otherBtn setImage:[UIImage imageNamed:@"alert_view_x"] forState:UIControlStateNormal];
//            [_cancelBtn setImage:[UIImage imageNamed:@"alert_view_o"] forState:UIControlStateNormal];

        }
        
        CGFloat btnLeftSpace = 0;//btn到左边距
        CGFloat btn_y = _alertView.frame.size.height-LXABtn_H;
        if (cacelButtonTitle && !certainButtonTitle) {
            _cancelBtn.tag=0;
            _cancelBtn.frame=CGRectMake(btnLeftSpace, btn_y, AlertView_W-btnLeftSpace*2, LXABtn_H);
        }else if (!cacelButtonTitle && certainButtonTitle){
            _otherBtn.tag=0;
            _otherBtn.frame=CGRectMake(btnLeftSpace, btn_y, AlertView_W-btnLeftSpace*2, LXABtn_H);
        }else if (cacelButtonTitle && certainButtonTitle){
            _cancelBtn.tag=0;
            _otherBtn.tag=1;
            CGFloat btnSpace = 0;//两个btn之间的间距
            CGFloat btn_w =(AlertView_W-btnLeftSpace*2-btnSpace)/2;
            _cancelBtn.frame=CGRectMake(btnLeftSpace, btn_y, btn_w, LXABtn_H);
            _otherBtn.frame=CGRectMake(_alertView.frame.size.width-btn_w-btnLeftSpace, btn_y, btn_w, LXABtn_H);
        }

        
//        self.clickBlock=block;
    }
    if (self) {
        _delegateId = delegate;
        _cancelFun = cancel;
        _certainFun = certain;
    }
    return self;
}

/**
 大meesage字号
 */
- (id)initBigMesaageAlert:(id)delegate titleContent:(NSString *)titleContent messageContent:(NSString *)messageContent cancelButtonTitle:(NSString *) cacelButtonTitle cancelFun:(NSString*)cancel certainButtonTitle:(NSString *)certainButtonTitle certainFun:(NSString *)certain
{
    
    //    delegate = self;
    if(self=[super init]){
        self.frame=MainScreenRect;
        //        self.backgroundColor=[UIColor colorWithWhite:.3 alpha:.7];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        _alertView=[[UIView alloc] init];
        _alertView.backgroundColor=[UIColor whiteColor];
        _alertView.layer.cornerRadius=4.0;
        _alertView.layer.masksToBounds=YES;
        _alertView.userInteractionEnabled=YES;
        
        
        if (titleContent) {
            _titleLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 15, AlertView_W, LXATitle_H)];
            _titleLab.text=titleContent;
            _titleLab.textAlignment=NSTextAlignmentCenter;
            _titleLab.textColor=kColorWithHexValue(0x333333);
            _titleLab.font=LXADTitleFont;
        }
        
        CGFloat messageLabSpace = 20;
        _messageLab=[[UILabel alloc] init];
        _messageLab.backgroundColor=[UIColor whiteColor];
        _messageLab.text=messageContent;
        _messageLab.textColor = kColorWithHexValue(0x333333);
        //        _messageLab.font=LXADMessageFont;
        _messageLab.font = [UIFont boldSystemFontOfSize:15];
        _messageLab.numberOfLines=0;
        _messageLab.textAlignment=NSTextAlignmentCenter;
        _messageLab.lineBreakMode=NSLineBreakByTruncatingTail;
        //        _messageLab.characterSpace=2;
        _messageLab.lineSpace=3;
        CGSize labSize = [_messageLab getLableRectWithMaxWidth:AlertView_W-messageLabSpace*2];
        CGFloat messageLabAotuH = labSize.height < MessageMin_H?MessageMin_H:labSize.height;
        CGFloat endMessageLabH = messageLabAotuH > MessageMAX_H?MessageMAX_H:messageLabAotuH;
        if (!titleContent || [titleContent isEqualToString:@""]) {
            _messageLab.frame=CGRectMake(messageLabSpace, 20, AlertView_W-messageLabSpace*2, endMessageLabH);
        }else{
            _messageLab.frame=CGRectMake(messageLabSpace, _titleLab.frame.size.height+_titleLab.frame.origin.y+5, AlertView_W-messageLabSpace*2, 45);
        }
        
        //计算_alertView的高度
        _alertView.frame=CGRectMake(0, 0, AlertView_W, 145);//_messageLab.frame.size.height+LXATitle_H+LXABtn_H+40
        _alertView.center=self.center;
        [self addSubview:_alertView];
        [_alertView addSubview:_titleLab];
        [_alertView addSubview:_messageLab];
        
        if (cacelButtonTitle) {
            _cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [_cancelBtn setTitle:cacelButtonTitle forState:UIControlStateNormal];
            [_cancelBtn setTitleColor:kColorWithHexValue(0x7b7b7b) forState:UIControlStateNormal];
            //            [_cancelBtn setImage:[UIImage imageNamed:@"alert_view_x"] forState:UIControlStateNormal];
            //            [_cancelBtn setBackgroundImage:[UIImage imageWithColor:[ResourceUtils UIColorFromRGB:0xf1f1f1]] forState:UIControlStateSelected];
            //            [_cancelBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
            _cancelBtn.titleLabel.font=LXADBtnTitleFont;
            //            _cancelBtn.layer.cornerRadius=3;
            _cancelBtn.layer.masksToBounds=YES;
            _cancelBtn.layer.borderWidth = 1;
            _cancelBtn.layer.borderColor = kColorWithHexValue(0xf1f1f1).CGColor;
            [_cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [_alertView addSubview:_cancelBtn];
        }
        
        if (certainButtonTitle) {
            _otherBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [_otherBtn setTitle:certainButtonTitle forState:UIControlStateNormal];
            [_otherBtn setTitleColor:kColorWithHexValue(0x333333) forState:UIControlStateNormal];
            //            [_otherBtn setImage:[UIImage imageNamed:@"alert_view_o"] forState:UIControlStateNormal];
            
            _otherBtn.titleLabel.font=LXADBtnTitleFont;
            //            _otherBtn.layer.cornerRadius=3;
            _otherBtn.layer.masksToBounds=YES;
            _otherBtn.layer.borderWidth = 1;
            _otherBtn.layer.borderColor = kColorWithHexValue(0xf1f1f1).CGColor;
            //            [_otherBtn setBackgroundImage:[UIImage imageWithColor:SFQRedColor] forState:UIControlStateNormal];
            //            [_otherBtn setBackgroundImage:[UIImage imageWithColor:[ResourceUtils UIColorFromRGB:0xf1f1f1]] forState:UIControlStateSelected];
            //            [_otherBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
            
            [_otherBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_alertView addSubview:_otherBtn];
        }else{
            [_otherBtn setImage:[UIImage imageNamed:@"alert_view_x"] forState:UIControlStateNormal];
            //            [_cancelBtn setImage:[UIImage imageNamed:@"alert_view_o"] forState:UIControlStateNormal];
            
        }
        
        CGFloat btnLeftSpace = 0;//btn到左边距
        CGFloat btn_y = _alertView.frame.size.height-LXABtn_H;
        if (cacelButtonTitle && !certainButtonTitle) {
            _cancelBtn.tag=0;
            _cancelBtn.frame=CGRectMake(btnLeftSpace, btn_y, AlertView_W-btnLeftSpace*2, LXABtn_H);
        }else if (!cacelButtonTitle && certainButtonTitle){
            _otherBtn.tag=0;
            _otherBtn.frame=CGRectMake(btnLeftSpace, btn_y, AlertView_W-btnLeftSpace*2, LXABtn_H);
        }else if (cacelButtonTitle && certainButtonTitle){
            _cancelBtn.tag=0;
            _otherBtn.tag=1;
            CGFloat btnSpace = 0;//两个btn之间的间距
            CGFloat btn_w =(AlertView_W-btnLeftSpace*2-btnSpace)/2;
            _cancelBtn.frame=CGRectMake(btnLeftSpace, btn_y, btn_w, LXABtn_H);
            _otherBtn.frame=CGRectMake(_alertView.frame.size.width-btn_w-btnLeftSpace, btn_y, btn_w, LXABtn_H);
        }
        
        
        //        self.clickBlock=block;
    }
    if (self) {
        _delegateId = delegate;
        _cancelFun = cancel;
        _certainFun = certain;
    }
    return self;
}


-(id)initAlert:(id)delegate attriTitleContent:(NSAttributedString *)titleContent attributeMessageContent:(NSAttributedString *)messageContent cancelButtonTitle:(NSString *)cancelButtonTitle cancelFun:(NSString *)cancel certainButtonTitle:(NSString *)certainButtonTitle certainFun:(NSString *)certain{
    if (self = [super init]) {
        self.frame=MainScreenRect;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        _alertView=[[UIView alloc] init];
        _alertView.backgroundColor=[UIColor whiteColor];
        _alertView.layer.cornerRadius=4.0;
        _alertView.layer.masksToBounds=YES;
        _alertView.userInteractionEnabled=YES;
        if (titleContent) {
            _titleLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 15, AlertView_W, LXATitle_H)];
            _titleLab.attributedText=titleContent;
            _titleLab.textAlignment=NSTextAlignmentCenter;
            _titleLab.font=LXADTitleFont;
        }
        
        CGFloat messageLabSpace = 20;
        _messageLab=[[UILabel alloc] init];
        _messageLab.backgroundColor=[UIColor whiteColor];
        _messageLab.attributedText=messageContent;
        //        _messageLab.font=LXADMessageFont;
        _messageLab.font = [UIFont boldSystemFontOfSize:13];
        _messageLab.numberOfLines=0;
        _messageLab.textAlignment=NSTextAlignmentCenter;
        _messageLab.lineBreakMode=NSLineBreakByTruncatingTail;
        //        _messageLab.characterSpace=2;
        _messageLab.lineSpace=3;
        CGSize labSize = [_messageLab getLableRectWithMaxWidth:AlertView_W-messageLabSpace*2];
        _messageLab.attributedText=messageContent;
        CGFloat messageLabAotuH = labSize.height < MessageMin_H?MessageMin_H:labSize.height;
        CGFloat endMessageLabH = messageLabAotuH > MessageMAX_H?MessageMAX_H:messageLabAotuH;
        if (!titleContent || [titleContent.string isEqualToString:@""]) {
            _messageLab.frame=CGRectMake(messageLabSpace, 20, AlertView_W-messageLabSpace*2, endMessageLabH);
        }else{
            _messageLab.frame=CGRectMake(messageLabSpace, _titleLab.frame.size.height+_titleLab.frame.origin.y+5, AlertView_W-messageLabSpace*2, 45);
        }
        //计算_alertView的高度
        _alertView.frame=CGRectMake(0, 0, AlertView_W, 145);//_messageLab.frame.size.height+LXATitle_H+LXABtn_H+40
        _alertView.center=self.center;
        [self addSubview:_alertView];
        [_alertView addSubview:_titleLab];
        [_alertView addSubview:_messageLab];
        
        if (cancelButtonTitle) {
            _cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [_cancelBtn setTitle:cancelButtonTitle forState:UIControlStateNormal];
            [_cancelBtn setTitleColor:kColorWithHexValue(0x7b7b7b) forState:UIControlStateNormal];
            
            _cancelBtn.titleLabel.font=LXADBtnTitleFont;
            //            _cancelBtn.layer.cornerRadius=3;
            _cancelBtn.layer.masksToBounds=YES;
            _cancelBtn.layer.borderWidth = 1;
            _cancelBtn.layer.borderColor = kColorWithHexValue(0xf1f1f1).CGColor;
            [_cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [_alertView addSubview:_cancelBtn];
        }
        if (certainButtonTitle) {
            _otherBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [_otherBtn setTitle:certainButtonTitle forState:UIControlStateNormal];
            [_otherBtn setTitleColor:kColorWithHexValue(0x333333) forState:UIControlStateNormal];
            
            _otherBtn.titleLabel.font=LXADBtnTitleFont;
            //            _otherBtn.layer.cornerRadius=3;
            _otherBtn.layer.masksToBounds=YES;
            _otherBtn.layer.borderWidth = 1;
            _otherBtn.layer.borderColor = kColorWithHexValue(0xf1f1f1).CGColor;
            
            
            [_otherBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_alertView addSubview:_otherBtn];
        }else{
            [_otherBtn setImage:[UIImage imageNamed:@"alert_view_x"] forState:UIControlStateNormal];
            
        }
        CGFloat btnLeftSpace = 0;//btn到左边距
        CGFloat btn_y = _alertView.frame.size.height-LXABtn_H;
        if (cancelButtonTitle && !certainButtonTitle) {
            _cancelBtn.tag=0;
            _cancelBtn.frame=CGRectMake(btnLeftSpace, btn_y, AlertView_W-btnLeftSpace*2, LXABtn_H);
        }else if (!cancelButtonTitle && certainButtonTitle){
            _otherBtn.tag=0;
            _otherBtn.frame=CGRectMake(btnLeftSpace, btn_y, AlertView_W-btnLeftSpace*2, LXABtn_H);
        }else if (cancelButtonTitle && certainButtonTitle){
            _cancelBtn.tag=0;
            _otherBtn.tag=1;
            CGFloat btnSpace = 0;//两个btn之间的间距
            CGFloat btn_w =(AlertView_W-btnLeftSpace*2-btnSpace)/2;
            _cancelBtn.frame=CGRectMake(btnLeftSpace, btn_y, btn_w, LXABtn_H);
            _otherBtn.frame=CGRectMake(_alertView.frame.size.width-btn_w-btnLeftSpace, btn_y, btn_w, LXABtn_H);
        }
    }
    if (self) {
        _delegateId = delegate;
        _cancelFun = cancel;
        _certainFun = certain;
    }
    return self;
}

-(instancetype)initUpdataAlert:(id)delegate titleContent:(NSString *)titleContent messageContent:(NSString *)messageContent  certainButtonTitle:(NSString *)certainButtonTitle certainFun:(NSString *)certain{
    if(self=[super init]){
        self.frame=MainScreenRect;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        
        _conteView = [[UIView alloc] init];
        
        _alertView=[[UIView alloc] init];
        _alertView.backgroundColor=[UIColor whiteColor];
        _alertView.layer.cornerRadius=8.0;
        _alertView.layer.masksToBounds=YES;
        _alertView.userInteractionEnabled=YES;
        
//        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_alertView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(8.0, 8.0)];
//        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//        maskLayer.frame = self.bounds;
//        maskLayer.path = maskPath.CGPath;
//        _alertView.layer.mask = maskLayer;
        
        if (titleContent) {
            _titleLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 15+22.5, AlertView_W, LXATitle_H)];
//            _titleLab.text=titleContent;
            _titleLab.textAlignment=NSTextAlignmentLeft;
            _titleLab.numberOfLines = 0;
            _titleLab.textColor = kColorWithHexValue(0x7c799b);//Color333;
            _titleLab.font= [UIFont boldSystemFontOfSize:20]; //LXADTitleFont;
            _titleLab.lineSpace = 10;
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:titleContent];
            NSRange range = [titleContent rangeOfString:NSLocalizedString(@"versionUpdate", @"更新版本")];
            [attrString setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:25]} range:range];
            _titleLab.attributedText = attrString;
        }
        
        CGFloat messageLabSpace = 25;
        
        CGSize title_labSize = [_titleLab getLableRectWithMaxWidth:AlertView_W-messageLabSpace*2];
        CGFloat title_messageLabAotuH = title_labSize.height < MessageMin_H?MessageMin_H:title_labSize.height;
        CGFloat title_endMessageLabH = title_messageLabAotuH > MessageMAX_H?MessageMAX_H:title_messageLabAotuH;
        _titleLab.frame=CGRectMake(messageLabSpace, 58, AlertView_W-messageLabSpace*2, title_endMessageLabH);
        
        _messageLab = [[UILabel alloc] init];
        _messageLab.text = messageContent;
        _messageLab.textColor = kColorWithHexValue(0x666666);
        _messageLab.font= [UIFont systemFontOfSize:15];//LXADMessageFont;
        _messageLab.numberOfLines=0;
        _messageLab.textAlignment = NSTextAlignmentLeft;
        _messageLab.lineBreakMode=NSLineBreakByTruncatingTail;
        _messageLab.characterSpace=2;
        _messageLab.lineSpace=5;
        CGSize labSize = [_messageLab getLableRectWithMaxWidth:AlertView_W-messageLabSpace*2*2+20];
        CGFloat messageLabAotuH = labSize.height < MessageMin_H?MessageMin_H:labSize.height;
        CGFloat endMessageLabH = messageLabAotuH > MessageMAX_H?MessageMAX_H:messageLabAotuH;
        _messageLab.frame=CGRectMake(messageLabSpace*2-10, _titleLab.frame.size.height+_titleLab.frame.origin.y+35, AlertView_W-messageLabSpace*2*2+20, endMessageLabH);
        
        
        //计算_alertView的高度
        
        _conteView.frame = CGRectMake(0, 0, AlertView_W, _messageLab.frame.size.height+CGRectGetMaxY(_titleLab.frame)+LXABtn_H+40+22.5+30);
        _conteView.center = self.center;
        [self addSubview:_conteView];
        
//        _alertView.frame=CGRectMake(0, 0, AlertView_W, _messageLab.frame.size.height+CGRectGetMaxY(_titleLab.frame)+LXABtn_H+40);
//        _alertView.center=self.center;
//        [self addSubview:_alertView];
        _alertView.frame=CGRectMake(0, 22.5, AlertView_W, _messageLab.frame.size.height+CGRectGetMaxY(_titleLab.frame)+LXABtn_H+40+30);
        [_conteView addSubview:_alertView];
        UIImage *image = [UIImage imageNamed:@"updateBg"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(150, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
        UIImageView *imgV = [[UIImageView alloc] initWithImage:image];
        [_alertView addSubview:imgV];
        
        [_alertView addSubview:_titleLab];
        [_alertView addSubview:_messageLab];
        imgV.frame = _alertView.bounds;
        
        
        _alertView.clipsToBounds = NO; //显示超出frame的子控件
        UIImageView *cancelView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"updateCancelBg"]];
        cancelView.frame = CGRectMake(_alertView.frame.size.width/2.0 - 20, _alertView.frame.size.height, 40, 65);
        [_alertView addSubview:cancelView];
        
        if (certainButtonTitle) {
            _otherBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [_otherBtn setTitle:certainButtonTitle forState:UIControlStateNormal];
            [_otherBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _otherBtn.titleLabel.font=LXADBtnTitleFont;
            _otherBtn.tag = 1;
            
            UIImage *img = [UIImage imageNamed:@"updateBtnBg"];
            img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(0, 50, 0, 50) resizingMode:UIImageResizingModeStretch];
            [_otherBtn setBackgroundImage:img forState:UIControlStateNormal];
            
            [_otherBtn addTarget:self action:@selector(updateVersion) forControlEvents:UIControlEventTouchUpInside];
            [_alertView addSubview:_otherBtn];
        }else{
            [_otherBtn setImage:[UIImage imageNamed:@"alert_view_x"] forState:UIControlStateNormal];
            
        }
        
        CGFloat btnLeftSpace = (AlertView_W-_messageLab.frame.size.width)/2.0; //15;//btn到左边距
        CGFloat btn_y = _alertView.frame.size.height-50 - 10;
        _otherBtn.tag=0;
        _otherBtn.frame=CGRectMake(btnLeftSpace, btn_y, _messageLab.frame.size.width, LXABtn_H-5);
    }
    if (self) {
        _delegateId = delegate;
        _certainFun = certain;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
        [self addGestureRecognizer:tap];
    }
    return self;
}


-(instancetype)initTipsAlert:(id)delegate titleContent:(NSString *)titleContent messageContent:(NSString *)messageContent  certainButtonTitle:(NSString *)certainButtonTitle certainFun:(NSString *)certain{
    if(self=[super init]){
        self.frame=MainScreenRect;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        
        _conteView = [[UIView alloc] init];
        
        _alertView=[[UIView alloc] init];
        _alertView.backgroundColor=[UIColor whiteColor];
        _alertView.layer.cornerRadius= 8.0;
        _alertView.layer.masksToBounds=YES;
        _alertView.userInteractionEnabled=YES;
        
        if (titleContent) {
            _titleLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 15+22.5, AlertView_W, LXATitle_H)];
            _titleLab.text=titleContent;
            _titleLab.textAlignment=NSTextAlignmentCenter;
            _titleLab.textColor=kColorWithHexValue(0x333333);
            _titleLab.font=LXADTitleFont;
        }
        
        CGFloat messageLabSpace = 25;
        _messageLab = [[UILabel alloc] init];
        _messageLab.backgroundColor = [UIColor whiteColor];
        _messageLab.text = messageContent;
        _messageLab.textColor=[UIColor lightGrayColor];
        _messageLab.font=LXADBtnTitleFont;
        _messageLab.numberOfLines= 0;
        _messageLab.textAlignment = NSTextAlignmentCenter;
        _messageLab.lineBreakMode=NSLineBreakByTruncatingTail;
        _messageLab.characterSpace=2;
        _messageLab.lineSpace=3;
        CGSize labSize = [_messageLab getLableRectWithMaxWidth:AlertView_W-messageLabSpace*2];
        CGFloat messageLabAotuH = labSize.height < MessageMin_H?MessageMin_H:labSize.height;
        CGFloat endMessageLabH = messageLabAotuH > MessageMAX_H?MessageMAX_H:messageLabAotuH;
        _messageLab.frame=CGRectMake(messageLabSpace, _titleLab.frame.size.height+_titleLab.frame.origin.y+10, AlertView_W-messageLabSpace*2, endMessageLabH);
        
        
        //计算_alertView的高度
        
        _conteView.frame = CGRectMake(0, 0, AlertView_W, _messageLab.frame.size.height+CGRectGetMaxY(_titleLab.frame)+LXABtn_H+40+22.5);
        _conteView.center = self.center;
        [self addSubview:_conteView];
        
        //        _alertView.frame=CGRectMake(0, 0, AlertView_W, _messageLab.frame.size.height+CGRectGetMaxY(_titleLab.frame)+LXABtn_H+40);
        //        _alertView.center=self.center;
        //        [self addSubview:_alertView];
        _alertView.frame=CGRectMake(0, 22.5, AlertView_W, _messageLab.frame.size.height+CGRectGetMaxY(_titleLab.frame)+LXABtn_H+40);
        [_conteView addSubview:_alertView];
        [_alertView addSubview:_titleLab];
        [_alertView addSubview:_messageLab];
        
        //设置logo
        _logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_black"]];
        //        _logoImage.frame = CGRectMake(self.frame.size.width/2.0-22.5, _alertView.origin.y-22.5, 55, 55);
        //        [self addSubview:_logoImage];
        _logoImage.frame = CGRectMake(AlertView_W/2.0-22.5, 0, 55, 55);
        [_conteView addSubview:_logoImage];
        
        
        //        _logoImage.frame = CGRectMake(_alertView.frame.size.width/2.0-22.5, -22.5, 55, 55);
        //        [_alertView addSubview:_logoImage];
        
        UIImageView *cancelView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"verifyCodeEnd"]];
        cancelView.frame = CGRectMake(_alertView.frame.size.width - 25, 10, 15, 15);
        [_alertView addSubview:cancelView];
        
        if (certainButtonTitle) {
            _otherBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [_otherBtn setTitle:certainButtonTitle forState:UIControlStateNormal];
            [_otherBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _otherBtn.titleLabel.font=LXADBtnTitleFont;
            //            _otherBtn.layer.cornerRadius=3;
            _otherBtn.tag = 1;
            _otherBtn.layer.masksToBounds=YES;
            _otherBtn.layer.borderWidth = 1;
            _otherBtn.layer.borderColor = kColorWithHexValue(0xf1f1f1).CGColor;
            _otherBtn.backgroundColor = kColorWithHexValue(0x333333);
            _otherBtn.layer.cornerRadius = 4;
            
            [_otherBtn addTarget:self action:@selector(updateVersion) forControlEvents:UIControlEventTouchUpInside];
            [_alertView addSubview:_otherBtn];
        }else{
            [_otherBtn setImage:[UIImage imageNamed:@"alert_view_x"] forState:UIControlStateNormal];
            
        }
        
        CGFloat btnLeftSpace = 15;//btn到左边距
        CGFloat btn_y = _alertView.frame.size.height-50 - 10;
        _otherBtn.tag=0;
        _otherBtn.frame=CGRectMake(btnLeftSpace, btn_y, AlertView_W-btnLeftSpace*2, LXABtn_H-5);
    }
    if (self) {
        _delegateId = delegate;
        _certainFun = certain;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
        [self addGestureRecognizer:tap];
    }
    return self;
}


-(instancetype)initTipsLongMessageAlert:(id)delegate titleContent:(NSString *)titleContent messageContent:(NSAttributedString *)messageContent  certainButtonTitle:(NSString *)certainButtonTitle certainFun:(NSString *)certain{
    if(self=[super init]){
        self.frame=MainScreenRect;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        
        _conteView = [[UIView alloc] init];
        
        _alertView=[[UIView alloc] init];
        _alertView.backgroundColor=[UIColor whiteColor];
        _alertView.layer.cornerRadius= 8.0;
        _alertView.layer.masksToBounds=YES;
        _alertView.userInteractionEnabled=YES;
        
        if (titleContent) {
            _titleLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 25, longMsgAlertView_W, LXATitle_H)];
            _titleLab.text=titleContent;
            _titleLab.textAlignment=NSTextAlignmentCenter;
            _titleLab.textColor=kColorWithHexValue(0x333333);
            _titleLab.font=LXADTitleFont;
        }
        
        CGFloat messageLabSpace = 25;
        _messageLab = [[UILabel alloc] init];
        _messageLab.backgroundColor = [UIColor whiteColor];
        _messageLab.attributedText = messageContent;
//        _messageLab.textColor = kColorWithHexValue(0x333333);
//        _messageLab.font=LXADBtnTitleFont;
        _messageLab.numberOfLines= 0;
        _messageLab.textAlignment = NSTextAlignmentLeft;
        _messageLab.lineBreakMode=NSLineBreakByTruncatingTail;
        _messageLab.characterSpace=2;
        _messageLab.lineSpace=3;
        CGSize labSize = [_messageLab getLableRectWithMaxWidth:longMsgAlertView_W-messageLabSpace*2];

        CGFloat messageLabAotuH = labSize.height < MessageMin_H?MessageMin_H:labSize.height;
        CGFloat endMessageLabH = messageLabAotuH; // messageLabAotuH > 120?230:90;
        _messageLab.frame=CGRectMake(messageLabSpace, _titleLab.frame.size.height+_titleLab.frame.origin.y+20, longMsgAlertView_W-messageLabSpace*2, endMessageLabH);
        
        //计算_alertView的高度
        _conteView.frame = CGRectMake(0, 0, longMsgAlertView_W, labSize.height+CGRectGetMaxY(_titleLab.frame)+LXABtn_H+40+22.5);
        _conteView.center = self.center;
        [self addSubview:_conteView];
        
        _alertView.frame=CGRectMake(0, 22.5, longMsgAlertView_W, labSize.height+10+CGRectGetMaxY(_titleLab.frame)+LXABtn_H+40);
        [_conteView addSubview:_alertView];
        [_alertView addSubview:_titleLab];
        [_alertView addSubview:_messageLab];
        
        CGSize titleSize = [_titleLab getLableRectWithMaxWidth:_titleLab.frame.size.width];
//        UIView *underLine = [[UIView alloc] initWithFrame:CGRectMake(15, 15+10+titleSize.height, _alertView.frame.size.width-15*2, 1.0f)];
//        underLine.backgroundColor = [UIColor lightGrayColor];
//        [_alertView addSubview:underLine];
        
        
        if (certainButtonTitle) {
            _otherBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [_otherBtn setTitle:certainButtonTitle forState:UIControlStateNormal];
            [_otherBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _otherBtn.titleLabel.font=LXADBtnTitleFont;
            _otherBtn.tag = 1;
            [_otherBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg_blue"] forState:UIControlStateNormal];
            [_otherBtn addTarget:self action:@selector(updateVersion) forControlEvents:UIControlEventTouchUpInside];
            [_alertView addSubview:_otherBtn];
        }else{
            [_otherBtn setImage:[UIImage imageNamed:@"btn_bg_blue"] forState:UIControlStateNormal];
        }
        
        CGFloat btnLeftSpace = 15;//btn到左边距
        CGFloat btn_y = _alertView.frame.size.height-50;
        _otherBtn.tag=0;
        _otherBtn.frame=CGRectMake(btnLeftSpace, btn_y, longMsgAlertView_W-btnLeftSpace*2, LXABtn_H-5);
    }
    if (self) {
        _delegateId = delegate;
        _certainFun = certain;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelBtnTitle:(NSString *)cancelTitle otherBtnTitle:(NSString *)otherBtnTitle  otherImageView:(NSString *)imageNameStr clickIndexBlock:(LXAlertClickIndexBlock)block{
    if(self=[super init]){
        self.frame=MainScreenRect;
        self.backgroundColor=[UIColor colorWithWhite:.3 alpha:.7];
        
        _alertView=[[UIView alloc] init];
        _alertView.layer.cornerRadius=6.0;
        _alertView.layer.masksToBounds=YES;
        _alertView.userInteractionEnabled=YES;
        
        if (title) {
            _titleLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 60, AlertView_W, LXATitle_H)];
            _titleLab.text=title;
            _titleLab.textAlignment=NSTextAlignmentCenter;
            _titleLab.textColor = kColorWithHexValue(0x333333);
            _titleLab.numberOfLines = 0;
            _titleLab.font= [UIFont systemFontOfSize:14.0];
            
        }
        
        CGFloat messageLabSpace = 25;
        _messageLab=[[UILabel alloc] init];
        _messageLab.text=message;
        _messageLab.textColor= kColorWithHexValue(0xffb600);
        _messageLab.font= [UIFont boldSystemFontOfSize:20.0];
        _messageLab.numberOfLines=0;
        _messageLab.textAlignment=NSTextAlignmentCenter;
        _messageLab.frame=CGRectMake(messageLabSpace, CGRectGetMaxY(_titleLab.frame)+20, AlertView_W-messageLabSpace*2, 20);
        
        
        
        UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_messageLab.frame)+20, AlertView_W, 10)];
        contentLabel.text= NSLocalizedString(@"depositWallet", @"已存入INB钱包");
        contentLabel.textAlignment=NSTextAlignmentCenter;
        contentLabel.textColor = kColorWithHexValue(0x333333);
        contentLabel.font= [UIFont systemFontOfSize:14.0];
        
        
        //计算_alertView的高度
        _alertView.frame=CGRectMake(0, 0, AlertView_W,AlertView_W+60);
        _alertView.center=self.center;
        [self addSubview:_alertView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_alertView.frame), CGRectGetHeight(_alertView.frame))];
        imageView.image = [UIImage imageNamed:imageNameStr];
        [_alertView addSubview:imageView];
        
        [_alertView addSubview:_titleLab];
        [_alertView addSubview:_messageLab];
        [_alertView addSubview:contentLabel];
        
        _cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(AlertView_W - 30, 10, 20, 20);
        [_cancelBtn setImage:[UIImage imageNamed:@"closed"] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_alertView addSubview:_cancelBtn];
        
        //        if (otherBtnTitle) {
        //            _otherBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        //            _otherBtn.frame = CGRectMake(20, _alertView.frame.size.height - 40-20, AlertView_W - 40, 40);
        //            _otherBtn.tag = 1;
        //            [_otherBtn setTitle:otherBtnTitle forState:UIControlStateNormal];
        //            [_otherBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //            _otherBtn.titleLabel.font=LXADBtnTitleFont;
        //            _otherBtn.layer.cornerRadius=10;
        //            _otherBtn.layer.masksToBounds=YES;
        //            [_otherBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"333333"]] forState:UIControlStateNormal];
        //            [_otherBtn addTarget:self action:@selector(btnClick3:) forControlEvents:UIControlEventTouchUpInside];
        //            [_alertView addSubview:_otherBtn];
        //        }
        //        self.clickBlock=block;
        
        if (otherBtnTitle) {
            _otherBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [_otherBtn setTitle:otherBtnTitle forState:UIControlStateNormal];
            [_otherBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _otherBtn.titleLabel.font=LXADBtnTitleFont;
            _otherBtn.layer.cornerRadius=10;
            _otherBtn.layer.masksToBounds=YES;
            [_otherBtn setBackgroundImage:[UIImage imageWithColor:kColorWithHexValue(0x333333)] forState:UIControlStateNormal];
            [_otherBtn addTarget:self action:@selector(btnClick3:) forControlEvents:UIControlEventTouchUpInside];
            [_alertView addSubview:_otherBtn];
            
        }
        if (cancelTitle) {
            _searchBtn =[UIButton buttonWithType:UIButtonTypeCustom];
            [_searchBtn setTitle:cancelTitle forState:UIControlStateNormal];
            [_searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _searchBtn.titleLabel.font=LXADBtnTitleFont;
            _searchBtn.layer.cornerRadius=10;
            _searchBtn.layer.masksToBounds=YES;
            [_searchBtn setBackgroundImage:[UIImage imageWithColor:kColorWithHexValue(0x333333)] forState:UIControlStateNormal];
            [_searchBtn addTarget:self action:@selector(btnClick3:) forControlEvents:UIControlEventTouchUpInside];
            [_alertView addSubview:_searchBtn];
        }
        
        CGFloat btnLeftSpace = 30;//btn到左边距
        CGFloat btn_y = _alertView.frame.size.height-60;
        if (cancelTitle && !otherBtnTitle) {
            _searchBtn.tag=0;
            _searchBtn.frame=CGRectMake(btnLeftSpace, btn_y, AlertView_W-60, 40);
        }else if (!cancelTitle && otherBtnTitle){
            _otherBtn.tag=0;
            _otherBtn.frame=CGRectMake(btnLeftSpace, btn_y, AlertView_W-60, 40);
        }else if (cancelTitle && otherBtnTitle){
            _searchBtn.tag=0;
            _otherBtn.tag=1;
            CGFloat btnSpace = 30;//两个btn之间的间距
            CGFloat btn_w =(AlertView_W-btnLeftSpace*2-btnSpace)/2;
            _searchBtn.frame=CGRectMake(btnLeftSpace, btn_y, btn_w, 40);
            _otherBtn.frame=CGRectMake(_alertView.frame.size.width-btn_w-btnLeftSpace, btn_y, btn_w, 40);
        }
        
        self.clickBlock=block;
        
    }
    return self;
}
-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelBtnTitle:(NSString *)cancelTitle otherBtnTitle:(NSString *)otherBtnTitle clickIndexBlock:(LXAlertClickIndexBlock)block{
    //    if (self = [super init]) {
    //        self.titleLab.text = title;
    //        self.messageLab.text = message;
    //        [self.cancelBtn setTitle:cancelTitle forState:UIControlStateNormal];
    //    }
    //    return self;
    
    if(self=[super init]){
        self.frame=MainScreenRect;
        self.backgroundColor=[UIColor colorWithWhite:.3 alpha:.7];
        
        _alertView=[[UIView alloc] init];
        _alertView.backgroundColor=[UIColor whiteColor];
        _alertView.layer.cornerRadius=6.0;
        _alertView.layer.masksToBounds=YES;
        _alertView.userInteractionEnabled=YES;
        
        
        if (title) {
            _titleLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, AlertView_W, LXATitle_H)];
            _titleLab.text=title;
            _titleLab.textAlignment=NSTextAlignmentCenter;
            _titleLab.textColor=[UIColor blackColor];
            _titleLab.font=LXADTitleFont;
            
        }
        
        CGFloat messageLabSpace = 25;
        _messageLab=[[UILabel alloc] init];
        _messageLab.backgroundColor=[UIColor whiteColor];
        _messageLab.text=message;
        _messageLab.textColor=[UIColor lightGrayColor];
        _messageLab.font=LXADMessageFont;
        _messageLab.numberOfLines=0;
        //        _messageLab.textAlignment=NSTextAlignmentCenter;
        _messageLab.textAlignment = NSTextAlignmentLeft;
        _messageLab.lineBreakMode=NSLineBreakByTruncatingTail;
        _messageLab.characterSpace=2;
        _messageLab.lineSpace=3;
        CGSize labSize = [_messageLab getLableRectWithMaxWidth:AlertView_W-messageLabSpace*2];
        CGFloat messageLabAotuH = labSize.height < MessageMin_H?MessageMin_H:labSize.height;
        CGFloat endMessageLabH = messageLabAotuH > MessageMAX_H?MessageMAX_H:messageLabAotuH;
        _messageLab.frame=CGRectMake(messageLabSpace, _titleLab.frame.size.height+_titleLab.frame.origin.y+10, AlertView_W-messageLabSpace*2, endMessageLabH);
        
        
        //计算_alertView的高度
        _alertView.frame=CGRectMake(0, 0, AlertView_W, _messageLab.frame.size.height+LXATitle_H+LXABtn_H+40);
        _alertView.center=self.center;
        [self addSubview:_alertView];
        [_alertView addSubview:_titleLab];
        [_alertView addSubview:_messageLab];
        
        if (cancelTitle) {
            _cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [_cancelBtn setTitle:cancelTitle forState:UIControlStateNormal];
            [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_cancelBtn setBackgroundImage:[UIImage imageWithColor:SFQLightGrayColor] forState:UIControlStateNormal];
            //            _cancelBtn.titleLabel.font=LXADBtnTitleFont;
            _cancelBtn.titleLabel.font=[UIFont systemFontOfSize:12];
            _cancelBtn.layer.cornerRadius=3;
            _cancelBtn.layer.masksToBounds=YES;
            [_cancelBtn addTarget:self action:@selector(btnClick2:) forControlEvents:UIControlEventTouchUpInside];
            [_alertView addSubview:_cancelBtn];
        }
        
        if (otherBtnTitle) {
            _otherBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [_otherBtn setTitle:otherBtnTitle forState:UIControlStateNormal];
            [_otherBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            //            _otherBtn.titleLabel.font=LXADBtnTitleFont;
            _otherBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            _otherBtn.layer.cornerRadius=3;
            _otherBtn.layer.masksToBounds=YES;
            //            [_otherBtn setBackgroundImage:[UIImage imageWithColor:SFQRedColor] forState:UIControlStateNormal];
            [_otherBtn setBackgroundColor:kColorWithHexValue(0x333333)];
            [_otherBtn addTarget:self action:@selector(btnClick2:) forControlEvents:UIControlEventTouchUpInside];
            [_alertView addSubview:_otherBtn];
        }
        
        CGFloat btnLeftSpace = 40;//btn到左边距
        CGFloat btn_y = _alertView.frame.size.height-40-10;
        if (cancelTitle && !otherBtnTitle) {
            _cancelBtn.tag=0;
            _cancelBtn.frame=CGRectMake(btnLeftSpace, btn_y, AlertView_W-btnLeftSpace*2, LXABtn_H - 10);
        }else if (!cancelTitle && otherBtnTitle){
            _otherBtn.tag=0;
            _otherBtn.frame=CGRectMake(btnLeftSpace, btn_y, AlertView_W-btnLeftSpace*2, LXABtn_H - 10);
        }else if (cancelTitle && otherBtnTitle){
            _cancelBtn.tag=0;
            _otherBtn.tag=1;
            CGFloat btnSpace = 20;//两个btn之间的间距
            CGFloat btn_w =(AlertView_W-btnLeftSpace*2-btnSpace)/2;
            _cancelBtn.frame=CGRectMake(btnLeftSpace, btn_y, btn_w, LXABtn_H - 10);
            _otherBtn.frame=CGRectMake(_alertView.frame.size.width-btn_w-btnLeftSpace, btn_y, btn_w, LXABtn_H - 10);
        }
        
        self.clickBlock=block;
        
    }
    return self;
}

-(instancetype)initWithOtherImageView:(NSString *)imageNameStr{
    if(self=[super init]){
        self.frame=MainScreenRect;
//        self.backgroundColor=[UIColor colorWithWhite:.3 alpha:.7];
        
        _alertView=[[UIView alloc] init];
        _alertView.layer.cornerRadius=6.0;
        _alertView.layer.masksToBounds=YES;
        _alertView.userInteractionEnabled=YES;
        _alertView.backgroundColor = [UIColor colorWithWhite:.3 alpha:.8];
        
        //计算_alertView的高度
        _alertView.frame=CGRectMake(0, 0, 200,150);
        _alertView.center=self.center;
        [self addSubview:_alertView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((200-25)/2, 35, 25, 30)];
        imageView.image = [UIImage imageNamed:imageNameStr];
        [_alertView addSubview:imageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+20, CGRectGetWidth(_alertView.frame), 30)];
        titleLabel.text = @"亲,您选择的太快了";
        titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [_alertView addSubview:titleLabel];
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //创建子线程中运行的GCD定时器
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, 0);
    uint64_t interval = (uint64_t)(1.0 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    dispatch_source_set_event_handler(self.timer, ^{
        if (self.count == 1) {
            [self dismissAlertViewWithTimer];
        }
        self.count++;
    });
    return self;
}

-(void)tapGesture{
    if(_cancelFun){
        [_delegateId performSelector:NSSelectorFromString(_cancelFun)];
    }
    if (!_dontDissmiss) {
        [self dismissAlertView];
    }
}
-(void)updateVersion{
    if(_certainFun){
        [_delegateId performSelector:NSSelectorFromString(_certainFun)];
    }
    if (!_dontDissmiss) {
        [self dismissAlertView];
    }
}

-(void)btnClick:(UIButton *)btn{
    
//    if (self.clickBlock) {
//        self.clickBlock(btn.tag);
//    }
    
    if(btn.tag == 0){
        if(_cancelFun){
            [_delegateId performSelector:NSSelectorFromString(_cancelFun)];
        }
    }else if(btn.tag == 1){
        if(_certainFun){
            [_delegateId performSelector:NSSelectorFromString(_certainFun)];
        }
    }
    if (!_dontDissmiss) {
        [self dismissAlertView];
    }
}

-(void)btnClick2:(UIButton *)btn{
    if (self.clickBlock) {
        self.clickBlock(btn.tag);
    }
}
-(void)btnClick3:(UIButton *)btn{
    if (self.clickBlock) {
        [self dismissAlertView];
        self.clickBlock(btn.tag);
    }
}
-(void)setDontDissmiss:(BOOL)dontDissmiss{
    _dontDissmiss=dontDissmiss;
}

-(void)showLXAlertViewWithFlag:(NSInteger)flag{
    
//    if ([UIUtils instance].alertViewShow) {
//        return;
//    }
    //    _alertWindow=[[UIWindow alloc] initWithFrame:MainScreenRect];
    //    _alertWindow.windowLevel=UIWindowLevelNormal;
    //    [_alertWindow becomeKeyWindow];
    //    [_alertWindow makeKeyAndVisible];
    //
    //    [_alertWindow addSubview:self];
    if (flag == 1) {
        dispatch_resume(self.timer);
    }
    
    _alertWinView = [[UIView alloc]initWithFrame:MainScreenRect];
    _alertWinView.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication].keyWindow addSubview:_alertWinView];
    [_alertWinView addSubview:self];
    
    [self setShowAnimation];
        
//    [UIUtils instance].alertViewShow = YES;
    
}
-(void)dismissAlertViewWithTimer{
    
//    [UIUtils instance].alertViewShow = NO;
    //    [_alertWindow resignKeyWindow];
    //    [_alertWindow removeFromSuperview];
    //    _alertWindow = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.alertWinView.hidden = YES;
        [self.alertWinView removeFromSuperview];
        self.alertWinView = nil;
        [self removeFromSuperview];
    });
    dispatch_source_cancel(self.timer);
    dispatch_cancel(self.timer);
    self.timer = nil;
}
-(void)dismissAlertView{
    
//    [UIUtils instance].alertViewShow = NO;
    //    [_alertWindow resignKeyWindow];
    //    [_alertWindow removeFromSuperview];
    //    _alertWindow = nil;
    self.alertWinView.hidden = YES;
    [self.alertWinView removeFromSuperview];
    self.alertWinView = nil;
    [self removeFromSuperview];
}
-(void)setShowAnimation{
    
    switch (_animationStyle) {
            
        case LXASAnimationDefault:
        {
            [UIView animateWithDuration:0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                if (self.conteView) {
                    [self.conteView.layer setValue:@(0) forKeyPath:@"transform.scale"];
                }else{
                    [_alertView.layer setValue:@(0) forKeyPath:@"transform.scale"];
                }
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.23 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    if (self.conteView) {
                        [self.conteView.layer setValue:@(1.2) forKeyPath:@"transform.scale"];
                    }else{
                        [_alertView.layer setValue:@(1.2) forKeyPath:@"transform.scale"];
                    }
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.09 delay:0.02 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        if (self.conteView) {
                            [self.conteView.layer setValue:@(0.9) forKeyPath:@"transform.scale"];
                        }else{
                            [_alertView.layer setValue:@(.9) forKeyPath:@"transform.scale"];
                        }
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.05 delay:0.02 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            if (self.conteView) {
                                [self.conteView.layer setValue:@(1.0) forKeyPath:@"transform.scale"];
                            }else{
                                [_alertView.layer setValue:@(1.0) forKeyPath:@"transform.scale"];
                            }
                        } completion:^(BOOL finished) {
                            
                        }];
                    }];
                }];
            }];
        }
            break;
            
        case LXASAnimationLeftShake:{
    
            CGPoint startPoint = CGPointMake(-AlertView_W, self.center.y);
            _alertView.layer.position=startPoint;
            
            //damping:阻尼，范围0-1，阻尼越接近于0，弹性效果越明显
            //velocity:弹性复位的速度
            [UIView animateWithDuration:.8 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
                _alertView.layer.position=self.center;
                
            } completion:^(BOOL finished) {
                
            }];
        }
            break;
            
        case LXASAnimationTopShake:{
            
            CGPoint startPoint = CGPointMake(self.center.x, -_alertView.frame.size.height);
            _alertView.layer.position=startPoint;
            
            //damping:阻尼，范围0-1，阻尼越接近于0，弹性效果越明显
            //velocity:弹性复位的速度
            [UIView animateWithDuration:.8 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
                _alertView.layer.position=self.center;
                
            } completion:^(BOOL finished) {
                
            }];
        }
            break;
            
        case LXASAnimationNO:{
            
        }
            
            break;
            
        default:
            break;
    }
    
}


-(void)setAnimationStyle:(LXAShowAnimationStyle)animationStyle{
    _animationStyle=animationStyle;
}

@end





@implementation UIImage (Colorful)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
