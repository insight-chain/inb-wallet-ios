//
//  UIScrollView+PageExtend.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/9/5.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "UIScrollView+PageExtend.h"
#import <objc/runtime.h>

@implementation UIScrollView (PageExtend)

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceMethod:NSSelectorFromString(@"_notifyDidScroll") withMethod:@selector(yn_scrollViewDidScrollView)];
        [self swizzleInstanceMethod:NSSelectorFromString(@"_scrollViewWillBeginDragging") withMethod:@selector(yn_scrollViewWillBeginDragging)];
    });
}

-(void)yn_scrollViewDidScrollView{
    [self yn_scrollViewDidScrollView];
    if (self.observerDidScrollView && self.pageScrollViewDidScrollView) {
        self.pageScrollViewDidScrollView(self);
    }
}
-(void)yn_scrollViewWillBeginDragging{
    [self yn_scrollViewWillBeginDragging];
    if (self.observerDidScrollView && self.pageScrollViewBeginDragginScrollView) {
        self.pageScrollViewBeginDragginScrollView(self);
    }
}

#pragma mark ---- Getter - setter
-(BOOL)observerDidScrollView{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
-(void)setObserverDidScrollView:(BOOL)observerDidScrollView{
    objc_setAssociatedObject(self, @selector(observerDidScrollView), @(observerDidScrollView), OBJC_ASSOCIATION_ASSIGN);
}

-(PageScrollViewDidScrollView)pageScrollViewDidScrollView{
    return objc_getAssociatedObject(self, _cmd);
}
-(void)setPageScrollViewDidScrollView:(PageScrollViewDidScrollView)pageScrollViewDidScrollView{
    objc_setAssociatedObject(self, @selector(pageScrollViewDidScrollView), pageScrollViewDidScrollView, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(PageScrollViewBeginDraggingScrollView)pageScrollViewBeginDragginScrollView{
    return objc_getAssociatedObject(self, _cmd);
}
-(void)setPageScrollViewBeginDragginScrollView:(PageScrollViewBeginDraggingScrollView)pageScrollViewBeginDragginScrollView{
    objc_setAssociatedObject(self, @selector(pageScrollViewBeginDragginScrollView), pageScrollViewBeginDragginScrollView, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark ---- Swizzle
+(void)swizzleInstanceMethod:(SEL)origSelector withMethod:(SEL)newSelector{
    Class cls = [self class];
    Method originalMethod = class_getInstanceMethod(cls, origSelector);
    Method swizzledMethod = class_getInstanceMethod(cls, newSelector);
    
    if (class_addMethod(cls, origSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(cls, newSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        class_replaceMethod(cls, newSelector, class_replaceMethod(cls, origSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod)), method_getTypeEncoding(originalMethod));
    }
}

-(void)setContentOffsetY:(CGFloat)offsetY{
    if (self.contentOffset.y != offsetY) {
        self.contentOffset = CGPointMake(0, offsetY);
    }
}

@end
