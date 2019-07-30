//
//  VoteDetailCell.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/23.
//  Copyright © 2019 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Node.h"

NS_ASSUME_NONNULL_BEGIN

@interface VoteDetailCell : UITableViewCell
@property(nonatomic, strong) Node *node;

@property(nonatomic, copy) void(^deleteBlock)(Node *node);

@end

NS_ASSUME_NONNULL_END
