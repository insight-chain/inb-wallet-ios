//
//  ResourcePageViewController.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/9/3.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "ResourcePageViewController.h"
#import "mortgageVC.h"
#import "redeemVC.h"
#import "BaseTableViewVC.h"

#import "ResourceCPUView.h"

#import "MJRefresh.h"

@interface ResourcePageViewController ()<PageViewControllerDataSource, PageViewControllerDelegate, YNPageViewControllerDelegate, YNPageViewControllerDataSource>

@property (nonatomic, strong) ResourceCPUView *cpuView;

@end

@implementation ResourcePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.cpuView.balanceValue.text = [NSString stringWithFormat:@"%d RES",(int)self.canUseNet];
    self.cpuView.totalValue.text = [NSString stringWithFormat:@"%d RES", (int)self.totalNet];
    self.cpuView.mortgageValue.text = [NSString stringWithFormat:@"%.2f INB", self.mortgageINB];
    [self.cpuView updataProgress]; //更新进度条图片
}

//+(instancetype)reourcePageVC{
//    ResourcePageViewController *vc = [ResourcePageViewController pageViewControllerWithControllers:[self getArrayVCs] titles:[self getArrayTitles]];
//    ResourceCPUView *cpuView = [[ResourceCPUView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, 250)];;
//    vc.headerView = cpuView;
//
//    vc.pageIndex = 1; //默认选择index页面
//
//    __weak typeof(ResourcePageViewController *) weakVC = vc;
//    vc.bgScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{ //下拉刷新
//        NSInteger refreshPage = weakVC.pageIndex;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            if(refreshPage == 1){
//                [weakVC.bgScrollView.mj_header endRefreshing];
//            }
//        });
//    }];
//    vc.delegate = vc;
//    vc.dataSource = vc;
//
//    return vc;
//
//}
+(NSArray *)getArrayVCs{
    mortgageVC *vc1 = [[mortgageVC alloc] init];
    redeemVC *vc2 = [[redeemVC alloc] init];

    vc1.tableView.backgroundColor = kColorBackground;
    vc1.address = App_Delegate.selectAddr;
    vc1.walletID = App_Delegate.selectWalletID;
    

    vc2.tableView.backgroundColor = kColorBackground;
    return @[vc1, vc2];
}
+(NSArray *)getArrayTitles{
    return @[@"抵押", @"已抵押"];
}

//#pragma mark ---- PageViewControllerDataSource
//-(UIScrollView *)pageViewController:(BaseResourcePageViewController *)pageViewController pageForIndex:(NSInteger)index{
//    UIViewController *vc = pageViewController.controllersM[index];
//    return [(redeemVC *)vc tableView];
//
//}
#pragma mark ---- PageViewControllerDelegate


+(instancetype)suspendTopPausePageVC{
    YNPageConfigration *configration = [YNPageConfigration defaultConfig];
    configration.pageStyle = YNPageStyleSuspensionTopPause;
    configration.headerViewCouldScale = YES;
    configration.showTabbar = NO;
    configration.showNavigation = YES;
    configration.scrollMenu = NO;
    configration.itemMargin = 50;
    configration.aligmentModeCenter = YES;
    configration.lineWidthEqualFontWidth = YES;
    configration.showBottomLine = NO;
    configration.selectedItemColor = kColorBlue;
    configration.normalItemColor = kColorAuxiliary;
    configration.lineColor = kColorBlue;
    
    ResourcePageViewController *vc = [ResourcePageViewController pageViewControllerWithControllers:[self getArrayVCs] titles:[self getArrayTitles] config:configration];
    vc.dataSource = vc;
    vc.delegate = vc;
    
    ResourceCPUView *cpuView = [[ResourceCPUView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, 250)];
    vc.cpuView = cpuView;
    vc.headerView = cpuView;
    
    vc.pageIndex = 1;
    
    __weak typeof(ResourcePageViewController *) weakVC = vc;
    
    vc.bgScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        NSInteger refreshPage = weakVC.pageIndex;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (refreshPage == 1) {
                /// 取到之前的页面进行刷新 pageIndex 是当前页面
                redeemVC *vc2 = weakVC.controllersM[refreshPage];
                [vc2 request];
                [vc2.tableView reloadData];
            }
            [weakVC.bgScrollView.mj_header endRefreshing];
            
        });
    }];
    return vc;
}
#pragma mark - YNPageViewControllerDataSource
- (UIScrollView *)pageViewController:(YNPageViewController *)pageViewController pageForIndex:(NSInteger)index {
    UIViewController *vc = pageViewController.controllersM[index];
    return [(BaseTableViewVC *)vc tableView];
}

#pragma mark - YNPageViewControllerDelegate
- (void)pageViewController:(YNPageViewController *)pageViewController
            contentOffsetY:(CGFloat)contentOffset
                  progress:(CGFloat)progress {
    NSLog(@"--- contentOffset = %f,    progress = %f", contentOffset, progress);
}


@end
