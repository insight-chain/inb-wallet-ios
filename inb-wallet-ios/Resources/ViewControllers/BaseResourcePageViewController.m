//
//  ResourcePageViewController.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/9/2.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "BaseResourcePageViewController.h"
#import "UIScrollView+PageExtend.h"
#import "UIView+YNPageExtend.h"

#define menuHeight 44

@interface BaseResourcePageViewController ()<UIScrollViewDelegate, PageScrollMenuViewDelegate>


/// 标题数组 默认 缓存 key 为 title 可通过数据源代理 进行替换
@property (nonatomic, strong) NSMutableArray<NSString *> *titlesM;

@property(nonatomic, strong) UIScrollView *headerBgView; /// 一个HeaderView的背景View

@property (nonatomic, strong, readwrite) PageScrollView *bgScrollView;/// 背景ScrollView

@property (nonatomic, strong) PageScrollView *pageScrollView; /// 页面ScrollView


@property (nonatomic, strong) NSMutableDictionary *displayDictM;/// 展示控制器的字典
@property (nonatomic, strong) NSMutableDictionary *originInsetBottomDictM;/// 原始InsetBottom
@property (nonatomic, strong) NSMutableDictionary *cacheDictM;/// 字典控制器的缓存
@property (nonatomic, strong) NSMutableDictionary *scrollViewCacheDictionryM; /// 字典ScrollView的缓存

@property (nonatomic, strong) UIScrollView *currentScrollView; /// 当前显示的页面
@property (nonatomic, strong) UIViewController *currentViewController; /// 当前控制器

@property (nonatomic, assign) CGFloat lastPositionX; /// 上次偏移的位置
@property (nonatomic, assign) CGFloat insetTop; /// TableView距离顶部的偏移量

@property (nonatomic, assign) BOOL headerViewInTableView; /// 判断headerView是否在列表内

@property (nonatomic, assign) CGFloat headerViewOriginHeight; /// headerView的原始高度 用来处理头部伸缩效果
@property (nonatomic, assign) CGFloat scrollMenuViewOriginY; /// 菜单栏的初始OriginY


@property (nonatomic, assign) BOOL supendStatus; /// 是否是悬浮状态
@property (nonatomic, assign) CGFloat beginBgScrollOffsetY; ///记录bgScrollView Y偏移量
@property (nonatomic, assign) CGFloat beginCurrentScrollOffsetY; ///记录currentScrollView Y偏移量
@end

@implementation BaseResourcePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setupSubViews];
    [self setSelectedPageIndex:self.pageIndex];
    
}
#pragma mark ---- Initialize Method
+(instancetype)pageViewControllerWithControllers:(NSArray *)controllers titles:(NSArray *)titles{
    return [[self alloc] initPageViewControllerWithControllers:controllers titles:titles];
}
-(instancetype)initPageViewControllerWithControllers:(NSArray *)controllers titles:(NSArray *)titles{
    self = [super init];
    self.controllersM = controllers.mutableCopy;
    self.titlesM = titles.mutableCopy;
    
    self.displayDictM = @{}.mutableCopy;
    self.cacheDictM = @{}.mutableCopy;
    self.originInsetBottomDictM = @{}.mutableCopy;
    self.scrollViewCacheDictionryM = @{}.mutableCopy;
    
    /** View被导航栏遮挡问题的解决 **/
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
    return self;
}

/**
 *  当前PageScrollViewVC作为子控制器
 *  @param parentViewControler 父类控制器
 */
-(void)addSelfToParentViewController:(UIViewController *)parentViewControler{
    [self addChildViewControllerWithChildVC:self parentVC:parentViewControler];
}
/**
 * 从父类控制器里面移除自己（PageScrollViewVC）
 */
-(void)removeSelfViewController{
    [self removeViewControllerWithChildVC:self];
}
#pragma mark ---- 初始化 PageScrollMenu
-(void)initPagescrollMenuViewWithFrame:(CGRect)frame{
    PageScrollMenuView *scrollMenuView = [PageScrollMenuView pagescrollMenuViewWithFrame:frame
                                                                                  titles:self.titlesM
                                                                                delegate:self currentIndex:self.pageIndex];
    self.scrollMenuView = scrollMenuView;
    [self.bgScrollView addSubview:self.scrollMenuView];
}

#pragma mark ---- 初始化子控制器
-(void)initViewControllerWithIndex:(NSInteger)index{
    self.currentViewController = self.controllersM[index];
    
    self.pageIndex = index;
    NSString *title = [self titleWithIndex:index];
    if([self.displayDictM objectForKey:[self getKeyWithTitle:title]]){
        return;
    }
    
    UIViewController *cacheViewController = [self.cacheDictM objectForKey:[self getKeyWithTitle:title]];
    [self addViewControllerToParent:cacheViewController ? :self.controllersM[index] index:index];
}
/// 添加到父类控制器中
-(void)addViewControllerToParent:(UIViewController *)viewController index:(NSInteger)index{
    [self addChildViewController:self.controllersM[index]];
    
    viewController.view.frame = CGRectMake(KWIDTH*index, 0, self.pageScrollView.frame.size.width, self.pageScrollView.frame.size.height);
    [self.pageScrollView addSubview:viewController.view];
    
    NSString *title = [self titleWithIndex:index];
    [self.displayDictM setObject:viewController forKey:[self getKeyWithTitle:title]];
    
    UIScrollView *scrollView = self.currentScrollView;
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(pageViewController:heightForScrollViewAtIndex:)]) {
        CGFloat scrollViewHeight = [self.dataSource pageViewController:self heightForScrollViewAtIndex:index];
        scrollView.frame = CGRectMake(0, 0, viewController.view.frame.size.width, scrollViewHeight);
    }else{
        scrollView.frame = viewController.view.bounds;
    }
    
    [viewController didMoveToParentViewController:self];
    
    ///缓存控制器
    if(![self.cacheDictM objectForKey:[self getKeyWithTitle:title]]){
        [self.cacheDictM setObject:viewController forKey:[self getKeyWithTitle:title]];
    }
    
}

#pragma mark ----
//初始化子view
-(void)setupSubViews{
    [self setupHeaderBgView];
    [self setupPageScrollMenuView];
    [self setupPageScrollView];
}
//初始化pagescrollView
-(void)setupPageScrollView{
    CGFloat navHeight = kNavigationBarHeight;
    CGFloat tabHeight = 0; //kBottomBarHeight;
    CGFloat cutOutHeight = 0;
    CGFloat contentHeight = KHEIGHT - navHeight - tabHeight - cutOutHeight;
    self.bgScrollView.frame = CGRectMake(0, 0, KWIDTH, contentHeight);
    self.bgScrollView.contentSize = CGSizeMake(KWIDTH, contentHeight+self.headerBgView.yn_height-0);
    
    self.scrollMenuView.yn_y = self.headerBgView.yn_bottom;
    
    self.pageScrollView.frame = CGRectMake(0, self.scrollMenuView.yn_bottom, KWIDTH, contentHeight-menuHeight-0);
    self.pageScrollView.contentSize = CGSizeMake(KWIDTH*self.controllersM.count, self.pageScrollView.frame.size.height);
    
    [self.bgScrollView addSubview:self.pageScrollView];
    [self.view addSubview:self.bgScrollView];
    
}
// 初始化PageScrollView
-(void)setupPageScrollMenuView{
    [self initPagescrollMenuViewWithFrame:CGRectMake(0, 0, KWIDTH, menuHeight)];
}
///初始化北京headerView
-(void)setupHeaderBgView{
    self.headerBgView = [[UIScrollView alloc] initWithFrame:self.headerView.bounds];
    self.headerBgView.contentSize = CGSizeMake(KWIDTH, self.headerView.yn_height);
    [self.headerBgView addSubview:self.headerView];
    self.headerViewOriginHeight = self.headerBgView.frame.size.height;
    self.headerBgView.scrollEnabled = NO;
    
    _insetTop = self.headerBgView.yn_height + menuHeight; //+菜单默认高度
    
    _scrollMenuViewOriginY = _headerView.yn_height;
    
    if(YES){ //悬浮
        _insetTop = self.headerBgView.frame.size.height - 0;
        [self.bgScrollView addSubview:self.headerBgView];
    }
}

#pragma mark ---- Private Method

-(void)initData{
    [self checkParams];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _headerViewInTableView = YES;
}

///从父类控制器移除控制器
-(void)removeViewControllerWithChildVC:(UIViewController *)childVC key:(NSString *)key{
    [self removeViewControllerWithChildVC:childVC];
    [self.displayDictM removeObjectForKey:key];
    if (![self.cacheDictM objectForKey:key]) {
        [self.cacheDictM setObject:childVC forKey:key];
    }
}
///添加子控制器
-(void)addChildViewControllerWithChildVC:(UIViewController *)childVC parentVC:(UIViewController *)parentVC{
    [parentVC addChildViewController:childVC];
    [parentVC didMoveToParentViewController:childVC];
    [parentVC.view addSubview:childVC.view];
}

///移除缓存控制器
-(void)removeViewController{
    NSString *title = [self titleWithIndex:self.pageIndex];
    NSString *displayKey = [self getKeyWithTitle:title];
    for (NSString *key in self.displayDictM.allKeys) {
        if (![key isEqualToString:displayKey]) {
            [self removeViewControllerWithChildVC:self.displayDictM[key] key:key];
        }
    }
}

///子控制器移除自己
-(void)removeViewControllerWithChildVC:(UIViewController *)childVC{
    [childVC.view removeFromSuperview];
    [childVC willMoveToParentViewController:nil];
    [childVC removeFromParentViewController];
}
///检查参数
-(void)checkParams{
#if DEBUG
    NSAssert(self.controllersM.count != 0 || self.controllersM, @"ViewControllers count is 0 or nil");
    NSAssert(self.titlesM.count != 0 || self.titlesM, @"TitleArray count is 0 or nil");
    NSAssert(self.controllersM.count == self.titlesM.count, @"ViewControllers count is not equal titleArray");
#endif
    if (![self respondsToCustomCacheKey]) {
        BOOL isHasNotEqualTitle = YES;
        for (int i = 0; i < self.titlesM.count; i++) {
            for (int j = i+1; j<self.titlesM.count; j++) {
                if(i != j && [self.titlesM[i] isEqualToString:self.titlesM[j]]){
                    isHasNotEqualTitle = NO;
                    break;
                }
            }
        }
#if DEBUG
        NSAssert(isHasNotEqualTitle, @"TitleArray Not allow equal title.");
#endif
    }
}
-(BOOL)respondsToCustomCacheKey{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(pageViewController:customCacheKeyForIndex:)]) {
        return YES;
    }
    return NO;
}
///将headerView从view上放置tableView上
-(void)replaceHeaderViewFromView{
    
}
//将headerView从tableview上放置view上
-(void)replaceHeaderViewFromTableView{
    
}
#pragma mark ---- Public Method
-(void)setSelectedPageIndex:(NSInteger)pageIndex{
    if (self.cacheDictM.count > 0 && pageIndex == self.pageIndex) {
        return ;
    }
    if (pageIndex > self.controllersM.count - 1) {
        return;
    }
    CGRect frame = CGRectMake(CGRectGetWidth(self.pageScrollView.frame)*pageIndex, 0, CGRectGetWidth(self.pageScrollView.frame), CGRectGetHeight(self.pageScrollView.frame));
    if (frame.origin.x == self.pageScrollView.contentOffset.x) {
        [self scrollViewDidScroll:self.pageScrollView];
    }else{
        [self.pageScrollView scrollRectToVisible:frame animated:NO];
    }
    [self scrollViewDidEndDecelerating:self.pageScrollView];
}

-(void)reloadData{
    [self checkParams];
    
    self.pageIndex = self.pageIndex < 0 ? 0 : self.pageIndex;
    self.pageIndex = self.pageIndex >= self.controllersM.count ? self.controllersM.count - 1 : self.pageIndex;
    
    for (UIViewController *vc in self.displayDictM.allValues) {
        [self removeViewControllerWithChildVC:vc];
    }
    [self.displayDictM removeAllObjects];
    
    [self.originInsetBottomDictM removeAllObjects];
    [self.cacheDictM removeAllObjects];
    [self.scrollViewCacheDictionryM removeAllObjects];
    [self.headerBgView removeFromSuperview];
    [self.bgScrollView removeFromSuperview];
    [self.pageScrollView removeFromSuperview];
    
    [self.scrollMenuView removeFromSuperview];
    
    [self setupSubViews];
    
    [self setSelectedPageIndex:self.pageIndex];
}

/// 最终效果 current 拖到指定时 bg才能下拉，bg悬浮时 current才能上拉
/// 计算悬浮顶部偏移量 bgscrollView
-(void)calcuSuspendTopPauseWithBgScrollView:(UIScrollView *)scrollView{
    if(scrollView == self.bgScrollView){
        CGFloat bg_OffsetY = scrollView.contentOffset.y;
        CGFloat cu_OffsetY = self.currentScrollView.contentOffset.y;
        
        //求出拖拽方向
        BOOL dragBottom = _beginBgScrollOffsetY - bg_OffsetY > 0 ? YES : NO;
        /// cu大于0时
        if(dragBottom && cu_OffsetY > 0){
            ///设置原来的 出生偏移量
            [scrollView setContentOffsetY:_beginBgScrollOffsetY];
            ///设置实时滚动 cu 偏移量
            _beginCurrentScrollOffsetY = cu_OffsetY;
        }else if(_beginBgScrollOffsetY == _insetTop && _beginCurrentScrollOffsetY != 0){ //初始begin 时超过了 实时 设置
            [scrollView setContentOffsetY:_beginBgScrollOffsetY];
            _beginCurrentScrollOffsetY = cu_OffsetY;
        }else if(bg_OffsetY >= _insetTop){ //设置边界
            [scrollView setContentOffsetY:_insetTop];
            _beginCurrentScrollOffsetY = cu_OffsetY;
        }else if (bg_OffsetY <= 0 && cu_OffsetY > 0){ //设置边界
            [scrollView setContentOffsetY:0];
        }
    }
}
/// 计算悬浮顶部偏移量 - CurrentScrollView
- (void)calcuSuspendTopPauseWithCurrentScrollView:(UIScrollView *)scrollView {
    if (!scrollView.isDragging) return;
    
    CGFloat bg_OffsetY = self.bgScrollView.contentOffset.y;
    CGFloat cu_offsetY = scrollView.contentOffset.y;
    /// 求出拖拽方向
    BOOL dragBottom = _beginCurrentScrollOffsetY - cu_offsetY < 0 ? YES : NO;
    
    /// cu 是大于 0 的 且 bg 要小于 _insetTop
    if (dragBottom && cu_offsetY > 0 && bg_OffsetY < _insetTop) {
        ///设置之前的拖动位置
        [scrollView setContentOffsetY:_beginCurrentScrollOffsetY];
        ///修改bg原先偏移量
        _beginBgScrollOffsetY = bg_OffsetY;
    }else if(cu_offsetY < 0){
        ///cu 拖到 小于0 就设成0
        [scrollView setContentOffsetY:0];
    }else if (bg_OffsetY >= _insetTop){
        //bg 超过了 insetTop 就设置初始化为 _insetTop
        _beginBgScrollOffsetY = _insetTop;
    }
    
}

- (void)updateMenuItemTitle:(NSString *)title index:(NSInteger)index {
    if (index < 0 || index > self.titlesM.count - 1 ) return;
    if (title.length == 0) return;
    NSString *oldTitle = [self titleWithIndex:index];
    UIViewController *cacheVC = self.cacheDictM[[self getKeyWithTitle:oldTitle]];
    if (cacheVC) {
        NSString *newKey = [self getKeyWithTitle:title];
        NSString *oldKey = [self getKeyWithTitle:oldTitle];
        [self.cacheDictM setValue:cacheVC forKey:newKey];
        if (![newKey isEqualToString:oldKey]) {
            [self.cacheDictM setValue:nil forKey:oldKey];
        }
    }
    [self.titlesM replaceObjectAtIndex:index withObject:title];
    [self.scrollMenuView reloadView];
}
- (void)updateMenuItemTitles:(NSArray *)titles {
    if (titles.count != self.titlesM.count) return;
    for (int i = 0; i < titles.count; i++) {
        NSInteger index = i;
        NSString *title = titles[i];
        if (![title isKindOfClass:[NSString class]] || title.length == 0) return;
        NSString *oldTitle = [self titleWithIndex:index];
        UIViewController *cacheVC = self.cacheDictM[[self getKeyWithTitle:oldTitle]];
        if (cacheVC) {
            NSString *newKey = [self getKeyWithTitle:title];
            NSString *oldKey = [self getKeyWithTitle:oldTitle];
            [self.cacheDictM setValue:cacheVC forKey:newKey];
            if (![newKey isEqualToString:oldKey]) {
                [self.cacheDictM setValue:nil forKey:oldKey];
            }
        }
    }
    [self.titlesM replaceObjectsInRange:NSMakeRange(0, titles.count) withObjectsFromArray:titles];
    [self.scrollMenuView reloadView];
}

-(void)replaceTitlesArrayForSort:(NSArray *)titleArray{
    BOOL condition = YES;
    for (NSString *str in titleArray) {
        if(![self.titlesM containsObject:str]){
            condition = NO;
            break;
        }
    }
    if (!condition || titleArray.count != self.titlesM.count) return;
    
    NSMutableArray *resultArrayM = @[].mutableCopy;
    NSInteger currentPage = self.pageIndex;
    for (int i = 0; i < titleArray.count; i++) {
        NSString *title = titleArray[i];
        NSInteger oldIndex = [self.titlesM indexOfObject:title];
        /// 等于上次选择的页面 更换之后的页面
        if(currentPage == oldIndex){
            self.pageIndex = i;
        }
        [resultArrayM addObject:self.controllersM[oldIndex]];
    }
    [self.titlesM removeAllObjects];
    [self.titlesM addObjectsFromArray:titleArray];
    
    [self.controllersM removeAllObjects];
    [self.controllersM addObjectsFromArray:resultArrayM];
    
    [self updateViewWithIndex:self.pageIndex];
}
-(void)updateViewWithIndex:(NSInteger)pageIndex{
    self.pageScrollView.contentSize = CGSizeMake(KWIDTH * self.controllersM.count, self.pageScrollView.yn_height);
    
    UIViewController *vc = self.controllersM[pageIndex];
    
    vc.view.yn_x = KWIDTH * pageIndex;
    
    [self.scrollMenuView reloadView];
    [self.scrollMenuView selectedItemIndex:pageIndex animated:NO];
    
    CGRect frame = CGRectMake(self.pageScrollView.yn_width * pageIndex, 0, self.pageScrollView.yn_width, self.pageScrollView.yn_height);
    
    [self.pageScrollView scrollRectToVisible:frame animated:NO];
    
    [self scrollViewDidEndDecelerating:self.pageScrollView];
    
    self.pageIndex = pageIndex;
}
-(void)removePageControllerWithTitle:(NSString *)title{
    if([self respondsToCustomCacheKey]) return;
    NSInteger index = -1;
    for (NSInteger i = 0; i < self.titlesM.count; i++) {
        if ([self.titlesM[i] isEqualToString:title]) {
            index = i;
            break;
        }
    }
    if (index == -1) return;
    [self removePageControllerWithIndex:index];
}
- (void)removePageControllerWithIndex:(NSInteger)index {
    if (index < 0 || index >= self.titlesM.count || self.titlesM.count == 1) return;
    NSInteger pageIndex = 0;
    if (self.pageIndex >= index) {
        pageIndex = self.pageIndex - 1;
        if (pageIndex < 0) {
            pageIndex = 0;
        }
    }
    /// 等于 0 先选中 + 1个才能移除
    if (pageIndex == 0) {
        [self setSelectedPageIndex:1];
    }
    
    NSString *title = self.titlesM[index];
    [self.titlesM removeObject:self.titlesM[index]];
    [self.controllersM removeObject:self.controllersM[index]];
    
    NSString *key = [self getKeyWithTitle:title];
    
    [self.originInsetBottomDictM removeObjectForKey:key];
    [self.scrollViewCacheDictionryM removeObjectForKey:key];
    [self.cacheDictM removeObjectForKey:key];
    
    [self updateViewWithIndex:pageIndex];
}
-(void)reloadSuspendHeaderViewFrame{
    /// 重新初始化headerBgView
    [self setupHeaderBgView];
    [self setupPageScrollView];
}
-(void)scrollToTop:(BOOL)animated{
    [self.currentScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    [self.bgScrollView setContentOffset:CGPointMake(0, 0) animated:animated];
}
-(void)scrollToContentOffset:(CGPoint)point animated:(BOOL)animated{
    [self.currentScrollView setContentOffset:point animated:NO];
    [self.bgScrollView setContentOffset:point animated:animated];
}

#pragma mark ---- 样式取值
-(NSString *)titleWithIndex:(NSInteger)index{
    return self.titlesM[index];
}
-(NSInteger)getPageIndexWithTitle:(NSString *)title{
    return [self.titlesM indexOfObject:title];
}
-(NSString *)getKeyWithTitle:(NSString *)title{
    if([self respondsToCustomCacheKey]){
        NSString *ID = [self.dataSource pageViewController:self customCacheKeyForIndex:self.pageIndex];
        return ID;
    }
    return title;
}

#pragma mark ---- UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if(scrollView == self.bgScrollView){
        _beginBgScrollOffsetY = scrollView.contentOffset.y;
        _beginCurrentScrollOffsetY = self.currentScrollView.contentOffset.y;
    }else{
        self.currentScrollView.scrollEnabled = NO;
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView == self.bgScrollView) {
        return;
    }
    
    self.currentScrollView.scrollEnabled = YES;
}
///scrollView滚动结束
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.bgScrollView) {
        return;
    }
    
    self.currentScrollView.scrollEnabled = YES;
    
    [self replaceHeaderViewFromView];
    [self removeViewController];
    [self.scrollMenuView adjustItemPositionWithCurrentIndex:self.pageIndex];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageViewController:didEndDecelerating:)]) {
        [self.delegate pageViewController:self didEndDecelerating:scrollView];
    }
}

///scrollVie滚动ing
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.bgScrollView) {
        [self calcuSuspendTopPauseWithBgScrollView:scrollView];
        [self invokeDelegateForScrollWithOffsetY:scrollView.contentOffset.y];
        return;
    }
    
    CGFloat currentPostion = scrollView.contentOffset.x;
    CGFloat offsetX = currentPostion / KWIDTH;
    CGFloat offX = currentPostion > self.lastPositionX ? ceil(offsetX):offsetX;
    
    [self replaceHeaderViewFromTableView];
    [self initViewControllerWithIndex:offX];
    
    CGFloat progress = offsetX - (NSInteger)offsetX;
    self.lastPositionX = currentPostion;
    
    [self.scrollMenuView adjustItemWithProgress:progress lastIndex:floor(offsetX) currentIndex:ceil(offsetX)];
    if (floor(offsetX) == ceil(offsetX)) {
        [self.scrollMenuView adjustItemAnimate:YES];
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(pageViewController:didScroll:progress:fromIndex:toIndex:)]){
        [self.delegate pageViewController:self didScroll:scrollView progress:progress fromIndex:floor(offsetX) toIndex:ceil(offsetX)];
    }
}
#pragma mark ---- Invoke Delegate Metyhod
//回调监听列表滚动代理
-(void)invokeDelegateForScrollWithOffsetY:(CGFloat)offsetY{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageViewController:contentOffsetY:progress:)]) {
        
        CGFloat progress = offsetY / (self.headerView.frame.size.height);
        progress = progress > 1 ? 1 : progress;
        progress = progress < 0 ? 0 : progress;
        [self.delegate pageViewController:self contentOffsetY:offsetY progress:progress];
    }
}
#pragma mark ---- Lazy Method
-(PageScrollView *)bgScrollView{
    if (_bgScrollView == nil) {
        _bgScrollView = [[PageScrollView alloc] init];
        _bgScrollView.showsVerticalScrollIndicator = NO;
        _bgScrollView.showsHorizontalScrollIndicator = NO;
        _bgScrollView.delegate = self;
        _bgScrollView.backgroundColor = [UIColor whiteColor];
        if (@available(iOS 11.0, *)) {
            _bgScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _bgScrollView;
}
-(PageScrollView *)pageScrollView{
    if (!_pageScrollView) {
        _pageScrollView = [[PageScrollView alloc] init];
        _pageScrollView.showsVerticalScrollIndicator = NO;
        _pageScrollView.showsHorizontalScrollIndicator = NO;
        _pageScrollView.scrollEnabled = YES;
        _pageScrollView.pagingEnabled = YES;
        _pageScrollView.bounces = NO;
        _pageScrollView.delegate = self;
        _pageScrollView.backgroundColor = [UIColor whiteColor];
        if (@available(iOS 11.0, *)) {
            _pageScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _pageScrollView;
}
-(UIScrollView *)currentScrollView{ ///当前滚动的scrollView
    return [self getScrollViewWithPageIndex:self.pageIndex];
}
/// 根据pageIndex 取 数据源 ScrollView
-(UIScrollView *)getScrollViewWithPageIndex:(NSInteger)pageIndex{
    NSString *title = [self titleWithIndex:self.pageIndex];
    NSString *key = [self getKeyWithTitle:title];
    UIScrollView *scrollView = nil;
    
    if (![self.scrollViewCacheDictionryM objectForKey:key]) {
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(pageViewController:pageForIndex:)]) {
            scrollView = [self.dataSource pageViewController:self pageForIndex:pageIndex];
            scrollView.observerDidScrollView = YES;
            __weak typeof(self) weakSelf = self;
            scrollView.pageScrollViewDidScrollView = ^(UIScrollView * _Nonnull scrollView) {
                [weakSelf yn_pageScrollViewDidScrollView:scrollView];
            };
            scrollView.pageScrollViewBeginDragginScrollView = ^(UIScrollView * _Nonnull scrollView) {
                [weakSelf yn_pageScrollViewBeginDragginScrollView:scrollView];
            };
            
            if (@available(iOS 11.0, *)) {
                if (scrollView) {
                    scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
                }
            }
        }
    }else{
        return [self.scrollViewCacheDictionryM objectForKey:key];
    }
    
#if DEBUG
    NSAssert(scrollView != nil, @"请设置pageViewController 的数据源！");
#endif
    [self.scrollViewCacheDictionryM setObject:scrollView forKey:key];
    return scrollView;
    
}

-(void)setHeaderView:(UIView *)headerView{
    _headerView = headerView;
    _headerView.yn_height = ceil(headerView.yn_height);
}

#pragma mark ---- yn_pageScrollViewBeginDragginScrollView
- (void)yn_pageScrollViewBeginDragginScrollView:(UIScrollView *)scrollView {
    _beginBgScrollOffsetY = self.bgScrollView.contentOffset.y;
    _beginCurrentScrollOffsetY = scrollView.contentOffset.y;
}
#pragma mark - yn_pageScrollViewDidScrollView
- (void)yn_pageScrollViewDidScrollView:(UIScrollView *)scrollView {
    
    [self calcuSuspendTopPauseWithCurrentScrollView:scrollView];
   
}

#pragma mark ---- PageScrollMenuViewDelegate
-(void)pagescrollMenuViewItemOnClick:(UIButton *)button index:(NSInteger)index{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageViewController:didScrollMenuItem:index:)]) {
        [self.delegate pageViewController:self didScrollMenuItem:button index:index];
    }
    [self setSelectedPageIndex:index];
}

@end
