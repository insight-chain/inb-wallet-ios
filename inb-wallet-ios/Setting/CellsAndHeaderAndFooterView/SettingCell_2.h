//
//  SettingCell_2.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/26.
//  Copyright © 2019 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SettingCell_2 : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
@property (weak, nonatomic) IBOutlet UILabel *title;

@property(nonatomic, assign) BOOL hideSeperator; //是否隐藏分割线

@end

NS_ASSUME_NONNULL_END
