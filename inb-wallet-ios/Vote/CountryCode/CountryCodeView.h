//
//  CountryCodeView.h
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/9/19.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectCountry)(NSString * _Nullable countryName, NSString * _Nonnull countryCode);

NS_ASSUME_NONNULL_BEGIN

@interface CountryCodeView : UIView

@property (nonatomic, copy) SelectCountry selectCountry;

+(NSArray *)countryList;

@end

NS_ASSUME_NONNULL_END
