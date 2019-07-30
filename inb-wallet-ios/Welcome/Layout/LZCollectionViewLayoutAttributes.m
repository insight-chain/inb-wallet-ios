//
//  LZCollectionViewLayoutAttributes.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/30.
//  Copyright © 2019 apple. All rights reserved.
//

#import "LZCollectionViewLayoutAttributes.h"

@implementation LZCollectionViewLayoutAttributes
+(instancetype)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind withIndexPath:(NSIndexPath *)indexPath{
    LZCollectionViewLayoutAttributes *layoutAttributes = [super layoutAttributesForDecorationViewOfKind:decorationViewKind withIndexPath:indexPath];
    UIImage *img = [UIImage imageNamed:@"sectionBg"];
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height/2.0, img.size.width/2.0, img.size.height/2.0, img.size.width/2.0) resizingMode:UIImageResizingModeStretch];
    layoutAttributes.bgImgView = [[UIImageView alloc] init];
    layoutAttributes.bgImgView.image = img;
    layoutAttributes.color = kColorBackground;
    
    return layoutAttributes;
}
-(id)copyWithZone:(NSZone *)zone{
    LZCollectionViewLayoutAttributes *newAttributes = [super copyWithZone:zone];
    newAttributes.color = [self.color copyWithZone:zone];
    return newAttributes;
}
@end
