//
//  MyNodeInfoVC.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/10/21.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "MyNodeInfoVC.h"

@interface MyNodeInfoVC ()
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *icon_img; //节点头像
@property (nonatomic, strong) UILabel *nameL; //节点昵称

@property (nonatomic, strong) UIImageView *bg_img_1;

@property (nonatomic, strong) UIImageView *bg_img_2;

@end

@implementation MyNodeInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.scrollView];
    
}
#pragma mark ---- setter && getter
-(UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.backgroundColor = kColorBackground;
    }
    return _scrollView;
}
@end
