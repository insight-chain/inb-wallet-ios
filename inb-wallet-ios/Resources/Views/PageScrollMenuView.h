//
//  PageScrollMenuView.h
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/9/4.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//
/**
 * 菜单栏
 */
#import <UIKit/UIKit.h>

@class PageScrollMenuView;

#pragma mark ---- PageScrollMenuViewDelegate
@protocol PageScrollMenuViewDelegate <NSObject>
@optional
///点击item
-(void)pagescrollMenuViewItemOnClick:(UIButton *)button index:(NSInteger)index;
@end

NS_ASSUME_NONNULL_BEGIN

@interface PageScrollMenuView : UIView
@property (nonatomic, strong) NSMutableArray *titles; //标题数组

/**
 初始化YNPageScrollMenuView
 @param frame 大小
 @param titles 标题
 @param delegate 代理
 @param currentIndex 当前选中下标
 */
+(instancetype)pagescrollMenuViewWithFrame:(CGRect)frame titles:(NSMutableArray *)titles delegate:(id<PageScrollMenuViewDelegate>)delegate currentIndex:(NSInteger)currentIndex;


-(void)updateTitle:(NSString *)title index:(NSInteger)index;//根据标题下标修改标题
-(void)updateTitles:(NSArray *)titles; //根据标题数组刷新标题
-(void)adjustItemPositionWithCurrentIndex:(NSInteger)index; //根据下标调整Item位置
-(void)adjustItemWithProgress:(CGFloat)progress lastIndex:(NSInteger)lastIndex currentIndex:(NSInteger)currentIndex; //根据上个下标和当前点击的下标调整进度
-(void)selectedItemIndex:(NSInteger)index animated:(BOOL)animated; //选中下标

-(void)adjustItemWithAnimated:(BOOL)animated; //调整Item
- (void)adjustItemAnimate:(BOOL)animated; /// 调整Item

-(void)reloadView; //刷新视图
@end

NS_ASSUME_NONNULL_END
