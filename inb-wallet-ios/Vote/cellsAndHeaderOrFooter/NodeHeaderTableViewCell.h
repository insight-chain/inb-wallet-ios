//
//  NodeHeaderTableViewCell.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/6.
//  Copyright © 2019 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NodeHeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImg; //头像
@property (weak, nonatomic) IBOutlet UILabel *name;//节点名称
@property (weak, nonatomic) IBOutlet UILabel *address;//节点地址
@property (weak, nonatomic) IBOutlet UILabel *country;//国家
@property (weak, nonatomic) IBOutlet UILabel *website;//官方网址
@property (weak, nonatomic) IBOutlet UIButton *voteBtn;//投票按钮

@property (nonatomic, copy) void(^voteBlock)();

@end

NS_ASSUME_NONNULL_END
