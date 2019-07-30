//
//  AppVersion.h
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/7/9.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppVersion : NSObject
@property(nonatomic, strong) NSString *appName; //app名字
@property(nonatomic, assign) int versionCode; //版本号
@property(nonatomic, strong) NSString *versionName;//app的版本
@property(nonatomic, assign) int appType; //app类型

@property(nonatomic, assign) long uid;
@property(nonatomic, assign) long updatedAdminId; //更新管理者的ID
@property(nonatomic, assign) long createdAdminId; //创建的管理员ID

@property(nonatomic, assign) double createdTime; //创建时间
@property(nonatomic, assign) double updatedTime; //更新时间
@property(nonatomic, assign) double onlineTime; //上线时间
@property(nonatomic, assign) double submitTime; //提交时间

@property(nonatomic, assign) int downloadFromWeb;
@property(nonatomic, strong) NSString *downloadUrl; //下载链接
@property(nonatomic, strong) NSString *flavor;
@property(nonatomic, assign) int isForceUpdate; //有没有弹出框，1、没有 2、有
@property(nonatomic, assign) int onlineStatus; //上线状态

@property(nonatomic, strong) NSString *releaseNote; //发布日志

@end

NS_ASSUME_NONNULL_END
