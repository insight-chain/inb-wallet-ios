//
//  LXAlertView.h
//  LXAlertViewDemo
//
//  Created by 刘鑫 on 16/4/15.
//  Copyright © 2016年 liuxin. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , LXAShowAnimationStyle) {
    LXASAnimationDefault    = 0,
    LXASAnimationLeftShake  ,
    LXASAnimationTopShake   ,
    LXASAnimationNO         ,
};

typedef void(^LXAlertClickIndexBlock)(NSInteger clickIndex);


@interface LXAlertView : UIView

{
    NSString *_cancelFun;
    NSString *_certainFun;
}

@property (assign, nonatomic) id delegateId;

@property (nonatomic,strong)UIView *alertWinView;
@property (nonatomic,strong)UIView *alertView;
@property (nonatomic,strong)UILabel *messageLab;

@property (retain, nonatomic) NSString *cancelFun;

@property (retain, nonatomic) NSString *certainFun;


@property (nonatomic,copy)LXAlertClickIndexBlock clickBlock;

@property (nonatomic,assign)LXAShowAnimationStyle animationStyle;

/**
 *  初始化alert方法（根据内容自适应大小，目前只支持1个按钮或2个按钮）
 *
 *  @param title         标题
 *  @param message       内容（根据内容自适应大小）
 *  @param cancelTitle   取消按钮
 *  @param otherBtnTitle 其他按钮
 *  @param block         点击事件block
 *
 *  @return 返回alert对象
 */
-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelBtnTitle:(NSString *)cancelTitle otherBtnTitle:(NSString *)otherBtnTitle clickIndexBlock:(LXAlertClickIndexBlock)block;

-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelBtnTitle:(NSString *)cancelTitle otherBtnTitle:(NSString *)otherBtnTitle  otherImageView:(NSString *)imageNameStr clickIndexBlock:(LXAlertClickIndexBlock)block;

/**
 大meesage字号
 */
- (id)initBigMesaageAlert:(id)delegate titleContent:(NSString *)titleContent messageContent:(NSString *)messageContent cancelButtonTitle:(NSString *) cacelButtonTitle cancelFun:(NSString*)cancel certainButtonTitle:(NSString *)certainButtonTitle certainFun:(NSString *)certain;

- (id)initAlert:(id)delegate titleContent:(NSString *)titleContent messageContent:(NSString *)messageContent cancelButtonTitle:(NSString *) cacelButtonTitle cancelFun:(NSString*)cancel certainButtonTitle:(NSString *)certainButtonTitle certainFun:(NSString *)certain;
/** 使用NSAttributeString **/
-(id)initAlert:(id)delegate attriTitleContent:(NSAttributedString *)titleContent attributeMessageContent:(NSAttributedString *)messageContent cancelButtonTitle:(NSString *)cancelButtonTitle cancelFun:(NSString *)cancel certainButtonTitle:(NSString *)certainButtonTitle certainFun:(NSString *)certain;
/** 版本更新提示Alert **/
-(instancetype)initUpdataAlert:(id)delegate titleContent:(NSString *)titleContent messageContent:(NSString *)messageContent  certainButtonTitle:(NSString *)certainButtonTitle certainFun:(NSString *)certain;

/**  用于提示的警告框*/
-(instancetype)initTipsAlert:(id)delegate titleContent:(NSString *)titleContent messageContent:(NSString *)messageContent  certainButtonTitle:(NSString *)certainButtonTitle certainFun:(NSString *)certain;

/**  用于提示的信息提示框*/
-(instancetype)initTipsLongMessageAlert:(id)delegate titleContent:(NSString *)titleContent messageContent:(NSAttributedString *)messageContent  certainButtonTitle:(NSString *)certainButtonTitle certainFun:(NSString *)certain;
/**  答题的倒计时*/
-(instancetype)initWithOtherImageView:(NSString *)imageNameStr;
/**
 *  showLXAlertView
 */
-(void)showLXAlertViewWithFlag:(NSInteger)flag;

/**
 *  不隐藏，默认为NO。设置为YES时点击按钮alertView不会消失（适合在强制升级时使用）
 */
@property (nonatomic,assign)BOOL dontDissmiss;

-(void)dismissAlertView;
@end



@interface UIImage (colorful)
//a image using a color
+ (UIImage *)imageWithColor:(UIColor *)color;

@end
