//
//  SliderBar.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/12.
//  Copyright © 2019 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SliderBar : UIView

@property(nonatomic, copy) NSArray *itemsTitle;

@property(nonatomic, strong) UIColor *itemTitleColor;
@property(nonatomic, strong) UIColor *itemTitleSelectedColor;
@property(nonatomic, strong) UIFont  *itemTitleFont;
@property(nonatomic, strong) UIFont  *itemTitleSelectedFont;

@property(nonatomic, assign) NSInteger selectedIndex;
@property(nonatomic, copy) void(^itemClick)(NSInteger index);
@end

NS_ASSUME_NONNULL_END
