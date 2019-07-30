//
//  LZCollectionReusableView.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/30.
//  Copyright © 2019 apple. All rights reserved.
//

#import "LZCollectionReusableView.h"
#import "LZCollectionViewLayoutAttributes.h"

@implementation LZCollectionReusableView
-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    [super applyLayoutAttributes:layoutAttributes];
    LZCollectionViewLayoutAttributes *lzLayoutAttributes = (LZCollectionViewLayoutAttributes *)layoutAttributes;
    [self addSubview:lzLayoutAttributes.bgImgView];
    [lzLayoutAttributes.bgImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    self.backgroundColor = lzLayoutAttributes.color;
}
@end
