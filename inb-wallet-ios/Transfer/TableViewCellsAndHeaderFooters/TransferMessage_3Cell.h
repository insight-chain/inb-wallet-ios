//
//  TransferMessage_3Cell.h
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/10/10.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TransferMessage_3Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

NS_ASSUME_NONNULL_END
