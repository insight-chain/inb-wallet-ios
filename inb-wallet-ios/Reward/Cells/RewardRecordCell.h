//
//  RewardRecordCell.h
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/9/11.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransferModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RewardRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@property (nonatomic, strong) TransferModel *model;

@end

NS_ASSUME_NONNULL_END
