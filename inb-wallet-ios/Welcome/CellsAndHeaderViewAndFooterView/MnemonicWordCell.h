//
//  MnemonicWordCell.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/29.
//  Copyright © 2019 apple. All rights reserved.
//
/**
 * 助记词cell
 */
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MnemonicWordCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *wordLabel;
@property (weak, nonatomic) IBOutlet UIImageView *deleteImg;

@end

NS_ASSUME_NONNULL_END
