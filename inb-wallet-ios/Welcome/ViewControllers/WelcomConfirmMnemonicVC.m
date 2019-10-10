//
//  WelcomConfirmMnemonicVC.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/30.
//  Copyright © 2019 apple. All rights reserved.
//

#import "WelcomConfirmMnemonicVC.h"
#import "LZCollectionViewFlowLayout.h"

#import "WalletInfoVC.h"
#import "TabBarVC.h"

#import "MnemonicWordCell.h"

#import "Identity.h"
#import "WalletManager.h"

#define cellId  @"menmonicWordCell"
#define headerViewId @"mnemonicwordConfirmHeaderView"

@interface WelcomConfirmMnemonicVC ()

@property(nonatomic, strong) ContentTopView *contentView;
@property(nonatomic, strong) PassphraseView *proposalView;
@property(nonatomic, strong) UIButton *doneBtn;

@property(nonatomic, strong) NSArray *words; //助记词
@property(nonatomic, strong) NSArray *shuffledWords; //乱序的助记词
@end

@implementation WelcomConfirmMnemonicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /** View被导航栏遮挡问题的解决 **/
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.doneBtn.enabled = NO;
    
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.proposalView];
    [self.view addSubview:self.doneBtn];
    
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(300);
    }];
    [self.proposalView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(150);
    }];
    [self.doneBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(195);
        make.top.mas_equalTo(self.proposalView.mas_bottom).mas_offset(50);
    }];
    [self.contentView.contentView.collectionView layoutIfNeeded];
    [self.proposalView.collectionView layoutIfNeeded];
    
    self.contentView.contentView.words = @[];
    self.proposalView.words = [self randamArry:self.menmonryWords];
    
    __block __weak typeof(self) tmpSelf = self;
    self.proposalView.didDeleteItem = ^(NSString * _Nonnull item) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray *mutArr = [NSMutableArray arrayWithArray:tmpSelf.contentView.contentView.words] ;
            if ([mutArr containsObject:item]) {
                return;
            }
            mutArr[tmpSelf.contentView.contentView.lastNumber] = item;
            tmpSelf.contentView.contentView.words = (NSArray *)mutArr;
            tmpSelf.contentView.contentView.lastNumber++;
            if (mutArr.count == self.menmonryWords.count) {
                tmpSelf.doneBtn.enabled = YES;
            }else{
                tmpSelf.doneBtn.enabled = NO;
            }
        });
    };
    self.contentView.contentView.didDeleteItem = ^(NSString * _Nonnull item) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([item isEqualToString:@""] || item == nil){
                return;
            }
            NSMutableArray *mutArr = [NSMutableArray arrayWithArray:tmpSelf.contentView.contentView.words] ;
            NSInteger oldIndex = [tmpSelf.contentView.contentView.words indexOfObject:item];
            if([mutArr containsObject:item]){
                [mutArr removeObject:item];
            }
            tmpSelf.contentView.contentView.words = (NSArray *)mutArr;
            tmpSelf.contentView.contentView.lastNumber--;
            
            NSInteger index = [tmpSelf.proposalView.words indexOfObject:item];
            [tmpSelf.proposalView deleteItem:index];
            
            if (mutArr.count == self.menmonryWords.count) {
                tmpSelf.doneBtn.enabled = YES;
            }else{
                tmpSelf.doneBtn.enabled = NO;
            }
        });
    };
}

- (NSArray *)randamArry:(NSArray *)arry
{
    // 对数组乱序
    arry = [arry sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
        int seed = arc4random_uniform(2);
        
        if (seed) {
            return [str1 compare:str2];
        } else {
            return [str2 compare:str1];
        }
    }];
    
    return arry;
}

#pragma mark ---- Button Action
-(void)doneAction:(UIButton *)sender{
    //助记词校验
    if(self.contentView.contentView.words.count != self.menmonryWords.count){
        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
        hud.label.text = @"助记词验证不正确";
        [hud hideAnimated:YES afterDelay:1];
        return ;

    }
    int count = (int)self.menmonryWords.count;
    for (int i=0; i<count; i++) {
        if(![self.contentView.contentView.words[i] isEqualToString:self.menmonryWords[i]]){
            [MBProgressHUD showMessage:@"助记词顺序错误，请重新确认" toView:self.view afterDelay:1.5 animted:YES];
            return ;
        }
    }
    
    NSArray *wallets = [Identity currentIdentity].wallets;
    BasicWallet *firstWallet = wallets.firstObject;
    
    /** 钱包 **/
    WalletInfoVC *walletInfoVC = [[WalletInfoVC alloc] init];
    walletInfoVC.title = @"钱包";
    walletInfoVC.view.backgroundColor = [UIColor whiteColor];
    
    walletInfoVC.selectedWallet = firstWallet;
    walletInfoVC.wallets = wallets;
    
    /** 导航栏背景色 **/
    [walletInfoVC.navigationController.navigationBar setBarTintColor:kColorBlue];
    walletInfoVC.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:AdaptedFontSize(16)};
    
    /** 导航栏返回按钮文字 **/
    walletInfoVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    walletInfoVC.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];
    
    walletInfoVC.title = @"Insight钱包";
    walletInfoVC.tabBarItem.image = [[UIImage imageNamed:@"tab_wallet_no"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//渲染模式初始化
    walletInfoVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_wallet_yes"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    walletInfoVC.tabBarItem.title = @"钱包";
    
    TabBarVC *tab = (TabBarVC *)self.tabBarController;
    CCNavigationController *navi = tab.viewControllers[0];
    [navi setViewControllers:@[walletInfoVC] animated:YES];
}

-(ContentTopView *)contentView{
    if (_contentView == nil) {
        _contentView = [[ContentTopView alloc] init];
    }
    return _contentView;
}
-(PassphraseView *)proposalView{
    if (_proposalView == nil) {
        _proposalView = [[PassphraseView alloc] init];
        _proposalView.backgroundColor = [UIColor whiteColor];
        _proposalView.collectionView.backgroundColor = [UIColor whiteColor];
        _proposalView.colunNumber = 4;
        _proposalView.isEditable = NO;
    }
    return _proposalView;
}
-(UIButton *)doneBtn{
    if(_doneBtn == nil){
        _doneBtn = [[UIButton alloc] init];
        UIImage *img = [UIImage imageNamed:@"btn_bg_blue"];
        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height/2.0, img.size.width/2.0, img.size.height/2.0, img.size.width/2.0) resizingMode:UIImageResizingModeStretch];
        UIImage *lightImg = [UIImage imageNamed:@"btn_bg_lightBlue"];
        lightImg = [lightImg resizableImageWithCapInsets:UIEdgeInsetsMake(lightImg.size.height/2.0, lightImg.size.width/2.0, lightImg.size.height/2.0, lightImg.size.width/2.0) resizingMode:UIImageResizingModeStretch];
        [_doneBtn setBackgroundImage:img forState:UIControlStateNormal];
        [_doneBtn setBackgroundImage:lightImg forState:UIControlStateDisabled];
        [_doneBtn setTitle:NSLocalizedString(@"done", @"完成") forState:UIControlStateNormal];
        [_doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _doneBtn.titleLabel.font = AdaptedFontSize(15);
        [_doneBtn addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneBtn;
}
@end


#pragma mark ---- ContetTopView
@interface ContentTopView()
@property(nonatomic, strong) UIImageView *hornImg;
@property(nonatomic, strong) UILabel *tipLabel;
@end
@implementation ContentTopView
-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = kColorBackground;

        [self addSubview:self.hornImg];
        [self addSubview:self.tipLabel];
        [self addSubview:self.contentView];
        
        [self.hornImg mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(15);
            make.width.height.mas_equalTo(15);
        }];
        [self.tipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.hornImg);
            make.left.mas_equalTo(self.hornImg.mas_right).mas_offset(5);
        }];
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.tipLabel.mas_bottom).mas_offset(15);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-15);
        }];
    }
    return self;
}
-(PassphraseView *)contentView{
    if (_contentView == nil) {
        _contentView = [[PassphraseView alloc] init];
        UIImage *img = [UIImage imageNamed:@"sectionBg"];
        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height/2.0, img.size.width/2.0, img.size.width/2.0, img.size.height/2.0) resizingMode:UIImageResizingModeStretch];
        _contentView.collectionView.backgroundView = [[UIImageView alloc] initWithImage:img];
        _contentView.collectionView.backgroundColor = self.backgroundColor;
        _contentView.colunNumber = 4;
        _contentView.isEditable = YES;
    }
    return _contentView;
}
-(UIImageView *)hornImg{
    if (_hornImg == nil) {
        _hornImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"horn"]];
    }
    return _hornImg;
}
-(UILabel *)tipLabel{
    if (_tipLabel == nil) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = NSLocalizedString(@"wallet.create.confrimMnemonicTip", @"按照顺序点击助记词，确认您的身份");
        _tipLabel.font = AdaptedFontSize(14);
        _tipLabel.textColor = kColorBlue;
    }
    return _tipLabel;
}
@end
