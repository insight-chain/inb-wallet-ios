//
//  SuspendTopPauseBaseTableViewVC.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/10/17.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "SuspendTopPauseBaseTableViewVC.h"
#import "YNPageTableView.h"

#define kCellHeight 44
@interface SuspendTopPauseBaseTableViewVC ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation SuspendTopPauseBaseTableViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"id"];
    [self.view addSubview:self.tableView];
}


#pragma mark ---- UITableViewDelegate && Datasource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < 100) {
        return kCellHeight;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if (indexPath.row < 100) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ section: %zd row:%zd", @"测试", indexPath.section, indexPath.row];
        return cell;
    }
    return cell;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[YNPageTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
@end
