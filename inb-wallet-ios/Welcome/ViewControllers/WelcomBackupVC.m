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

-(void)makeNextBtn{
    CGFloat height = 40;
    CGFloat y = iPhoneX ? KHEIGHT - kNavigationBarHeight - height - 20 : KHEIGHT-kNavigationBarHeight - height;
    self.nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, y, KWIDTH, height)];
//    [self.nextBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg_blue"] forState:UIControlStateNormal];
    [self.nextBtn setBackgroundColor:kColorBlue];
   
    if(self.needVertify){
        [self.nextBtn setTitle:NSLocalizedString(@"nextStep", @"下一步") forState:UIControlStateNormal];
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
    [self saveImageFromView:self.qrContentView];
    self.qrBtn.hidden = NO;
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
        return CGSizeMake(KWIDTH, 250+60);
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
            
            self.qrContentView.frame = CGRectMake(0, 0, KWIDTH, 270);
            
            UILabel *qrTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, KWIDTH, 30)];
            qrTipLabel.textAlignment = NSTextAlignmentCenter;
            qrTipLabel.textColor = kColorTitle;
            qrTipLabel.font = [UIFont systemFontOfSize:15];
            qrTipLabel.text = NSLocalizedString(@"qr.unique.inb", @"INB钱包专属二维码");
            
            NSString *entry = [EncryptUtils encryptByAES:self.memonry key:keyEntryQR];
            NSDictionary *infoDic = @{@"type":@(1),@"content":entry};
            NSString *jsonStr = [infoDic toJSONString];
            self.qrImg.image = [UIImage createQRImgae:jsonStr size:100 centerImg:nil centerImgSize:0];
            self.qrImg.frame = CGRectMake((KWIDTH - qrImgSize)/2.0, CGRectGetMaxY(qrTipLabel.frame)+5, qrImgSize, qrImgSize);
            
            self.qrAddrLabel.frame = CGRectMake((KWIDTH-200)/2.0, CGRectGetMaxY(self.qrImg.frame)+5, 200, 45);
            self.qrAddrLabel.textAlignment = NSTextAlignmentCenter;
            self.qrAddrLabel.text = [NSString stringWithFormat:@"%@", [self.address add0xIfNeeded]];
            
            self.qrBtn.frame = CGRectMake((KWIDTH-140)/2.0, CGRectGetMaxY(self.qrAddrLabel.frame)+5, 140, 30);
            
            [self.qrContentView addSubview:qrTipLabel];
            [self.qrContentView addSubview:self.qrImg];
            [self.qrContentView addSubview:self.qrAddrLabel];
            [self.qrContentView addSubview:self.qrBtn];
            
            [footer addSubview:self.qrContentView];
            return footer;
        }else{
            return nil;
        }
    } else{
        return nil;
    }
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
@end
