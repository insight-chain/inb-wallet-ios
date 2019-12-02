//
//  UIViewController+BaceFunction.h
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/11/15.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (BaceFunction)

//发送日志
-(void)sendLogAddr:(NSString *)addr hashStr:(NSString *)hashStr dataStr:(NSString *)dataStr errStr:(NSString *)errStr;
//图片
-(void)saveImageFromView:(UIView *)view; //保存图片
-(UIImage *)imageFromView:(UIView *)view; //生成图片
-(UIImage *)screenShotWithScrollView:(UIScrollView *)scrollView;
- (void)saveImageToPhotos:(UIImage*)savedImage; //保存图片

@end

NS_ASSUME_NONNULL_END
