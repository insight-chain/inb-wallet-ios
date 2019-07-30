//
//  TransferListCell.h
//  test
//
//  Created by insightChain_iOS开发 on 2019/6/12.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TransferListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel; //转入、转出、投票。。
@property (weak, nonatomic) IBOutlet UILabel *valueLabel; //值
@property (weak, nonatomic) IBOutlet UILabel *timeLabel; //时间
@property (weak, nonatomic) IBOutlet UILabel *infoLabel; //备注信息


@end

NS_ASSUME_NONNULL_END
