//
//  UpdateView.h
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/6/25.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UpdateView : UIView

+(void)showUpadate:(NSString *)version intro:(NSString *)intro updateBlock:(void(^)(void))updateBlock;

@end

NS_ASSUME_NONNULL_END
