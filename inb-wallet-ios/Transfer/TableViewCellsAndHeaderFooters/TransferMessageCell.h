//
//  TransferMessageCell.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/18.
//  Copyright © 2019 apple. All rights reserved.
//
/**
 *  一般样式
 */
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TransferMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeName;
@property (weak, nonatomic) IBOutlet UILabel *value;

@property (nonatomic, assign) BOOL showRightBtn; //是否显示复制按钮
@property (nonatomic, assign) NSInteger rightBtnType; //右侧按钮类型，1-复制，2-箭头
@property (nonatomic, assign) BOOL showSeperatorView; //显示分割线

@end

NS_ASSUME_NONNULL_END
