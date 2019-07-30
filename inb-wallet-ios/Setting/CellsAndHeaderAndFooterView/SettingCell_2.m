//
//  SettingCell_2.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/26.
//  Copyright © 2019 apple. All rights reserved.
//

#import "SettingCell_2.h"
@interface SettingCell_2()
@property (weak, nonatomic) IBOutlet UIView *seperatorView;

@end

@implementation SettingCell_2

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)setHideSeperator:(BOOL)hideSeperator{
    _hideSeperator = hideSeperator;
    if (_hideSeperator) {
        self.seperatorView.hidden = YES;
    }else{
        self.seperatorView.hidden = NO;
    }
}

@end
