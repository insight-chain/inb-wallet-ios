//
//  TransferMessage_2Cell.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/18.
//  Copyright © 2019 apple. All rights reserved.
//
/**
 * 
 */
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TransferMessage_2Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeName;
@property (weak, nonatomic) IBOutlet UILabel *valueName;
@property (weak, nonatomic) IBOutlet UILabel *value;

@end

NS_ASSUME_NONNULL_END
