//
//  VoteDetailCell.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/23.
//  Copyright © 2019 apple. All rights reserved.
//

#import "VoteDetailCell.h"
#import "SDWebImage.h"

@interface VoteDetailCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nodeTitle; //节点昵称
@property (weak, nonatomic) IBOutlet UILabel *nodeAddress; //节点地址

@end

@implementation VoteDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)setNode:(Node *)node{
    _node = node;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:node.image] placeholderImage:[UIImage imageNamed:@"headerImgDefault"]];
    self.nodeTitle.text = node.name;
    self.nodeAddress.text = node.address;
}

#pragma mark ---- Button Action
//删除节点
- (IBAction)deleteNodeAction:(UIButton *)sender {
    if (self.deleteBlock) {
        self.deleteBlock(self.node);
    }
}
@end
