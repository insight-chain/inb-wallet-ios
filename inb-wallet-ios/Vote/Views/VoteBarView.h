//
//  VoteBarView.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/19.
//  Copyright © 2019 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Node.h"
NS_ASSUME_NONNULL_BEGIN

@interface VoteBarView : UIView
@property (strong, nonatomic) IBOutlet UIView *voteBarView;

@property (nonatomic, copy) void(^subVote)(void); //提交投票

@property (nonatomic, assign) NSInteger totalNodes;

@property (nonatomic, copy) void(^deleteNode)(Node *node);

-(void)addNode:(Node *)node;
-(void)deleteNode:(Node *)node;
-(void)reloadNodes:(NSArray *)selectedNodes;
@end

NS_ASSUME_NONNULL_END
