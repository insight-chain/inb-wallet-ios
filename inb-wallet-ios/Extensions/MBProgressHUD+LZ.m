//
//  MBProgressHUD+LZ.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/6/18.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "MBProgressHUD+LZ.h"

@implementation MBProgressHUD (LZ)

+(void)showMessage:(NSString *)message toView:(UIView *)view afterDelay:(double)delay animted:(BOOL)animated{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:animated];
    hud.bezelView.backgroundColor = kColorWithRGBA(0, 0, 0, 0.65);
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    hud.label.textColor = [UIColor whiteColor];
    [hud setRemoveFromSuperViewOnHide:YES];
    [hud hideAnimated:animated afterDelay:delay];
    [view bringSubviewToFront:hud];
}

@end
