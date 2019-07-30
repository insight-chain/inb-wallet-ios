//
//  TabBarVC.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/2.
//  Copyright © 2019 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TabBarVC : UITabBarController

/**
 *  给tabBarViewController 添加子控制器
 *  @param childVC 添加的viewController
 *  @param norImage 未选中时的tabBar图片
 *  @param selImage 选中时的tabBar图片
 *  @param title    导航栏的title
 *  @param tabTitle TabBar的title
 */
-(void)addChildViewController:(UIViewController *)childVC norImage:(UIImage *)norImage selImage:(UIImage *)selImage title:(NSString *)title tabTitle:(NSString *)tabTitle;

@end

NS_ASSUME_NONNULL_END
