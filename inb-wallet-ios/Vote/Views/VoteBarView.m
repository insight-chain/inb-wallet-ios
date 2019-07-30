//
//  VoteBarView.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/19.
//  Copyright © 2019 apple. All rights reserved.
//

#import "VoteBarView.h"

#import "VoteDetailCell.h"

#import "SDWebImage.h"

#define cellId @"VoteDetailCell"

@interface VoteBarView()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *nodeLabel;//”以选节点 3/16“
@property (weak, nonatomic) IBOutlet UIImageView *imgView_1;
@property (weak, nonatomic) IBOutlet UIImageView *imgView_2;
@property (weak, nonatomic) IBOutlet UIImageView *imgView_3;
@property (weak, nonatomic) IBOutlet UIImageView *imgView_4;
@property (weak, nonatomic) IBOutlet UIButton *voteBtn;

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSMutableArray *selectedNodes;

@end

@implementation VoteBarView
-(instancetype)init{
    if (self = [super init]) {
        [self loadNibFile];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self loadNibFile];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self loadNibFile];
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    _voteBarView.frame = self.bounds;
}

-(void)loadNibFile{
    [[NSBundle mainBundle] loadNibNamed:@"VoteBarView" owner:self options:nil];
    [self addSubview:_voteBarView];
    [self.voteBtn setTitle:NSLocalizedString(@"submitVote", @"提交投票") forState:UIControlStateNormal];
    [self reload];
}

-(void)reloadNodes:(NSArray *)selectedNodes{
    [self.selectedNodes removeAllObjects];
    [self.selectedNodes addObjectsFromArray:selectedNodes];
    [self reload];
}

-(void)reload{
    self.nodeLabel.text = [NSString stringWithFormat:@"%@:%lu/%ld", NSLocalizedString(@"selectedNodes", @"已选节点"), (unsigned long)self.selectedNodes.count, (long)self.totalNodes];
    int coun = (int)MIN(self.selectedNodes.count, 4);
    switch (coun) {
        case 0:{
            self.imgView_1.image = nil;
            self.imgView_2.image = nil;
            self.imgView_3.image = nil;
            self.imgView_4.image = nil;
            break;
        }
        case 1:{
            Node *node = self.selectedNodes[0];
            [self.imgView_1 sd_setImageWithURL:[NSURL URLWithString:node.image] placeholderImage:[UIImage imageNamed:@"headerImgDefault"]];
            self.imgView_2.image = nil;
            self.imgView_3.image = nil;
            self.imgView_4.image = nil;
            break;
        }
        case 2:{
            Node *node1 = self.selectedNodes[0];
            Node *node2 = self.selectedNodes[1];
            [self.imgView_1 sd_setImageWithURL:[NSURL URLWithString:node1.image] placeholderImage:[UIImage imageNamed:@"headerImgDefault"]];
            [self.imgView_2 sd_setImageWithURL:[NSURL URLWithString:node2.image] placeholderImage:[UIImage imageNamed:@"headerImgDefault"]];
            self.imgView_3.image = nil;
            self.imgView_4.image = nil;
            break;
        }
        case 3:{
            Node *node1 = self.selectedNodes[0];
            Node *node2 = self.selectedNodes[1];
            Node *node3 = self.selectedNodes[2];
            [self.imgView_1 sd_setImageWithURL:[NSURL URLWithString:node1.image] placeholderImage:[UIImage imageNamed:@"headerImgDefault"]];
            [self.imgView_2 sd_setImageWithURL:[NSURL URLWithString:node2.image] placeholderImage:[UIImage imageNamed:@"headerImgDefault"]];
            [self.imgView_3 sd_setImageWithURL:[NSURL URLWithString:node3.image] placeholderImage:[UIImage imageNamed:@"headerImgDefault"]];
            self.imgView_4.image = nil;
            break;
        }
        case 4:{
            Node *node1 = self.selectedNodes[0];
            Node *node2 = self.selectedNodes[1];
            Node *node3 = self.selectedNodes[2];
            Node *node4 = self.selectedNodes[3];
            [self.imgView_1 sd_setImageWithURL:[NSURL URLWithString:node1.image] placeholderImage:[UIImage imageNamed:@"headerImgDefault"]];
            [self.imgView_2 sd_setImageWithURL:[NSURL URLWithString:node2.image] placeholderImage:[UIImage imageNamed:@"headerImgDefault"]];
            [self.imgView_3 sd_setImageWithURL:[NSURL URLWithString:node3.image] placeholderImage:[UIImage imageNamed:@"headerImgDefault"]];
            [self.imgView_4 sd_setImageWithURL:[NSURL URLWithString:node4.image] placeholderImage:[UIImage imageNamed:@"headerImgDefault"]];
            break;
        }
    }
    [self.tableView reloadData];
}

#pragma mark ---
-(void)addNode:(Node *)node{
    if (![self.selectedNodes containsObject:node]) {
        [self.selectedNodes addObject:node];
        [self reload];
    }
}
-(void)deleteNode:(Node *)node{
    node.isVoted = NO;
    if ([self.selectedNodes containsObject:node]) {
        [self.selectedNodes removeObject:node];
        [self reload];
        if (self.deleteNode) {
            self.deleteNode(node);
        }
    }
}

//
-(void)hideList{
    [self.tableView removeFromSuperview];
    [self.maskView removeFromSuperview];
}
-(void)showList{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.maskView];
    [self.maskView addSubview:self.tableView];
    [self.maskView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(KHEIGHT-self.frame.size.height);
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(340);
    }];
}

#pragma mark ----
-(NSMutableArray *)selectedNodes{
    if (_selectedNodes == nil) {
        _selectedNodes = @[].mutableCopy;
    }
    return _selectedNodes;
}

-(void)setTotalNodes:(NSInteger)totalNodes{
    _totalNodes = totalNodes;
    [self reload];
}

-(UIView *)maskView{
    if (_maskView == nil) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = kColorWithRGBA(0, 0, 0, 0.3);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideList)];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}
-(UITableView *)tableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
#pragma mark ---- Action
//投票action
- (IBAction)voteAction:(UIButton *)sender {
    if(self.subVote){
        self.subVote();
    }
}
//显示选中的节点列表
- (IBAction)showListAction:(UIButton *)sender {
    [self showList];
}
//清空
-(void)clearAll{
    for (Node *node in self.selectedNodes) {
        node.isVoted = NO;
        if (self.deleteNode) {
            self.deleteNode(node);
        }
    }
    [self.selectedNodes removeAllObjects];
    [self reload];
}
#pragma mark ---- UITableViewDatasource && delegete
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.selectedNodes.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VoteDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([VoteDetailCell class]) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellId];
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    }
    Node *node = self.selectedNodes[indexPath.row];
    cell.node = node;
    __block __weak typeof(self) tmpSelf = self;
    cell.deleteBlock = ^(Node * _Nonnull node) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [tmpSelf deleteNode:node];
        });
    };
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, 35)];
    
    UILabel *la = [[UILabel alloc] init];
    la.text = NSLocalizedString(@"selectedNodes", @"已选节点");
    la.font = AdaptedFontSize(13);
    la.textColor = kColorAuxiliary2;
    
    UIButton *clearBtn = [[UIButton alloc] init];
    [clearBtn setTitle:NSLocalizedString(@"clear", @"清空") forState:UIControlStateNormal];
    [clearBtn setImage:[UIImage imageNamed:@"remove"] forState:UIControlStateNormal];
    [clearBtn setTitleColor:kColorBlue forState:UIControlStateNormal];
    clearBtn.titleLabel.font = AdaptedFontSize(13);
    [clearBtn addTarget:self action:@selector(clearAll) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:la];
    [view addSubview:clearBtn];
    
    [la mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(20);
    }];
    [clearBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(la.mas_centerY);
        make.right.mas_equalTo(-15);
    }];
    
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}
@end
