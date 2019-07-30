//
//  Config.h
//  wallet
//
//  Created by apple on 2019/3/28.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Config : NSObject


+(Config *)current;
+(UInt64)dbMigrationSchemaVersion;
@end

NS_ASSUME_NONNULL_END
