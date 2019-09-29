//
//  BaseTableViewVC.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/9/3.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "BaseTableViewVC.h"

@interface BaseTableViewVC ()

@end

@implementation BaseTableViewVC

-(instancetype)init{
    if(self = [super init]){
        
        [self.view addSubview:self.tableView];
        self.tableView.bounces = NO;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(YNPageTableView *)tableView{
    if(_tableView == nil){
        _tableView = [[YNPageTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        
    }
    return _tableView;
}
@end
