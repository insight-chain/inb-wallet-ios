//
//  PageScrollMenuView.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/9/4.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "PageScrollMenuView.h"

#define kPageScrollMenuViewConverMarginX 5
#define kPageScrollMenuViewConverMarginW 10

#define itemLeftAndRightMargin 15 /** 选项左边或者右边间隙 15 */
#define itemMargin 65 /** 选项相邻间隙 15 */

@interface PageScrollMenuView()

@property (nonatomic, strong) UIView *lineView; //line指示器
@property (nonatomic, strong) UIView *converView; //蒙层

@property (nonatomic, strong) UIScrollView *scrollView; /// ScrollView

@property (nonatomic, strong) UIView *bottomLine; ///底部线条
@property (nonatomic, weak) id<PageScrollMenuViewDelegate> delegate; //代理

@property (nonatomic, assign) NSInteger lastIndex; //上次index
@property (nonatomic, assign) NSInteger currentIndex;//当前index

@property (nonatomic, strong) NSMutableArray<UIButton *> *itemsArrayM; //items
@property (nonatomic, strong) NSMutableArray *itemsWidthArrayM; //item宽度

@end

@implementation PageScrollMenuView
+(instancetype)pagescrollMenuViewWithFrame:(CGRect)frame titles:(NSMutableArray *)titles delegate:(id<PageScrollMenuViewDelegate>)delegate currentIndex:(NSInteger)currentIndex{
    
    PageScrollMenuView *menuView = [[PageScrollMenuView alloc] initWithFrame:frame];
    menuView.titles = titles;
    menuView.delegate = delegate;
    menuView.currentIndex = currentIndex;
    
    menuView.itemsArrayM = @[].mutableCopy;
    menuView.itemsWidthArrayM = @[].mutableCopy;
    
    [menuView setupSubViews];
    
    return menuView;
}

#pragma  mark ---- Private Method
-(void)setupSubViews{
    [self setupItems];
    [self setupOtherViews];
}
-(void)setupItems{
    [self.titles enumerateObjectsUsingBlock:^(id  _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self setupButton:itemButton title:title idx:idx];
    }];
}

-(void)setupButton:(UIButton *)itemButton title:(NSString *)title idx:(NSInteger)idx{
    itemButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [itemButton setTitleColor:kColorLightBlue forState:UIControlStateNormal];
    [itemButton setTitle:title forState:UIControlStateNormal];
    itemButton.tag = idx;
    [itemButton addTarget:self action:@selector(itemButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [itemButton sizeToFit];
    [self.itemsWidthArrayM addObject:@(itemButton.frame.size.width)];
    [self.itemsArrayM addObject:itemButton];
    [self.scrollView addSubview:itemButton];
}

-(void)setupOtherViews{
    self.scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:self.scrollView];
    /// item
    __block CGFloat itemX = 0;
    __block CGFloat itemY = 0;
    __block CGFloat itemW = 0;
    __block CGFloat itemH = self.frame.size.height;
    
    [self.itemsArrayM enumerateObjectsUsingBlock:^(UIButton * _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            itemX += itemLeftAndRightMargin; //距离最左边的间隙
        }else{
            itemX += itemMargin + [self.itemsWidthArrayM[idx-1] floatValue];
        }
        button.frame = CGRectMake(itemX, itemY, [self.itemsWidthArrayM[idx] floatValue], itemH);
    }];
    
    CGFloat scrollSizeWidht = itemLeftAndRightMargin + CGRectGetMaxX([[self.itemsArrayM lastObject] frame]);
    if (scrollSizeWidht < self.scrollView.frame.size.width) { //不超过宽度
        itemX = 0;
        itemY = 0;
        itemW = 0;
        CGFloat left = 0;
        for (NSNumber *width in self.itemsWidthArrayM) {
            left += [width floatValue];
        }
        left = (self.scrollView.frame.size.width - left - itemMargin*(self.itemsWidthArrayM.count-1))*0.5;
        //居中且有剩余空间
        if(left >= 0){
            [self.itemsArrayM enumerateObjectsUsingBlock:^(UIButton * _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx == 0) {
                    itemX += left;
                }else{
                    itemX += itemMargin+[self.itemsWidthArrayM[idx-1] floatValue];
                }
                button.frame = CGRectMake(itemX, itemY, [self.itemsWidthArrayM[idx] floatValue], itemH);
            }];
            self.scrollView.contentSize = CGSizeMake(left+CGRectGetMaxX([[self.itemsArrayM lastObject] frame]), self.scrollView.frame.size.height);
        }else{
            self.scrollView.contentSize = CGSizeMake(scrollSizeWidht, self.scrollView.frame.size.height);
        }
    }else{
        ///大于scrollView的width
        self.scrollView.contentSize = CGSizeMake(scrollSizeWidht, self.scrollView.frame.size.height);
    }
    
    CGFloat lineX = ((UIButton *)[self.itemsArrayM firstObject]).frame.origin.x;
    CGFloat lineY = self.scrollView.frame.size.height - 1; //
    CGFloat lineW = [self.itemsArrayM firstObject].frame.size.width;
    CGFloat lineH = 1;
    
    ///处理Line宽度等于字体宽度
    lineX = self.itemsArrayM.firstObject.frame.origin.x + (self.itemsArrayM.firstObject.frame.size.width - ([self.itemsWidthArrayM.firstObject floatValue]))/2.0;
    lineW = [self.itemsWidthArrayM.firstObject floatValue];
    
    self.lineView.frame = CGRectMake(lineX, lineY, lineW, lineH);
    self.lineView.layer.cornerRadius = lineH/2.0;
    [self.scrollView addSubview:self.lineView];
    
    [self setDefaultTheme];
    [self selectedItemIndex:self.currentIndex animated:NO];
}

-(void)setDefaultTheme{
    UIButton *currentButton = self.itemsArrayM[self.currentIndex];
    
    ///颜色
    currentButton.selected = YES;
    [currentButton setTitleColor:kColorBlue forState:UIControlStateNormal];
    currentButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    
    //线条
    CGRect lineViewFrame = self.lineView.frame;
    lineViewFrame.origin.x = currentButton.frame.origin.x;
    lineViewFrame.size.width = currentButton.frame.size.width;
    self.lineView.frame = lineViewFrame;
    
    self.lastIndex = self.currentIndex;
    
}
-(void)adjustItemAnimate:(BOOL)animated{
    UIButton *lastButton = self.itemsArrayM[self.lastIndex];
    UIButton *currentButton = self.itemsArrayM[self.currentIndex];
    [UIView animateWithDuration:animated?0.3:0 animations:^{
        [self.itemsArrayM enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.selected = NO;
            [obj setTitleColor:kColorTitle forState:UIControlStateNormal];
            obj.titleLabel.font = [UIFont systemFontOfSize:15];
            if (idx == self.itemsArrayM.count - 1) {
                currentButton.selected = YES;
                [currentButton setTitleColor:kColorBlue forState:UIControlStateNormal];
                currentButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            }
        }];
        
        //线条
        CGRect lineViewFrame = self.lineView.frame;
        lineViewFrame.origin.x = currentButton.frame.origin.x;
        lineViewFrame.size.width = currentButton.frame.size.width;
        self.lineView.frame = lineViewFrame;
        
        self.lastIndex = self.currentIndex;
    } completion:^(BOOL finished) {
        [self adjustItemPositionWithCurrentIndex:self.currentIndex];
    }];
}
#pragma mark ---- Public Method

-(void)adjustItemPositionWithCurrentIndex:(NSInteger)index{
    if(self.scrollView.contentSize.width != self.scrollView.frame.size.width + 20){
        UIButton *button = self.itemsArrayM[index];
        CGFloat offSex = button.center.x - self.scrollView.frame.size.width * 0.5;
        offSex = offSex > 0 ? offSex : 0;
        CGFloat maxOffSetX = self.scrollView.contentSize.width - self.scrollView.frame.size.width;
        maxOffSetX = maxOffSetX > 0 ? maxOffSetX : 0;
        
        offSex = offSex > maxOffSetX ? maxOffSetX : offSex;
        [self.scrollView setContentOffset:CGPointMake(offSex, 0) animated:YES];
    }
}
-(void)adjustItemWithProgress:(CGFloat)progress lastIndex:(NSInteger)lastIndex currentIndex:(NSInteger)currentIndex{
    self.lastIndex = lastIndex;
    self.currentIndex = currentIndex;
    
    if(lastIndex == currentIndex) return;
    
    UIButton *lastButton = self.itemsArrayM[self.lastIndex];
    UIButton *currentButton = self.itemsArrayM[self.currentIndex];
    
    if (progress > 0.5) {
        lastButton.selected = NO;
        currentButton.selected = YES;
        [lastButton setTitleColor:kColorTitle forState:UIControlStateNormal];
        [currentButton setTitleColor:kColorBlue forState:UIControlStateNormal];
        currentButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    }else if(progress < 0.5 && progress > 0){
        lastButton.selected = YES;
        [lastButton setTitleColor:kColorBlue forState:UIControlStateNormal];
        lastButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        
        currentButton.selected = NO;
        [currentButton setTitleColor:kColorTitle forState:UIControlStateNormal];
        currentButton.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    
    if(progress > 0.5){
        lastButton.titleLabel.font = [UIFont systemFontOfSize:15];
        currentButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    }else if (progress < 0.5 && progress > 0){
        lastButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        currentButton.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    
    CGFloat xD = 0;
    CGFloat wD = 0;
    xD = currentButton.titleLabel.frame.origin.x + currentButton.frame.origin.x -( lastButton.titleLabel.frame.origin.x + lastButton.frame.origin.x );
    wD = currentButton.titleLabel.frame.size.width - lastButton.titleLabel.frame.size.width;
    
    CGRect lineViewFrame = self.lineView.frame;
    lineViewFrame.origin.x = lastButton.frame.origin.x + (CGRectGetWidth(lastButton.frame)  - ([self.itemsWidthArrayM[lastButton.tag] floatValue])) / 2 - 0 + xD *progress;
    
    lineViewFrame.size.width = [self.itemsWidthArrayM[lastButton.tag] floatValue] + 0 *2 + wD *progress;
}

-(void)selectedItemIndex:(NSInteger)index animated:(BOOL)animated{
    self.currentIndex = index;
    [self adjustItemAnimate:animated];
}
-(void)adjustItemWithAnimated:(BOOL)animated{
    if (self.lastIndex == self.currentIndex) {
        return;
    }
    [self adjustItemAnimate:animated];
}

#pragma mark ---- Lazy Method
-(UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = kColorBlue;
    }
    return _lineView;
}
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = NO;
        _scrollView.bounces = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollEnabled = NO;
    }
    return _scrollView;
}
#pragma mark ---- itemButtonTapOnClick
-(void)itemButtonOnClick:(UIButton *)button{
    self.currentIndex = button.tag;
    [self adjustItemWithAnimated:YES];
    if(self.delegate && [self.delegate respondsToSelector:@selector(pagescrollMenuViewItemOnClick:index:)]){
        [self.delegate pagescrollMenuViewItemOnClick:button index:self.lastIndex];
    }
}

-(void)reloadView{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    [self.itemsArrayM removeAllObjects];
    [self.itemsWidthArrayM removeAllObjects];
    [self setupSubViews];
}
@end
