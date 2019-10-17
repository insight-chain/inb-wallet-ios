//
//  WelcomeVC.h
//  boluolicai
//
//  Created by 张松超 on 15/12/23.
//  Copyright © 2015年 Pusupanshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomeIndexVC : UIViewController

@property (nonatomic,copy) void (^guideFinishBlock)();//立即体验的点击事件

+ (BOOL)welcomeNeedsDisplay:(NSString *)version;
@end
