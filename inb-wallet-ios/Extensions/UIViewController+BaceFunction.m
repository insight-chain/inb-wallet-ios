//
//  UIViewController+BaceFunction.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/11/15.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "UIViewController+BaceFunction.h"

#import <CoreLocation/CoreLocation.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "FAGlobal.h"

#import "NetworkUtil.h"

@implementation UIViewController (BaceFunction)

-(void)sendLogAddr:(NSString *)addr hashStr:(NSString *)hashStr dataStr:(NSString *)dataStr errStr:(NSString *)errStr{
    NSDictionary *param;
    if(errStr && ![errStr isEqualToString:@""]){
        param = @{@"address":addr,@"error":errStr};
    }else{
        NSDictionary *dic = [NSDictionary dictionaryWithJsonString:dataStr];
        NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mutDic setObject:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forKey:@"deviceUuid"];
        NSString *userAgent = APP_USER_AGENT;
        [mutDic setObject:userAgent forKey:@"User-Agent"];
        [mutDic setObject:[FAGlobal getDeviceName] forKey:@"DeviceName"];
        param = @{@"address":addr,
                  @"transHash":hashStr,
                  @"data":[mutDic toJSONString]
        };
    }
    [NetworkUtil sendLogRrequestWithPatams:param success:^(id  _Nonnull resonseObject) {
        NSLog(@"resonseObject--%@", resonseObject);
    } failed:^(NSError * _Nonnull error) {
        NSLog(@"error----%@", error);
    }];
}

#pragma mark ---- 保存图片
-(void)saveImageFromView:(UIView *)view{
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [self saveImageToPhotos:[self imageFromView:view]];
    
    
}
-(UIImage *)imageFromView:(UIView *)view{
    CGSize s = view.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数。
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
//生成图片
- (UIImage *)screenShotWithScrollView:(UIScrollView *)scrollView
{
    UIImage* image;
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, YES, [UIScreen mainScreen].scale);
    {
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame = scrollView.frame;
        scrollView.contentOffset = CGPointZero;
        scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
        //        [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        for (UIView * subView in scrollView.subviews) {
            if(subView.frame.size.height != 0){
                [subView drawViewHierarchyInRect:subView.bounds afterScreenUpdates:YES];
            }
        }
        image = UIGraphicsGetImageFromCurrentImageContext();
        scrollView.contentOffset = savedContentOffset;
        scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    if (image != nil)
    {
        return image;
    }
    return nil;
}
//把UIImage保存到系统相册
- (void)saveImageToPhotos:(UIImage*)savedImage
{
    if(![self isCanUsePhotos]){
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        [MBProgressHUD showMessage:@"尚未打开相册权限，请前往设置" toView:[UIApplication sharedApplication].keyWindow afterDelay:1.5 animted:YES];
    }else{
        UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    if (error == nil) {
        [MBProgressHUD showMessage:NSLocalizedString(@"photo.save.success", @"保存图片成功") toView:[UIApplication sharedApplication].keyWindow afterDelay:1.5 animted:YES];
    }else{
        [MBProgressHUD showMessage:@"尚未打开相册权限，请前往设置" toView:[UIApplication sharedApplication].keyWindow afterDelay:1.5 animted:YES];
    }
    
}
//判断相册权限
- (BOOL)isCanUsePhotos {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        ALAuthorizationStatus author =[ALAssetsLibrary authorizationStatus];
        if (author == kCLAuthorizationStatusRestricted || author == kCLAuthorizationStatusDenied) {
            //无权限
            return NO;
        }
    }
    else {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusRestricted ||
            status == PHAuthorizationStatusDenied) {
            //无权限
            return NO;
        }
    }
    return YES;
}


@end
