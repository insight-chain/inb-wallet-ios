//
//  NSBundle+TZImagePicker.h
//  TZImagePickerController
//
//  Created by yuchao on 17/11/2.
//  Copyright © 2017年 yuchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSBundle (TZImagePicker)

+ (NSBundle *)tz_imagePickerBundle;

+ (NSString *)tz_localizedStringForKey:(NSString *)key value:(NSString *)value;
+ (NSString *)tz_localizedStringForKey:(NSString *)key;

@end

