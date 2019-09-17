//
//  ResourcePageViewController.h
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/9/2.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageScrollView.h"
#import "PageScrollMenuView.h"

@class BaseResourcePageViewController;

NS_ASSUME_NONNULL_BEGIN

#pragma mark ---- PageViewControllerDelegate
@protocol PageViewControllerDelegate<NSObject>
@optional
/**
 滚动列表内容时回调
 @param pageViewController PageVC
 @param contentOffsetY 内容偏移量
 @param progress 进度
 */
-(void)pageViewController:(BaseResourcePageViewController *)pageViewController contentOffsetY:(CGFloat)contentOffsetY progress:(CGFloat)progress;
/**
 UIScrollView拖动停止时回调, 可用来自定义 ScrollMenuView
 @param pageViewController PageVC
 @param scrollView UIScrollView
 */
-(void)pageViewController:(BaseResourcePageViewController *)pageViewController didEndDecelerating:(UIScrollView *)scrollView;
/**
 UIScrollView滚动时回调, 可用来自定义 ScrollMenuView
 @param pageViewController PageVC
 @param scrollView UIScrollView
 @param progress 进度
 @param fromIndex 从哪个页面
 @param toIndex 到哪个页面
 */
-(void)pageViewController:(BaseResourcePageViewController *)pageViewController didScroll:(UIScrollView *)scrollView progress:(CGFloat)progress fromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;
/**
 点击菜单栏Item的即刻回调
 @param pageViewController PageVC
 @param itemButton item
 @param index 下标
 */
-(void)pageViewController:(BaseResourcePageViewController *)pageViewController didScrollMenuItem:(UIButton *)itemButton index:(NSInteger)index;
@end

#pragma mark ---- PageViewControllerDataSource
@protocol PageViewControllerDataSource <NSObject>
@required
/**
 根据 index 取 数据源 ScrollView
 @param pageViewController PageVC
 @param index pageIndex
 @return 数据源
 */
-(__kindof UIScrollView *)pageViewController:(BaseResourcePageViewController *)pageViewController pageForIndex:(NSInteger)index;
@optional
/**
 取得ScrollView(列表)的高度 默认是控制器的高度 可用于自定义底部按钮(订单、确认按钮)等控件
 @param pageViewController PageVC
 @param index pageIndex
 @return ScrollView高度
 */
-(CGFloat)pageViewController:(BaseResourcePageViewController *)pageViewController heightForScrollViewAtIndex:(NSInteger)index;
/**
 自定义缓存Key 如果不实现，则不允许相同的菜单栏title
 如果对页面进行了添加、删除、调整顺序、请一起调整传递进来的数据源，防止缓存Key取错
 @param pageViewController pageVC
 @param index pageIndex
 @return 唯一标识 (一般是后台ID)
 */
-(NSString *)pageViewController:(BaseResourcePageViewController *)pageViewController customCacheKeyForIndex:(NSInteger)index;
@end

@interface BaseResourcePageViewController : UIViewController


@property (nonatomic, strong) NSMutableArray<__kindof UIViewController *> *controllersM;/// 控制器数组
@property (nonatomic, strong) PageScrollMenuView *scrollMenuView;/// 菜单栏

@property (nonatomic, strong, readonly) PageScrollView *bgScrollView;/// 背景ScrollView
@property (nonatomic, strong) UIView *headerView; /// 头部headerView

@property (nonatomic, weak) id<PageViewControllerDataSource> dataSource; //数据源
@property (nonatomic, weak) id<PageViewControllerDelegate> delegate; //代理

@property (nonatomic, assign) NSInteger pageIndex; /// 当前页面index


#pragma mark ---- initialize
/**
 初始化方法
 @param controllers 子控制器
 @param titles 标题
 */
+(instancetype)pageViewControllerWithControllers:(NSArray *)controllers titles:(NSArray *)titles;
/**
 初始化方法
 @param controllers 子控制器
 @param titles 标题
 */
-(instancetype)initPageViewControllerWithControllers:(NSArray *)controllers titles:(NSArray *)titls;
@end

NS_ASSUME_NONNULL_END
