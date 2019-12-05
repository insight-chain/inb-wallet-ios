//
//  WelcomBackupVC.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/29.
//  Copyright © 2019 apple. All rights reserved.
//

#import "WelcomBackupVC.h"

#import "WelcomConfirmMnemonicVC.h"

#import "MnemonicWordCell.h"
#import "MnemonicWordHeaderView.h"
#import "MnemonicWordCell2.h"
#import "MnemonicWordHeaderView2.h"

#import "NSString+Extension.h"
#import "UIImage+QRImage.h"

#import "Identity.h"
#import "BasicWallet.h"
#import "WalletManager.h"

#define cellId  @"menmonicWordCell"
#define cellId2 @"mnemonicWordCell2"
#define headerView  @"mnemonocWordHeaderView"
#define headerView2 @"mnemonocWordHeaderView2"
#define footerView2 @"mnemonocWordFooterView2"

#define qrImgSize 130

@interface WelcomBackupVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong) NSMutableArray *memonryWords;
@property(nonatomic, strong) UICollectionView *collect;
@property (nonatomic, strong) UIView *qrContentView;
@property (nonatomic, strong) UIImageView *qrImg;
@property (nonatomic, strong) UILabel *qrAddrLabel;
@property (nonatomic, strong) UIButton *qrBtn;
@property (nonatomic, strong) UILabel *qrTipL;

@property (nonatomic, strong) UIView *qrPwdView;
@property (nonatomic, strong) UILabel *qrPwdL;
@property (nonatomic, strong) UITextField *qrPwdTF;
@property (nonatomic, strong) UIButton *qrPwdDone;
@property (nonatomic, strong) UILabel *qrPwdTipL;

@property(nonatomic, strong) UIButton *nextBtn; //下一步
@end

@implementation WelcomBackupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init]; //创建一个layout布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical; //设置布局方向为垂直流布局，系统会在一行充满后进行第二行的排列，如果设置为水平布局，则会在一列充满后，进行第二列的布局，这种方式也被称为流式布局
    layout.itemSize = CGSizeMake(KWIDTH/5, 30);
    layout.sectionInset = UIEdgeInsetsMake(0, 15, 15, 15);
    layout.headerReferenceSize = CGSizeMake(KWIDTH, 93); //设置头部的size
    self.collect = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, iPhoneX ? KHEIGHT-kNavigationBarHeight - 40 - 20 : KHEIGHT -kNavigationBarHeight- 40) collectionViewLayout:layout];//创建collectionView 通过一个布局策略layout来创建
    self.collect.delegate = self;
    self.collect.dataSource = self;
    
    
    //TODO...

    self.memonryWords = [self.memonry componentsSeparatedByString:@" "];
    
    
    //注册item类型 这里使用系统的类型
//    [self.collect registerClass:[MnemonicWordCell class] forCellWithReuseIdentifier:cellId];
    [self.collect registerNib:[UINib nibWithNibName:NSStringFromClass([MnemonicWordCell class]) bundle:nil] forCellWithReuseIdentifier:cellId];
    [self.collect registerNib:[UINib nibWithNibName:NSStringFromClass([MnemonicWordHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerView];
    
    [self.collect registerNib:[UINib nibWithNibName:NSStringFromClass([MnemonicWordCell2 class]) bundle:nil] forCellWithReuseIdentifier:cellId2];
    [self.collect registerNib:[UINib nibWithNibName:NSStringFromClass([MnemonicWordHeaderView2 class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerView2];
    [self.collect registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerView2];
    self.collect.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collect];
    
    [self makeNextBtn];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationItem.hidesBackButton = YES;
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //禁止侧滑返回--不能放在willAppear,会卡死
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}
-(void)makeNextBtn{

    CGFloat height = 50;
    CGFloat y = iPhoneX ? KHEIGHT - kNavigationBarHeight - height - 20 : KHEIGHT-kNavigationBarHeight - height;
    self.nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, y, KWIDTH, height)];
//    [self.nextBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg_blue"] forState:UIControlStateNormal];
    [self.nextBtn setBackgroundColor:kColorBlue];
   
    if(self.needVertify){
        [self.nextBtn setTitle:NSLocalizedString(@"nextStep", @"下一步") forState:UIControlStateNormal];
        [self.nextBtn setBackgroundColor:kColorWithHexValue(0x6897fb)];
        [self.nextBtn setTitleColor:kColorWithHexValue(0xdfe8fe) forState:UIControlStateNormal];
        self.nextBtn.userInteractionEnabled = NO;
    }else{
        [self.nextBtn setTitle:NSLocalizedString(@"done", @"完成") forState:UIControlStateNormal];
    }
    [self.nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.nextBtn addTarget:self action:@selector(nextStepAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.nextBtn];
}

#pragma mark ---- Button Action
-(void)nextStepAction:(UIButton *)sender{
    if(self.needVertify){
        WelcomConfirmMnemonicVC *confirmVC = [[WelcomConfirmMnemonicVC alloc] init];
        confirmVC.menmonryWords = self.memonryWords;
        confirmVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:confirmVC animated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
//保存图片
-(void)saveINBQR{
    self.qrBtn.hidden = YES;
    self.qrTipL.text = NSLocalizedString(@"tip.insightQR.userIntro", @"使用方法");
    self.qrTipL.frame = CGRectMake(20, CGRectGetMaxY(self.qrAddrLabel.frame)-3, KWIDTH-40, 90);
    [self saveImageFromView:self.qrContentView];
    self.qrTipL.text = [NSString stringWithFormat:@"1.%@\n\n2.%@",NSLocalizedString(@"tip.insightQR_1",  @"二维码仅在使用INB钱包扫码导入私钥时使用"), NSLocalizedString(@"tip.insightQR_2", @"输入正确的私钥读取密码才能成功导入INB钱包，请妥善保管密码。")];
    self.qrTipL.frame = CGRectMake(20, CGRectGetMaxY(self.qrBtn.frame)+5, KWIDTH-40, 90);
    self.qrBtn.hidden = NO;
}
//设置密码done
-(void)qrPwdDoneAction{
    if (self.qrPwdTF.text.length < 6 || self.qrPwdTF.text.length > 15) {
        [MBProgressHUD showMessage:@"密码格式不正确" toView:App_Delegate.window afterDelay:1.0 animted:YES];
        return;
    }
    [self makeQRView:self.qrPwdTF.text];
    self.qrPwdView.hidden = YES;
    self.qrContentView.hidden = NO;
    
    [self.nextBtn setBackgroundColor:kColorBlue];
    [self.nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.nextBtn.userInteractionEnabled = YES;
}
//显示、隐藏密码
-(void)passwordHideAction1:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.qrPwdTF.secureTextEntry = !self.qrPwdTF.secureTextEntry;
}
#pragma mark ---- UICollectionDataSource && Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}
//设置每个分区的Item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(section == 0){
        return self.memonryWords.count;
    }else if(section == 1){
        return 1;
    }else{
        return 0;
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MnemonicWordCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
        cell.wordLabel.text = self.memonryWords[indexPath.row];
        return cell;
    }else if(indexPath.section == 1){
        MnemonicWordCell2 *cell2 = [collectionView dequeueReusableCellWithReuseIdentifier:cellId2 forIndexPath:indexPath];
        cell2.keyTextView.text = self.privateKey;
        return cell2;
    }else{
        return nil;
    }
}
//设置每个item的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return CGSizeMake(KWIDTH, 100);
    }else{
        return CGSizeMake(KWIDTH/5, 30);
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
         return CGSizeMake(KWIDTH, 93); //设置头部的size
    }else if (section == 1){
        return CGSizeMake(KWIDTH, 48);
    }else if(section == 2){
        return CGSizeMake(KWIDTH, 0);
    }else{
        return CGSizeMake(0, 0);
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return CGSizeMake(KWIDTH, 300+60);
    }else{
         return CGSizeMake(0, 0);
    }
}
//对头视图或者尾视图进行设置
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if([kind isEqualToString:UICollectionElementKindSectionHeader]){
            MnemonicWordHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerView forIndexPath:indexPath];
            return header;
        }else{
            return nil;
        }
    }else if(indexPath.section == 1){
        if([kind isEqualToString:UICollectionElementKindSectionHeader]){
            MnemonicWordHeaderView2 *header2 = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerView2 forIndexPath:indexPath];
            return header2;
        }else{
            return nil;
        }
    }else if(indexPath.section == 2){
        if([kind isEqualToString:UICollectionElementKindSectionHeader]){
            MnemonicWordHeaderView2 *header2 = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerView2 forIndexPath:indexPath];
            header2.titleLabel.text = NSLocalizedString(@"qr.unique.inb", @"INB钱包专属二维码");
            return header2;
        }else if([kind isEqualToString:UICollectionElementKindSectionFooter]){
            UICollectionReusableView *footer= [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerView2 forIndexPath:indexPath];
            
            self.qrPwdView.frame = CGRectMake(0, 0, KWIDTH, 300);
            self.qrPwdL.frame = CGRectMake(15, 5, KWIDTH, 25);
            UIImageView *tfBg = [[UIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.qrPwdL.frame)+5, KWIDTH-30, 45)];
            tfBg.image = [UIImage imageNamed:@"textField_bg"];
            self.qrPwdTF.frame = CGRectMake(15+5, CGRectGetMaxY(self.qrPwdL.frame)+5, KWIDTH-40, 45);
            self.qrPwdDone.frame = CGRectMake(15, CGRectGetMaxY(self.qrPwdTF.frame)+10, KWIDTH-30, 45);
            self.qrPwdTipL.frame = CGRectMake(15, CGRectGetMaxY(self.qrPwdDone.frame)+20, KWIDTH-30, 60);
            
            [self.qrPwdView addSubview:self.qrPwdL];
            [self.qrPwdView addSubview:tfBg];
            [self.qrPwdView addSubview:self.qrPwdTF];
            [self.qrPwdView addSubview:self.qrPwdDone];
            [self.qrPwdView addSubview:self.qrPwdTipL];
            
            
            self.qrContentView.hidden = YES;
            
            [footer addSubview:self.qrContentView];
            [footer addSubview:self.qrPwdView];
            
            return footer;
        }else{
            return nil;
        }
    } else{
        return nil;
    }
}

-(void)makeQRView:(NSString *)pwd{
    self.qrContentView.frame = CGRectMake(0, 0, KWIDTH, 300);
    
    
    UILabel *qrTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, KWIDTH, 30)];
    qrTipLabel.textAlignment = NSTextAlignmentCenter;
    qrTipLabel.font = AdaptedFontSize(15);
    qrTipLabel.textColor = kColorBlue;
    qrTipLabel.text = NSLocalizedString(@"qr.unique.inb", @"INB钱包专属二维码");
    
    NSString *entry = [EncryptUtils encryptByAES:self.memonry key:keyEntryQR];
    NSString *entry2 = [EncryptUtils encryptByAES:self.memonry key:[NSString CharacterStringMainString:pwd AddDigit:16 AddString:@"0"]];
    NSDictionary *infoDic = @{@"type":@(1),@"content":entry2};
    NSString *jsonStr = [infoDic toJSONString];
    self.qrImg.image = [UIImage createQRImgae:jsonStr size:100 centerImg:nil centerImgSize:0];
    self.qrImg.frame = CGRectMake((KWIDTH - qrImgSize)/2.0, CGRectGetMaxY(qrTipLabel.frame)+5, qrImgSize, qrImgSize);
    
    self.qrAddrLabel.frame = CGRectMake((KWIDTH-200)/2.0, CGRectGetMaxY(self.qrImg.frame)+5, 200, 45);
    self.qrAddrLabel.textAlignment = NSTextAlignmentCenter;
    self.qrAddrLabel.text = [NSString stringWithFormat:@"%@", [self.address add0xIfNeeded]];
    
    self.qrBtn.frame = CGRectMake((KWIDTH-140)/2.0, CGRectGetMaxY(self.qrAddrLabel.frame)+5, 140, 35);
    self.qrTipL.frame = CGRectMake(20, CGRectGetMaxY(self.qrBtn.frame)+5, KWIDTH-40, 90);
    
    [self.qrContentView addSubview:qrTipLabel];
    [self.qrContentView addSubview:self.qrImg];
    [self.qrContentView addSubview:self.qrAddrLabel];
    [self.qrContentView addSubview:self.qrBtn];
    [self.qrContentView addSubview:self.qrTipL];
}
#pragma mark ----
-(UIView *)qrContentView{
    if (_qrContentView == nil) {
        _qrContentView = [[UIView alloc] init];
    }
    return _qrContentView;
}
-(UIImageView *)qrImg{
    if (_qrImg == nil) {
        _qrImg = [[UIImageView alloc] init];
    }
    return _qrImg;
}
-(UILabel *)qrAddrLabel{
    if (_qrAddrLabel == nil) {
        _qrAddrLabel = [[UILabel alloc] init];
        _qrAddrLabel.textColor = kColorTitle;
        _qrAddrLabel.font = [UIFont systemFontOfSize:13];
        _qrAddrLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _qrAddrLabel.numberOfLines = 0;
    }
    return _qrAddrLabel;
}
-(UIButton *)qrBtn{
    if (_qrBtn == nil) {
        _qrBtn = [[UIButton alloc] init];
        [_qrBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg_blue"] forState:UIControlStateNormal];
        [_qrBtn setTitle:NSLocalizedString(@"saveQRCode", @"保存二维码") forState:UIControlStateNormal];
        [_qrBtn addTarget:self action:@selector(saveINBQR) forControlEvents:UIControlEventTouchUpInside];
        _qrBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _qrBtn;
}
-(UILabel *)qrTipL{
    if (_qrTipL == nil) {
        _qrTipL = [[UILabel alloc] init];
        _qrTipL.textColor = kColorAuxiliary2;
        _qrTipL.font = [UIFont systemFontOfSize:13];
        _qrTipL.numberOfLines = 0;
        _qrTipL.text = [NSString stringWithFormat:@"1.%@\n\n2.%@",NSLocalizedString(@"tip.insightQR_1",  @"二维码仅在使用INB钱包扫码导入私钥时使用"), NSLocalizedString(@"tip.insightQR_2", @"输入正确的私钥读取密码才能成功导入INB钱包，请妥善保管密码。")];
    }
    return _qrTipL;
}

-(UIView *)qrPwdView{
    if (_qrPwdView == nil) {
        _qrPwdView = [[UIView alloc] init];
    }
    return _qrPwdView;
}
-(UILabel *)qrPwdL{
    if (_qrPwdL == nil) {
        _qrPwdL = [[UILabel alloc] init];
        _qrPwdL.textAlignment = NSTextAlignmentLeft;
        _qrPwdL.textColor = kColorTitle;
        _qrPwdL.font = [UIFont systemFontOfSize:15];
        _qrPwdL.text = NSLocalizedString(@"password.pwdQR.setTip", @"设置私钥读取密码");
    }
    return _qrPwdL;
}
-(UITextField *)qrPwdTF{
    if (_qrPwdTF == nil) {
        _qrPwdTF = [[UITextField alloc] init];
        _qrPwdTF.placeholder = NSLocalizedString(@"password.style", @"6-15位由大小写英文、数字或符号组成");
        UIButton *eyeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, AdaptedHeight(45))];
        [eyeBtn setImage:[UIImage imageNamed:@"eye_close_blue"] forState:UIControlStateNormal];
        [eyeBtn setImage:[UIImage imageNamed:@"eye_open_blue"] forState:UIControlStateSelected];
        [eyeBtn addTarget:self action:@selector(passwordHideAction1:)
          forControlEvents:UIControlEventTouchUpInside];
        _qrPwdTF.rightView = eyeBtn;
        _qrPwdTF.rightViewMode = UITextFieldViewModeAlways;
        _qrPwdTF.secureTextEntry = YES;
    }
    return _qrPwdTF;
}
-(UIButton *)qrPwdDone{
    if (_qrPwdDone == nil) {
        _qrPwdDone = [[UIButton alloc] init];
        [_qrPwdDone setBackgroundImage:[UIImage imageNamed:@"btn_bg_blue"] forState:UIControlStateNormal];
        [_qrPwdDone setTitle:NSLocalizedString(@"setting.done", @"设置完成") forState:UIControlStateNormal];
        [_qrPwdDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_qrPwdDone addTarget:self action:@selector(qrPwdDoneAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _qrPwdDone;
}
-(UILabel *)qrPwdTipL{
    if (_qrPwdTipL == nil) {
        _qrPwdTipL = [[UILabel alloc] init];
        _qrPwdTipL.numberOfLines = 0;
        _qrPwdTipL.font = [UIFont systemFontOfSize:13];
        _qrPwdTipL.text = NSLocalizedString(@"backup.first.qrPwd.tip", @"私钥读取密码会在使用扫码导入私钥恢复INB钱包时使用，密码忘记无法找回，请妥善保管，切勿向他人泄露。");
        _qrPwdTipL.textColor = kColorBlue;
    }
    return _qrPwdTipL;
}
@end
