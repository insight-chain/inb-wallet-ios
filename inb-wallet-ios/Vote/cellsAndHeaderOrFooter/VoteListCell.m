//
//  VoteListCell.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/19.
//  Copyright © 2019 apple. All rights reserved.
//

#import "VoteListCell.h"
#import "SDWebImage.h"

@interface VoteListCell()
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addresslabel;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (weak, nonatomic) IBOutlet UILabel *correctRatioLable;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIButton *voteBtn;

@property (weak, nonatomic) IBOutlet UILabel *voteLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectBox;


@end

@implementation VoteListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    /** 设置圆角：此方法在iOS9之后优化了，不会发生离屛渲染了；但是ios9之前有离屛渲染**/
    self.headerImage.layer.cornerRadius = self.headerImage.frame.size.width/2.0;
    self.headerImage.layer.masksToBounds = YES; //将多余部分切掉
//    /** 设置圆角：使用贝塞尔曲线UIBezierPath和Core Graphics框架画出一个圆角 **/
//    UIGraphicsBeginImageContextWithOptions(self.headerImage.bounds.size, NO, 1.0);
//    [[UIBezierPath bezierPathWithRoundedRect:self.headerImage.bounds cornerRadius:self.imageView.frame.size.width] addClip]; //使用贝塞尔曲线画出一个圆形图
//    [self.headerImage drawRect:self.headerImage.bounds];
//    self.headerImage.image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext(); //结束绘画
//
//    /** 设置圆角：使用CAShapeLayer和UIBezierPath设置圆角 **/
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.headerImage.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:self.headerImage.bounds.size];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
//    maskLayer.frame = self.headerImage.bounds; //设置大小
//    maskLayer.path = maskPath.CGPath; //设置图形样子
//    self.headerImage.layer.mask = maskLayer;
    
    self.voteLabel.text = NSLocalizedString(@"vote", @"投票");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


-(void)setNode:(Node *)node{
    _node = node;
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:node.image] placeholderImage:[UIImage imageNamed:@"headerImgDefault"]];
    self.nameLabel.text = node.name;
    self.addresslabel.text = node.address;
    self.introLabel.text = node.intro;
    self.correctRatioLable.text = [NSString stringWithFormat:@"%@%.2f%%", NSLocalizedString(@"vote.support", @"支持率"), node.voteRatio*100];
    self.voteBtn.selected = node.isVoted ? YES : NO;
    self.locationLabel.text = node.city;
    if (self.voteBtn.selected) {
        self.selectBox.image = [UIImage imageNamed:@"selectBox_yes"];
    }else{
        self.selectBox.image = [UIImage imageNamed:@"selectBox_no"];
    }
}

#pragma mark ---- Action
//投票
- (IBAction)voteAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.selectBox.image = [UIImage imageNamed:@"selectBox_yes"];
    }else{
        self.selectBox.image = [UIImage imageNamed:@"selectBox_no"];
    }
    self.node.isVoted = sender.selected;
    if(self.voteBlock){
        self.voteBlock(self.node);
    }
}
@end
