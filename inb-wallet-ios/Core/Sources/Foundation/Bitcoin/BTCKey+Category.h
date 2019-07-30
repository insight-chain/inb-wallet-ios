//
//  BTCKey+Category.h
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/6/28.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "BTCKey.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTCKey (Category)
-(BTCAddress *)addressOn:(Network)network segWit:(NSString *)segWit;
@end

NS_ASSUME_NONNULL_END
