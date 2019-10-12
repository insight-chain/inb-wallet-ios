//
//  UIButton+Layout.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/2.
//  Copyright © 2019 apple. All rights reserved.
//

#import "UIButton+Layout.h"

@implementation UIButton (Layout)
-(void)topImgbelowTitle:(CGFloat)offset{
    [self layoutIfNeeded];
    
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.titleEdgeInsets = UIEdgeInsetsMake(self.imageView.frame.size.height+offset, -self.imageView.frame.size.width, -offset, 0);
    self.imageEdgeInsets = UIEdgeInsetsMake(-self.titleLabel.intrinsicContentSize.height-offset, 0, offset, - self.titleLabel.intrinsicContentSize.width);
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}
-(void)leftImgRightTitle:(CGFloat)offset{
    [self layoutIfNeeded];
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.titleEdgeInsets = UIEdgeInsetsMake(0, offset, 0, -offset);
    self.imageEdgeInsets = UIEdgeInsetsMake(0, -offset, 0, offset);
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}
-(void)rightImgleftTitle:(CGFloat)offset{
    [self layoutIfNeeded];
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -(self.imageView.frame.size.width-offset), 0, self.imageView.frame.size.width-offset);
    self.imageEdgeInsets = UIEdgeInsetsMake(0, self.titleLabel.intrinsicContentSize.width+offset, 0, -(self.titleLabel.intrinsicContentSize.width+offset));
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}
@end
