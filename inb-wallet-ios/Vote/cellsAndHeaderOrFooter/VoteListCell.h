//
//  VoteListCell.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/19.
//  Copyright © 2019 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Node.h"

NS_ASSUME_NONNULL_BEGIN

@interface VoteListCell : UITableViewCell
@property(nonatomic, strong) Node *node;
@property(nonatomic, copy) void(^voteBlock)(Node *node);
@end

NS_ASSUME_NONNULL_END
