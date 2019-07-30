//
//  MBProgressHUD+LZ.h
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/6/18.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBProgressHUD (LZ)

+(void)showMessage:(NSString *)message toView:(UIView *)view afterDelay:(double)delay animted:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
