//
//  RewardRecordVC.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/9/11.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "RewardRecordVC.h"

#import "RewardRecordCell.h"

#import "NetworkUtil.h"

static NSString *kCellId = @"rewardRecordCell";

@interface RewardRecordVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RewardRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestRecord];
}

-(void)requestRecord{
    NSString *url = [NSString stringWithFormat:@"%@transaction/award?address=%@", App_Delegate.explorerHost, App_Delegate.selectAddr];
    [NetworkUtil getRequest:url params:@{}
                    success:^(id  _Nonnull resonseObject) {
                        NSLog(@"%@", resonseObject);
                    } failed:^(NSError * _Nonnull error) {
                        NSLog(@"%@", error);
                    }];
}


#pragma mark ---- UITableViewDelegate && Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RewardRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:@"RewardRecordCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:kCellId];
        cell = [tableView dequeueReusableCellWithIdentifier:kCellId];
    }
    
    return cell;
}

@end
