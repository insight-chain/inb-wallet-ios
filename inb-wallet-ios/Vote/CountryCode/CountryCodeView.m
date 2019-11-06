//
//  CountryCodeView.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/9/19.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "CountryCodeView.h"

//判断系统语言
#define CURR_LANG ([[NSLocale preferredLanguages] objectAtIndex:0])
#define LanguageIsEnglish ([CURR_LANG isEqualToString:@"en-US"] || [CURR_LANG isEqualToString:@"en-CA"] || [CURR_LANG isEqualToString:@"en-GB"] || [CURR_LANG isEqualToString:@"en-CN"] || [CURR_LANG isEqualToString:@"en"])

#define kPickerHeight 200
@interface CountryCodeView()<UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSArray *_countryArr;
}
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIPickerView *pickerView;
@end

@implementation CountryCodeView
-(instancetype)init{
    if (self = [super init]) {
        
        [self addSubview:self.maskView];
        [self addSubview:self.pickerView];
        
        self.maskView.frame = self.bounds;
        self.pickerView.frame = CGRectMake(0, KHEIGHT-kPickerHeight, KWIDTH, kPickerHeight);
        
        if (LanguageIsEnglish) {
            NSString *listPathEN = [[NSBundle mainBundle] pathForResource:@"countryNameCH" ofType:@"plist"];
            _countryArr = [[NSArray alloc] initWithContentsOfFile:listPathEN];
        }else{
            NSString *listPathEN = [[NSBundle mainBundle] pathForResource:@"countryNameCH" ofType:@"plist"];
            _countryArr = [[NSArray alloc] initWithContentsOfFile:listPathEN];
        }
        
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.maskView];
        [self addSubview:self.pickerView];
        
        self.maskView.frame = self.bounds;
        self.pickerView.frame = CGRectMake(0, KHEIGHT-kPickerHeight, KWIDTH, kPickerHeight);
        
        if (LanguageIsEnglish) {
            NSString *listPathEN = [[NSBundle mainBundle] pathForResource:@"countryNameCH" ofType:@"plist"];
            _countryArr = [[NSArray alloc] initWithContentsOfFile:listPathEN];
        }else{
            NSString *listPathEN = [[NSBundle mainBundle] pathForResource:@"countryNameCH" ofType:@"plist"];
            _countryArr = [[NSArray alloc] initWithContentsOfFile:listPathEN];
        }
    }
    return self;
}

-(void)hidePicker{
    [self removeFromSuperview];
}

+(NSArray *)countryList{
    if (LanguageIsEnglish) {
        NSString *listPathEN = [[NSBundle mainBundle] pathForResource:@"countryNameEH" ofType:@"plist"];
        return [[NSArray alloc] initWithContentsOfFile:listPathEN];
    }else{
        NSString *listPathEN = [[NSBundle mainBundle] pathForResource:@"countryNameCH" ofType:@"plist"];
        return [[NSArray alloc] initWithContentsOfFile:listPathEN];
    }
}

#pragma mark ---- UIPickerViewDelegate && Datasource
//有几列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
//有几行
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _countryArr.count;
}
//列显示的数据
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSDictionary *dic = _countryArr[row];
    NSString *key = [[dic allKeys] lastObject];
    return dic[key];
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        pickerLabel.font = [UIFont systemFontOfSize:20];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
    
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSDictionary *dic = _countryArr[row];
    NSString *key = [[dic allKeys] lastObject];
    if (self.selectCountry) {
        self.selectCountry(dic[key], key);
    }
}

-(UIPickerView *)pickerView{
    if (_pickerView == nil) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.showsSelectionIndicator = YES;
    }
    return _pickerView;
}
-(UIView *)maskView{
    if (_maskView == nil) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePicker)];
        [_maskView addGestureRecognizer:tap];
        _maskView.userInteractionEnabled = YES;
    }
    return _maskView;
}
@end
