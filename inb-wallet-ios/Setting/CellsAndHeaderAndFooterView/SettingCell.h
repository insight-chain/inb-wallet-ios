//
//  SettingCell.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/25.
//  Copyright © 2019 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SettingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *auxiliaryImg; //左侧img
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subTitle; // "v1.0.0"

@property (nonatomic, assign) BOOL hideSubTitle;  //是否隐藏 右侧子标题
@property (nonatomic, assign) BOOL hideSeperator; //是否隐藏分割线
@property (nonatomic, assign) BOOL hideAuxiliaryImg; //是否隐藏 左侧图片
@property (nonatomic, assign) BOOL hideRightImg; //隐藏右侧箭头图片
@end

NS_ASSUME_NONNULL_END
