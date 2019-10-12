//
//  UIButton+Layout.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/2.
//  Copyright © 2019 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Layout)

-(void)topImgbelowTitle:(CGFloat)offset; //上图下文
-(void)leftImgRightTitle:(CGFloat)offset;//左图又文
-(void)rightImgleftTitle:(CGFloat)offset; //左文右图
@end

NS_ASSUME_NONNULL_END
