//
//  RewardNoMortgageCell.h
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/10/30.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GoMortgage)(void);
NS_ASSUME_NONNULL_BEGIN

@interface RewardNoMortgageCell : UITableViewCell
@property (nonatomic, copy) GoMortgage goMortgage;
@end

NS_ASSUME_NONNULL_END
