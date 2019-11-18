//
//  UIViewController+BaceFunction.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/11/15.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "UIViewController+BaceFunction.h"
#import "NetworkUtil.h"

@implementation UIViewController (BaceFunction)

-(void)sendLogAddr:(NSString *)addr hashStr:(NSString *)hashStr dataStr:(NSString *)dataStr errStr:(NSString *)errStr{
    NSDictionary *param;
    if(errStr && ![errStr isEqualToString:@""]){
        param = @{@"address":addr,@"error":errStr};
    }else{
        param = @{@"address":addr,
                  @"transHash":hashStr,
                  @"data":dataStr
        };
    }
    [NetworkUtil sendLogRrequestWithPatams:param success:^(id  _Nonnull resonseObject) {
        NSLog(@"resonseObject--%@", resonseObject);
    } failed:^(NSError * _Nonnull error) {
        NSLog(@"error----%@", error);
    }];
}

@end
