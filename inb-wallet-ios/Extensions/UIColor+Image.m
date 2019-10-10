//
//  UIColor+Image.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/9/30.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "UIColor+Image.h"

@implementation UIColor (Image)
-(UIImage *)asImageWithSize:(CGSize)size{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,self.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
