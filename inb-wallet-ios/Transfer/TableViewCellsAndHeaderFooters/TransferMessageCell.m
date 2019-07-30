//
//  TransferMessageCell.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/18.
//  Copyright © 2019 apple. All rights reserved.
//

#import "TransferMessageCell.h"

#define kRightBtnCopy 1
#define kRightBtnMore 2

@interface TransferMessageCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnCopyWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightMarginConstraint;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIView *seperatorView;
@end
@implementation TransferMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.btnCopyWidthConstraint.constant = 0;
    self.rightMarginConstraint.constant = 0;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setShowRightBtn:(BOOL)showRightBtn{
    _showRightBtn = showRightBtn;
    if (_showRightBtn) {
        self.btnCopyWidthConstraint.constant = 15;
        self.rightMarginConstraint.constant = 5;
    }else{
        self.btnCopyWidthConstraint.constant = 0;
        self.rightMarginConstraint.constant = 0;
    }
}
-(void)setRightBtnType:(NSInteger)rightBtnType{
    _rightBtnType = rightBtnType;
    if (_rightBtnType == kRightBtnCopy) {
        [self.rightBtn setImage:[UIImage imageNamed:@"copy"] forState:UIControlStateNormal];
    }else{
        [self.rightBtn setImage:[UIImage imageNamed:@"more_arrow"] forState:UIControlStateNormal];
    }
}
-(void)setShowSeperatorView:(BOOL)showSeperatorView{
    _showSeperatorView = showSeperatorView;
    if (_showSeperatorView) {
        self.seperatorView.hidden = NO;
    }else{
        self.seperatorView.hidden = YES;
    }
}
#pragma mark ---- Action
- (IBAction)copyBtnAction:(UIButton *)sender {
    if(self.rightBtnType == 1){ //复制
        
    }
}

@end
