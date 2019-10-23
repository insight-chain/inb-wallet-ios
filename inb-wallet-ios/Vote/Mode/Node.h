//
//  Node.h
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/6/18.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//
/** 节点数据模型 **/
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Node : NSObject
@property(nonatomic, strong) NSString *intro; //介绍

@property(nonatomic, assign) int type; //节点类型：1、超级节点 2、普通节点

@property(nonatomic, assign) int voteTotalNumber;
@property(nonatomic, assign) int voteNumber; //投票数
@property(nonatomic, assign) double    voteRatio; //百分比 0-1
@property(nonatomic, assign) BOOL isVoted; //是否投过该节点，YES：投过， NO：没投过（默认）

@property(nonatomic, strong) NSString *nodeId;
@property(nonatomic, strong) NSString *name; //节点名称
@property(nonatomic, strong) NSString *address; //节点地址
@property(nonatomic, strong) NSString *city; //城市
@property(nonatomic, strong, readonly) NSString *countryName; //国家
@property(nonatomic, strong) NSString *countryCode;
@property(nonatomic, strong) NSString *email; //邮箱
@property(nonatomic, strong) NSString *data; //信息字段。。json格式字符串
@property(nonatomic, strong) NSString *ID; // id
@property(nonatomic, strong) NSString *image;
@property(nonatomic, strong) NSString *host; //ip地址
@property(nonatomic, strong) NSString *port; //端口
@property(nonatomic, assign) int vote;
@property(nonatomic, strong) NSString *webSite; //网址

@property(nonatomic, strong) NSString *lastUp;
@property(nonatomic, strong) NSString *lastUpdated;
@property(nonatomic, strong) NSString *longitude;
@property(nonatomic, strong) NSString *latitude;
@property(nonatomic, assign) NSInteger up;

@property(nonatomic, strong) NSString *dateCreated; //创建时间
@property (nonatomic, strong) NSString *rewardAccount; //领取地址

@property(nonatomic, strong) NSString *serverIntro; //服务器描述
@property(nonatomic, strong) NSString *twitter; //
@property(nonatomic, strong) NSString *telegraph;
@property(nonatomic, strong) NSString *wechat;
@property(nonatomic, strong) NSString *facebook;

@end

NS_ASSUME_NONNULL_END
