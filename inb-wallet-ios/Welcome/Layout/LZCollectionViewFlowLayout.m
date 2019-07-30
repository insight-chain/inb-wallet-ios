//
//  LZCollectionViewFlowLayout.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/30.
//  Copyright © 2019 apple. All rights reserved.
//

#import "LZCollectionViewFlowLayout.h"
#import "LZCollectionViewLayoutAttributes.h"
#import "LZCollectionReusableView.h"

static NSString *kDecorationReuseIdentifier = @"section_bg";

@implementation LZCollectionViewFlowLayout

+(Class)layoutAttributesClass{
    return [LZCollectionViewLayoutAttributes class];
}
-(void)prepareLayout{
    [super prepareLayout];
    
    [self registerClass:[LZCollectionReusableView class] forDecorationViewOfKind:kDecorationReuseIdentifier];
}
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    
    NSMutableArray *allAttributes = [NSMutableArray arrayWithArray:attributes];
    
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        if (attribute.representedElementKind == UICollectionElementCategoryCell &&
            attribute.frame.origin.x == self.sectionInset.left) {
            LZCollectionViewLayoutAttributes *decorationAttributes = [LZCollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:kDecorationReuseIdentifier withIndexPath:attribute.indexPath];
            decorationAttributes.frame = CGRectMake(0, attribute.frame.origin.y-(self.sectionInset.top), self.collectionViewContentSize.width, self.itemSize.height+(self.minimumLineSpacing+self.sectionInset.top+self.sectionInset.bottom));
            decorationAttributes.zIndex = attribute.zIndex-1;
            [allAttributes addObject:decorationAttributes];
        }
    }
    
    return allAttributes;
}
@end
