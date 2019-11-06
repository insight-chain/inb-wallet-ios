//
//  mortgageVC.h
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/9/2.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//
/**
 * 抵押
 */
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface mortgageVC : UIViewController

@property(nonatomic, copy) NSString *walletID;
@property(nonatomic, copy) NSString *address;
@property (nonatomic, assign) NSInteger lockingNumber; //正在锁仓的数量

@property(nonatomic, strong) UIButton *mortgageConfirmBtn; //抵押确认按钮

@property (nonatomic, strong) UITableView *tableView;

-(void)confirmMortgage;

@end




NS_ASSUME_NONNULL_END


