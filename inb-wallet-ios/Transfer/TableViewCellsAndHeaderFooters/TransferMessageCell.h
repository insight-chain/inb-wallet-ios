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

#define kRightBtnCopy 1
#define kRightBtnMore 2
typedef NS_ENUM(NSInteger, RightBtnType){
    btnType_copy = 1,
    btnType_more,
};

@interface TransferMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeName;
@property (weak, nonatomic) IBOutlet UILabel *value;

@property (nonatomic, assign) BOOL showRightBtn; //是否显示复制按钮
@property (nonatomic, assign) RightBtnType rightBtnType; //右侧按钮类型，1-复制，2-箭头
@property (nonatomic, assign) BOOL showSeperatorView; //显示分割线
@property (nonatomic, assign) BOOL canCopy; //是否可以复制
@end

NS_ASSUME_NONNULL_END
