//
//  SettingCell.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/25.
//  Copyright © 2019 apple. All rights reserved.
//

#import "SettingCell.h"
@interface SettingCell()
@property (weak, nonatomic) IBOutlet UIView *seperatorView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *auciliaryImgWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLedaingImgConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightImgWidthConstraint; //右侧箭头宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subTitlerightPaddingConstraint;

@end

@implementation SettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.subTitle.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(copyAction)];
    [self.subTitle addGestureRecognizer:tap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

-(void)copyAction{
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    board.string = self.subTitle.text;
    [MBProgressHUD showMessage:NSLocalizedString(@"message.tip.copy.success", @"复制成功") toView:App_Delegate.window afterDelay:1 animted:YES];
}

-(void)setHideSubTitle:(BOOL)hideSubTitle{
    _hideSubTitle = hideSubTitle;
    if (_hideSubTitle) {
        self.subTitle.hidden = YES;
    }else{
        self.subTitle.hidden = NO;
    }
}
-(void)setHideSeperator:(BOOL)hideSeperator{
    _hideSeperator = hideSeperator;
    if (_hideSeperator) {
        self.seperatorView.hidden = YES;
    }else{
        self.seperatorView.hidden = NO;
    }
}
-(void)setHideAuxiliaryImg:(BOOL)hideAuxiliaryImg{
    _hideAuxiliaryImg = hideAuxiliaryImg;
    if (_hideAuxiliaryImg) {
        self.auciliaryImgWidthConstraint.constant = 0;
        self.titleLedaingImgConstraint.constant = 0;
    }else{
        self.auciliaryImgWidthConstraint.constant = 18;
        self.titleLedaingImgConstraint.constant = 10;
    }
}
-(void)setHideRightImg:(BOOL)hideRightImg{
    _hideRightImg = hideRightImg;
    if (_hideRightImg) {
        self.rightImgWidthConstraint.constant = 0;
        self.subTitlerightPaddingConstraint.constant = 0;
    }else{
        self.rightImgWidthConstraint.constant = 15;
        self.subTitlerightPaddingConstraint.constant = 5;
    }
}
@end
