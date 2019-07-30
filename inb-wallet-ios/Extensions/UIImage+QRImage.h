//
//  UIImage+QRImage.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/19.
//  Copyright © 2019 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (QRImage)

+(UIImage *)createQRImgae:(NSString *)string size:(CGFloat)size centerImg:(UIImage *)centerImg centerImgSize:(CGFloat)centerSize;

@end

NS_ASSUME_NONNULL_END
