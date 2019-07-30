//
//  SliderBar.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/12.
//  Copyright © 2019 apple. All rights reserved.
//

#import "SliderBar.h"

#define tagBase 100

@interface SliderBar()
@property(nonatomic, strong) NSMutableArray *items;

@property(nonatomic, strong) UILabel *selectedItem;

@property(nonatomic, strong) UIImageView *cursorImg;//游标

@end

@implementation SliderBar

-(instancetype)init{
    if (self = [super init]) {
        self.items = [NSMutableArray array];
        [self addSubview:self.cursorImg];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.items = [NSMutableArray array];
        [self addSubview:self.cursorImg];
    }
    return self;
}
-(void)addItems:(NSArray *)items{
    if (items.count <= 0) {
        return;
    }
    UILabel *lastItem = nil;
    [self.items removeAllObjects];
    for (NSString *str in items) {
        UILabel *la = [[UILabel alloc] init];
        la.text = str;
        if (self.itemTitleFont) {
            la.font = self.itemTitleFont;
        }else{
            la.font = AdaptedBoldFontSize(16);
        }
        if (self.itemTitleColor) {
            la.textColor = self.itemTitleColor;
        }else{
            la.textColor = kColorWithRGBA(1, 1, 1, 0.6);
        }
        [self addSubview:la];
        [la mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self);
            if (lastItem) {
                make.left.mas_equalTo(lastItem.mas_right).mas_offset(AdaptedWidth(60));
            }else{
                make.left.mas_equalTo(self);
            }
            
            if ([[items lastObject] isEqualToString:str]) {
                make.right.mas_equalTo(self);
            }
            
        }];
        lastItem = la;
        
        la.userInteractionEnabled = YES;
        la.tag = tagBase + self.items.count;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction:)];
        [la addGestureRecognizer:tap];
        [self.items addObject:la];
    }
    self.selectedItem = [self.items firstObject];
}

-(void)clickAction:(UITapGestureRecognizer *)tapGesture{
    UILabel *clickItem = (UILabel *)tapGesture.view;
    NSInteger index = clickItem.tag - tagBase;
    
    self.selectedIndex = index;
    if (self.itemClick) {
        self.itemClick(self.selectedIndex);
    }
}


-(void)setItemsTitle:(NSArray *)itemsTitle{
    _itemsTitle = itemsTitle;
    [self addItems:_itemsTitle];
}

-(void)setSelectedIndex:(NSInteger)selectedIndex{
    if (selectedIndex >= self.items.count) {
        return;
    }
    
    self.selectedItem.textColor = self.itemTitleColor;
    self.selectedItem.font = self.itemTitleSelectedFont;
    
    _selectedIndex = selectedIndex;
    self.selectedItem = [self.items objectAtIndex:_selectedIndex];
    self.selectedItem.textColor = self.itemTitleSelectedColor;
    self.selectedItem.font = self.itemTitleSelectedFont;
    
    [self.cursorImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.selectedItem);
        make.top.mas_equalTo(self.selectedItem.mas_bottom).mas_offset(AdaptedHeight(7));
        make.height.mas_equalTo(AdaptedHeight(3));
        make.bottom.mas_equalTo(self);
    }];
    
}

-(UIImageView *)cursorImg{
    if (_cursorImg == nil) {
        UIImage *img = [UIImage imageNamed:@"cursor"];
        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height/2.0, img.size.width/2.0, img.size.height/2.0, img.size.width/2.0) resizingMode:UIImageResizingModeStretch];
        _cursorImg = [[UIImageView alloc] initWithImage:img];
    }
    return _cursorImg;
}

@end
