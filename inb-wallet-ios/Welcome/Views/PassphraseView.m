//
//  PassphraseView.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/4.
//  Copyright © 2019 apple. All rights reserved.
//

#import "PassphraseView.h"
#import "MnemonicWordCell.h"

#define cellId  @"menmonicWordCell"

#define kNumberColumn_3 3  //3列
#define kNumberColumn_4 4  //4列

#define kSpacingColumn_3 25 //3列时的列间距
#define kSpacingColumn_4 10 //4列时的列间距

#define kPaddingSection_top_3 15
#define kPaddingSection_left_3 20
#define kPaddingSection_bottom_3 15
#define kPaddingSection_right_3 20

#define kPaddingSection_top_4 20
#define kPaddingSection_left_4 15
#define kPaddingSection_bottom_4 20
#define kPaddingSection_right_4 15

#define kSpaceingLine

@interface PassphraseView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong) UICollectionViewFlowLayout *layout;
@end
@implementation PassphraseView

-(instancetype)init{
    if (self = [super init]) {
        self.colunNumber = 4; //默认四个
        [self addSubview:self.collectionView];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MnemonicWordCell class]) bundle:nil] forCellWithReuseIdentifier:cellId];
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.left.mas_equalTo(0);
        }];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.collectionView];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.left.mas_equalTo(0);
        }];
    }
    return self;
}

-(UICollectionViewFlowLayout *)layout{
    if (_layout == nil) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumLineSpacing = 8;
        _layout.minimumInteritemSpacing = 8;
//        _layout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize;
        if (self.colunNumber == kNumberColumn_3) {
            _layout.sectionInset = UIEdgeInsetsMake(kPaddingSection_top_3, kPaddingSection_left_3, kPaddingSection_bottom_3, kPaddingSection_right_3);//section的内边距
        }else{
            _layout.sectionInset = UIEdgeInsetsMake(kPaddingSection_top_4, kPaddingSection_left_4, kPaddingSection_bottom_4, kPaddingSection_right_4);//section的内边距
        }
    }
    return _layout;
}
-(UICollectionView *)collectionView{
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:self.layout];
        _collectionView.scrollEnabled = NO;
    }
    return _collectionView;
}


-(void)setWords:(NSArray *)words{
    _words = nil;
    _words = words;
    
    [self.collectionView reloadData];
    [self.collectionView.collectionViewLayout invalidateLayout];//在reloadData之后将当前的布局设置失效invalidateLayout，则collectionView会重新刷新布局，不会沿用旧的布局导致获取不到数据，导致崩溃。
}

-(void)deleteItem:(NSInteger) index{
    MnemonicWordCell * cell = (MnemonicWordCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    cell.wordLabel.backgroundColor = [UIColor whiteColor];
    cell.wordLabel.layer.borderWidth = 1;
    cell.wordLabel.layer.borderColor = kColorSeparate.CGColor;
    cell.wordLabel.textColor = kColorAuxiliary2;
    
}
#pragma mark ---- UICollectionDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.words.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MnemonicWordCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.wordLabel.text = self.words[indexPath.row];
    cell.deleteImg.hidden = YES;
    if (self.isEditable) {
        if (self.lastNumber-1 == indexPath.row) {
            cell.deleteImg.hidden = NO;
        }
        cell.wordLabel.backgroundColor = kColorBackground;
        cell.wordLabel.layer.borderWidth = 1;
        cell.wordLabel.layer.borderColor = kColorBackground.CGColor;
        cell.wordLabel.textColor = kColorTitle;
    }else{
        cell.wordLabel.backgroundColor = [UIColor whiteColor];
        cell.wordLabel.layer.borderWidth = 1;
        cell.wordLabel.layer.borderColor = kColorSeparate.CGColor;
        cell.wordLabel.textColor = kColorAuxiliary2;
    }
    return cell;
}
#pragma mark ---- UICollectionDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
     NSString *item = self.words[indexPath.row];
    
    if (self.isEditable) {
        if (self.lastNumber == 0) {
            return;
        }else if (self.lastNumber-1 == indexPath.row){
            if (self.didDeleteItem) {
                self.didDeleteItem(item);
            }
        }
    }else{
        MnemonicWordCell *cell = (MnemonicWordCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.wordLabel.backgroundColor = kColorBlue;
        cell.wordLabel.textColor = [UIColor whiteColor];
        if (self.didDeleteItem) {
            self.didDeleteItem(item);
        }
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat ff = self.colunNumber==kNumberColumn_3?kSpacingColumn_3:kSpacingColumn_4;
    CGFloat padding = self.colunNumber == kNumberColumn_3 ? kPaddingSection_left_3 : kPaddingSection_left_4;
    CGFloat cellWidth = (collectionView.contentSize.width-padding*2 - (self.colunNumber + 1)*ff) / self.colunNumber;
    
    return CGSizeMake(cellWidth, 30);
}
//两行cell之间的间距，列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (self.colunNumber == kNumberColumn_3) {
        return kSpacingColumn_3;
    }else{
        return kSpacingColumn_4;
    }
}
//两列cell之间的间距，行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}

@end
