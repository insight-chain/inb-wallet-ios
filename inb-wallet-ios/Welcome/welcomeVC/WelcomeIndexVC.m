//
//  WelcomeVC.m
//  boluolicai
//
//  Created by 张松超 on 15/12/23.
//  Copyright © 2015年 Pusupanshi. All rights reserved.
//

#import "WelcomeIndexVC.h"
#import "CPPageControl.h"

#define kGuideVersion @"kGuideVersion"

#define kWelcomePageNum   3


@interface WelcomeIndexVC ()<UIScrollViewDelegate>
{
    UIScrollView *mScroll;
    int _currentPage;
}
@property (nonatomic, strong) CPPageControl *page;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *contentArray;

@end

@implementation WelcomeIndexVC

+ (BOOL)welcomeNeedsDisplay:(NSString *)version {
    return [[[NSUserDefaults standardUserDefaults] stringForKey:kGuideVersion] isEqualToString:APP_VERSION];
}


+ (void)saveVersion {
    [[NSUserDefaults standardUserDefaults] setObject:APP_VERSION forKey:kGuideVersion];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [WelcomeIndexVC saveVersion];
    mScroll = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    mScroll.contentSize = CGSizeMake(KWIDTH * kWelcomePageNum, KHEIGHT);
    mScroll.pagingEnabled = YES;
    mScroll.bounces = NO;
    mScroll.showsHorizontalScrollIndicator = NO;
    mScroll.delegate = self;
    [self.view addSubview:mScroll];
    
    _currentPage = 0;
    _page = [[CPPageControl alloc] initWithFrame:CGRectMake(0, KHEIGHT - 50, KWIDTH, 20)];
    _page.numberOfPages = kWelcomePageNum;
    _page.currentTintColor = kColorBlue;
    _page.tintColor = kColorLightBlue;
    [self.view addSubview:_page];
    
    for (int i = 0; i < kWelcomePageNum; i++) {
        //整体是个view
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(KWIDTH*i, 0, KWIDTH, KHEIGHT)];
        view.backgroundColor = [UIColor whiteColor];//kColorWithHexValue(0xdaedff);
        [mScroll addSubview:view];
        //图片
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, KHEIGHT/8, 375, 415)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"welcome(%d)",i+1]];
        [view addSubview:imageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, CGRectGetMaxY(imageView.frame)+20, KWIDTH-70, 30)];
        titleLabel.text = self.titleArray[i];
        titleLabel.textColor = kColorWithHexValue(0x303030);
        titleLabel.font = [UIFont boldSystemFontOfSize:22.0];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [view addSubview:titleLabel];
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, CGRectGetMaxY(titleLabel.frame)+10, KWIDTH-70, 50)];
        contentLabel.text = self.contentArray[i];
        contentLabel.numberOfLines = 0;
        contentLabel.textColor = kColorWithHexValue(0x303030);
        contentLabel.font = [UIFont systemFontOfSize:15.0];
        contentLabel.textAlignment = NSTextAlignmentLeft;
        
        
        [view addSubview:contentLabel];
        
        
        if (i == kWelcomePageNum -1) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(KWIDTH*0.28,CGRectGetMaxY(contentLabel.frame)+30, 50, 50);
            [btn setImage:[UIImage imageNamed:@"welcom_raw"] forState:UIControlStateNormal];
            btn.center = CGPointMake(KWIDTH*(kWelcomePageNum-0.5), _page.center.y);
            [btn addTarget:self action:@selector(showRootVC:) forControlEvents:UIControlEventTouchUpInside];
            [mScroll addSubview:btn];
        }
    }
}

- (void)showRootVC:(UIButton *)btn
{
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionFade];
    [animation setDuration:0.5];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:
                                  kCAMediaTimingFunctionEaseInEaseOut]];
    [[[UIApplication sharedApplication].keyWindow layer] addAnimation:animation forKey:@"launchAnimation"];
    if (self.guideFinishBlock) {
        self.guideFinishBlock();
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
#pragma mark -- scrollview的delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //page的计算方法为scrollView的偏移量除以屏幕的宽度即为第几页。
    int page = scrollView.contentOffset.x/CGRectGetWidth(self.view.frame);
    if(page == kWelcomePageNum - 1){
        _page.hidden = YES;
    }else{
        _page.hidden = NO;
    }
    _page.currentPage = page;
}
#pragma mark ---- 懒加载
-(NSArray *)titleArray{
    if(_titleArray == nil){
        _titleArray = @[NSLocalizedString(@"welcome.title1", @"多重交易类型支撑"),
                    NSLocalizedString(@"welcome.title2", @"INB公链官方出品"),
                        NSLocalizedString(@"welcome.title3", @"多重安全保障"),
                    ];
    }
    return _titleArray;
}
-(NSArray *)contentArray{
    if(_contentArray == nil){
        _contentArray = @[NSLocalizedString(@"welcome.content1", @"锁仓抵押、节点投票"),
                        NSLocalizedString(@"welcome.content2", @"Insight Chain(INB)公链官方出品"),
                          NSLocalizedString(@"welcome.content3", @"使用增强的安全技术"),
                        ];
    }
    return _contentArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
