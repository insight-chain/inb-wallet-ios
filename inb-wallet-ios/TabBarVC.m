//
//  TabBarVC.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/2.
//  Copyright © 2019 apple. All rights reserved.
//

#import "TabBarVC.h"
#import "CCNavigationController.h"

#import "UIColor+Image.h"

@interface TabBarVC ()

@end

@implementation TabBarVC

+(void)initialize{
    //通过appearance统一设置所有UITabBarItem的文字属性
    UITabBarItem *tabBarItem = [UITabBarItem appearance];
    
    UIColor *unSelectedTextColor = kColorAuxiliary;
    UIColor *selectedTextColor   = kColorBlue;
    
    [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:unSelectedTextColor,
                                         NSFontAttributeName:AdaptedFontSize(10)
                                         } forState:UIControlStateNormal];
    [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:selectedTextColor,
                                         NSFontAttributeName:AdaptedFontSize(10)
                                         } forState:UIControlStateSelected];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)setHidesBottomBarWhenPushed:(BOOL)hidesBottomBarWhenPushed{
    [super setHidesBottomBarWhenPushed:hidesBottomBarWhenPushed];
    self.tabBar.hidden = hidesBottomBarWhenPushed;
}

-(void)addChildViewController:(UIViewController *)childVC norImage:(UIImage *)norImage selImage:(UIImage *)selImage title:(NSString *)title tabTitle:(NSString *)tabTitle{
    CCNavigationController *nav = [[CCNavigationController alloc] initWithRootViewController:childVC];
    nav.useSystemAnimatedTransitioning = YES;
    /** 导航栏返回按钮图片 **/
    [nav.navigationBar setBackIndicatorImage:[UIImage imageNamed:@"nav_back_arrow"]];
    [nav.navigationBar setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"nav_back_arrow"]];

    /** 导航栏背景色 **/
    [childVC.navigationController.navigationBar setBarTintColor:kColorBlue];
    childVC.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:AdaptedFontSize(16)};
    
    /** 导航栏返回按钮文字 **/
    childVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    childVC.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];

    childVC.title = title;
    childVC.tabBarItem.image = [norImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//渲染模式初始化
    childVC.tabBarItem.selectedImage = [selImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVC.tabBarItem.title = tabTitle;
    childVC.navigationController.navigationBar.translucent = NO;
    //去掉透明后导航栏下边的黑边
    [childVC.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    [self addChildViewController:nav];
}


@end
