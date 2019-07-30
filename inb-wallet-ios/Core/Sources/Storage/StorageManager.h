//
//  StorageManager.h
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/22.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalFileStorage.h"

NS_ASSUME_NONNULL_BEGIN



@interface StorageManager : NSObject

+(LocalFileStorage *)storage;

@end

NS_ASSUME_NONNULL_END
