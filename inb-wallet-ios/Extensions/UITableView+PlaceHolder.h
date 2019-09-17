//
//  UITableView+PlaceHolder.h
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/8/13.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TableViewPlaceHolderDelegate <NSObject>
@required
/**
 * 无数据占位图
 * @return 占位图
 */
-(UIView *)makePlaceHolderView;

@optional
/**
 * 出现占位图的时候TableView是否能拖动
 */
-(BOOL)enableScrollWhenPlaceHolderViewShowing;

@end

@interface UITableView (PlaceHolder)

-(void)d_reloadData;

@end

NS_ASSUME_NONNULL_END
