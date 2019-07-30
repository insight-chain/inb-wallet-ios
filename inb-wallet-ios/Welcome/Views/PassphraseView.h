//
//  PassphraseView.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/4.
//  Copyright © 2019 apple. All rights reserved.
//
/**
 * 助记词显示view
 */
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PassphraseView : UIView

@property(nonatomic, strong) NSArray *words;
@property(nonatomic, assign) BOOL isEditable; //是否可编辑
@property(nonatomic, assign) NSInteger lastNumber; //最后有值得一个item的index
@property(nonatomic, assign) NSInteger colunNumber;

@property(nonatomic, copy) void(^didDeleteItem)(NSString *item);

@property(nonatomic, strong) UICollectionView *collectionView;

-(void)deleteItem:(NSInteger) index;

@end

NS_ASSUME_NONNULL_END
