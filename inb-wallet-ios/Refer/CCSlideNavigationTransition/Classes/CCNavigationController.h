//
//  CCNavigationController.h
//  CCSlideNavigationTransition
//
//  Created by eson on 14-6-25.
//  Copyright (c) 2014年 eson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCNavigationController : UINavigationController

@property (nonatomic, assign) CGFloat previousSlideViewInitailOriginX;
@property (nonatomic, assign, getter = isSlidingPopEnable) BOOL slidingPopEnable;							  //Default YES
@property (nonatomic, assign, getter = isUseSystemAnimatedTransitioning) BOOL useSystemAnimatedTransitioning; //Default NO
@property (nonatomic, assign) BOOL edgePopGestureOnly;

+ (void)setCacheSnapshotImageInMemory:(BOOL)cacheSnapshotImageInMemory;

-(void)popViewControllerWithCenterButton:(UIButton*)button;


-(void)pushViewController:(UIViewController *)viewController withCenterButton:(UIButton*)button;


@end
