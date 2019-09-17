//
//  UIScrollView+PageExtend.h
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/9/5.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^PageScrollViewDidScrollView)(UIScrollView *scrollView);
typedef void(^PageScrollViewBeginDraggingScrollView)(UIScrollView *scrollView);

@interface UIScrollView (PageExtend)

@property (nonatomic, assign) BOOL observerDidScrollView;

@property (nonatomic, copy) PageScrollViewDidScrollView pageScrollViewDidScrollView;
@property (nonatomic, copy) PageScrollViewBeginDraggingScrollView pageScrollViewBeginDragginScrollView;

-(void)setContentOffsetY:(CGFloat)offsetY;

@end

NS_ASSUME_NONNULL_END
