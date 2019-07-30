//
//  StorageManager.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/22.
//  Copyright © 2019 apple. All rights reserved.
//

#import "StorageManager.h"

@implementation StorageManager
static LocalFileStorage *storage = nil;

+(LocalFileStorage *)storage{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        storage = [[LocalFileStorage alloc] init];
    });
    return storage;
}
@end
