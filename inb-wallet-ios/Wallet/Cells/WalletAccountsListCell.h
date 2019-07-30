//
//  WalletAccountsListCell.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/15.
//  Copyright © 2019 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WalletAccountsListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageHeaderView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImg;

@end

NS_ASSUME_NONNULL_END
